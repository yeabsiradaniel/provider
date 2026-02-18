const jobService = require('../services/jobService');

const createJob = async (req, res) => {
    try {
        const job = await jobService.createJob(req.user.id, req.body);
        res.status(201).json(job);
    } catch (error) {
        res.status(500).json({ message: 'Error creating job.', error: error.message });
    }
};

const acceptJob = async (req, res) => {
    try {
        const job = await jobService.acceptJob(req.params.id, req.user.id);
        req.io.to(job._id.toString()).emit('jobAccepted', job);
        res.status(200).json(job);
    } catch (error) {
        res.status(400).json({ message: 'Error accepting job.', error: error.message });
    }
};

const finishJob = async (req, res) => {
    try {
        const job = await jobService.finishJob(req.params.id, req.user.id);
        req.io.to(job._id.toString()).emit('jobFinished', job);
        res.status(200).json(job);
    } catch (error) {
        res.status(400).json({ message: 'Error finishing job.', error: error.message });
    }
};

const getJobHistory = async (req, res) => {
    try {
        // Ensure users can only access their own job history, unless they are an admin
        if (req.user.role !== 'admin' && req.user.id !== req.params.userId) {
            return res.status(403).json({ message: 'Forbidden: You can only view your own job history.' });
        }
        const jobs = await jobService.getJobHistory(req.params.userId);
        res.status(200).json(jobs);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching job history.', error: error.message });
    }
};

const getJobsForClient = async (req, res) => {
    try {
        const jobs = await jobService.getJobsForClient(req.user.id);
        res.status(200).json(jobs);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching jobs for client.', error: error.message });
    }
};

const getIncomingJobs = async (req, res) => {
    try {
        const jobs = await jobService.getIncomingJobs(req.user.id);
        res.status(200).json(jobs);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching incoming jobs.', error: error.message });
    }
};

const getProviderSchedule = async (req, res) => {
    try {
        const jobs = await jobService.getProviderSchedule(req.user.id);
        res.status(200).json(jobs);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching provider schedule.', error: error.message });
    }
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
