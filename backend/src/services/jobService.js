// Service for job lifecycle management
const Job = require('../models/Job');
const User = require('../models/User');
const ProviderProfile = require('../models/ProviderProfile');

const createJob = async (clientId, jobData) => {
    const job = new Job({ ...jobData, clientId });
    await job.save();
    return job;
};

const acceptJob = async (jobId, providerId) => {
    // For 1-to-1 model, we must verify the job is assigned to this provider.
    const job = await Job.findOne({ _id: jobId, providerId: providerId });

    if (!job) {
        throw new Error('Job not found or you are not authorized to perform this action.');
    }

    if (job.status !== 'PENDING') {
        throw new Error('This job is no longer pending and cannot be accepted.');
    }

    job.status = 'ACCEPTED';
    job.acceptedAt = new Date();
    await job.save();
    return job;
};

const finishJob = async (jobId, providerId) => {
    const job = await Job.findOne({ _id: jobId, providerId });
    if (!job || (job.status !== 'ACCEPTED' && job.status !== 'ACTIVE')) {
        throw new Error('Job cannot be completed.');
    }
    job.status = 'COMPLETED';
    job.completedAt = new Date();
    await job.save();

    return job;
};

const getJobHistory = async (userId) => {
    return await Job.find({
        $or: [{ clientId: userId }, { providerId: userId }],
    }).populate('clientId', 'firstName lastName profilePhoto phone role')
      .populate('providerId', 'firstName lastName profilePhoto phone role')
      .sort({ createdAt: -1 });
};

const getJobsForClient = async (clientId) => {
    return await Job.find({ clientId, status: { $ne: 'DECLINED' } })
        .populate('clientId', 'firstName lastName profilePhoto phone role')
        .populate('providerId', 'firstName lastName profilePhoto phone role')
        .sort({ createdAt: -1 });
};

const getIncomingJobs = async (providerId) => {
    // Corrected to 1-to-1 model: Find jobs specifically assigned to this provider with status 'PENDING'.
    const jobs = await Job.find({
        providerId: providerId,
        status: 'PENDING',
    }).populate('clientId', 'firstName lastName profilePhoto phone role')
      .sort({ createdAt: -1 });

    return jobs;
};

const getProviderSchedule = async (providerId) => {
    // Corrected to only show jobs that are accepted or completed. 
    // Pending jobs are handled by getIncomingJobs.
    const jobs = await Job.find({
        providerId,
        status: { $in: ['ACCEPTED', 'COMPLETED'] },
    })
    .populate('clientId', 'firstName lastName profilePhoto phone role')
    .sort({ createdAt: -1 });

    return jobs;
};

const getUnratedJobForClient = async (clientId) => {
    // Find the first completed job for this client that has not been rated yet.
    return await Job.findOne({
        clientId: clientId,
        status: 'COMPLETED',
        isRated: false,
    }).sort({ completedAt: -1 }); // Get the most recently completed one first
};

const declineJob = async (jobId, providerId) => {
    // For 1-to-1 model, we must verify the job is assigned to this provider.
    const job = await Job.findOne({ _id: jobId, providerId: providerId });

    if (!job) {
        throw new Error('Job not found or you are not authorized to perform this action.');
    }

    if (job.status !== 'PENDING') {
        throw new Error('This job is no longer pending and cannot be declined.');
    }

    job.status = 'DECLINED';
    await job.save();
    return job;
};

module.exports = {
    createJob,
    acceptJob,
    finishJob,
    getJobHistory,
    getJobsForClient,
    getIncomingJobs,
    getProviderSchedule,
    getUnratedJobForClient,
    declineJob,
};
