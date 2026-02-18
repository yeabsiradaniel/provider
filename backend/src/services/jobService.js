// Service for job lifecycle management
const Job = require('../models/Job');
const AdminLedger = require('../models/AdminLedger');
const User = require('../models/User');

const createJob = async (clientId, jobData) => {
    const job = new Job({ ...jobData, clientId });
    await job.save();
    return job;
};

const acceptJob = async (jobId, providerId) => {
    const job = await Job.findById(jobId);
    if (!job || job.status !== 'PENDING') {
        throw new Error('Job not available for acceptance.');
    }
    job.providerId = providerId;
    job.status = 'ACCEPTED';
    job.acceptedAt = new Date();
    await job.save();
    // In a real app, you would now "reveal" phone numbers,
    // perhaps by sending a notification or updating a shared resource.
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

    // Update provider's earnings
    const providerProfile = await ProviderProfile.findOne({ userId: providerId });
    if (providerProfile && job.agreedPrice) {
        providerProfile.earnings += job.agreedPrice;
        await providerProfile.save();
    }

    // Record ledger entry for admin
    const commission = (job.agreedPrice || 0) * 0.1; // Example 10% commission
    const ledgerEntry = new AdminLedger({
        providerId,
        jobId,
        amount: commission,
    });
    await ledgerEntry.save();

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
    return await Job.find({ clientId })
        .populate('clientId', 'firstName lastName profilePhoto phone role')
        .populate('providerId', 'firstName lastName profilePhoto phone role')
        .sort({ createdAt: -1 });
};

const ProviderProfile = require('../models/ProviderProfile');

const getIncomingJobs = async (providerId) => {
    try {
        const providerProfile = await ProviderProfile.findOne({ userId: providerId });
        if (!providerProfile) {
            throw new Error('Provider profile not found.');
        }

        const jobs = await Job.find({
            status: 'PENDING',
            serviceCategory: { $in: providerProfile.serviceCategories },
        }).populate('clientId', 'firstName lastName profilePhoto phone role');

        return jobs;
    } catch (error) {
        console.error('Error in getIncomingJobs:', error);
        throw error;
    }
};

const getProviderSchedule = async (providerId) => {
    const populateFields = 'clientId providerId';
    const populateProjection = 'firstName lastName profilePhoto phone role';

    // Fetch pending jobs, sorted by date
    const pendingJobs = await Job.find({ providerId, status: 'PENDING' })
        .populate(populateFields, populateProjection)
        .sort({ createdAt: -1 });
    
    // Fetch other jobs, sorted by date
    const otherJobs = await Job.find({
        providerId,
        status: { $in: ['ACCEPTED', 'COMPLETED'] },
    })
    .populate(populateFields, populateProjection)
    .sort({ createdAt: -1 });

    const jobs = [...pendingJobs, ...otherJobs];

    return jobs;
};

module.exports = {
    createJob,
    acceptJob,
    finishJob,
    getJobHistory,
    getJobsForClient,
    getIncomingJobs,
    getProviderSchedule,
};
