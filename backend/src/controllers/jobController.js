const jobService = require('../services/jobService');

const createJob = async (req, res) => {
    try {
        console.log('[JOB-TRACE] createJob controller initiated by user:', req.user.id);
        const job = await jobService.createJob(req.user.id, req.body);
        console.log('[JOB-TRACE] Job created in database:', JSON.stringify(job, null, 2));
        
        // Emit real-time event to the specific provider
        const providerRoom = job.providerId.toString();
        console.log(`[JOB-TRACE] Emitting 'newJobRequest' to room: ${providerRoom} for job: ${job._id}`);
        req.io.to(providerRoom).emit('newJobRequest', job);
        
        res.status(201).json(job);
    } catch (error) {
        console.error('[JOB-TRACE] Error in createJob controller:', error);
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
        console.log('[SOCKET-TRACE] finishJob controller triggered', { jobId: req.params.id, providerId: req.user.id });
        const job = await jobService.finishJob(req.params.id, req.user.id);
        console.log('[SOCKET-TRACE] Job status updated to COMPLETED in DB', { jobId: job._id.toString(), clientId: job.clientId.toString() });
        
        // Emit the event ONLY to the client.
        const clientRoom = job.clientId.toString();
        req.io.to(clientRoom).emit('jobFinished', job);
        
        console.log('[SOCKET-TRACE] Emitting jobFinished to client room', { room: clientRoom, jobId: job._id.toString() });
        
        res.status(200).json(job);
    } catch (error) {
        console.error('[SOCKET-TRACE] Error in finishJob controller', { jobId: req.params.id, providerId: req.user.id, error: error.message });
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

const getUnratedJobForClient = async (req, res) => {
    try {
        const job = await jobService.getUnratedJobForClient(req.user.id);
        res.status(200).json(job);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching unrated job.', error: error.message });
    }
};

const declineJob = async (req, res) => {
    try {
        const job = await jobService.declineJob(req.params.id, req.user.id);
        // Optionally notify the client in real-time
        // req.io.to(job.clientId.toString()).emit('jobDeclined', job);
        res.status(200).json(job);
    } catch (error) {
        res.status(400).json({ message: 'Error declining job.', error: error.message });
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
    getUnratedJobForClient,
    declineJob,
};
