const express = require('express');
const router = express.Router();
const jobController = require('../controllers/jobController');
const { authMiddleware, isClient, isProvider } = require('../middleware/authMiddleware');

// @route   POST /api/jobs
// @desc    Client creates a new job request
// @access  Private (Client only)
router.post('/', authMiddleware, isClient, jobController.createJob);

// @route   POST /api/jobs/:id/accept
// @desc    Provider accepts a job
// @access  Private (Provider only)
router.post('/:id/accept', authMiddleware, isProvider, jobController.acceptJob);

// @route   POST /api/jobs/:id/finish
// @desc    Provider marks a job as finished
// @access  Private (Provider only)
router.post('/:id/finish', authMiddleware, isProvider, jobController.finishJob);

// @route   GET /api/jobs/provider/schedule
// @desc    Get schedule for the current provider
// @access  Private (Provider only)
router.get('/provider/schedule', authMiddleware, isProvider, jobController.getProviderSchedule);

// @route   GET /api/jobs/incoming
// @desc    Get incoming jobs for the current provider
// @access  Private (Provider only)
router.get('/incoming', authMiddleware, isProvider, jobController.getIncomingJobs);

// @route   GET /api/jobs/client
// @desc    Get job history for the current client
// @access  Private (Client only)
router.get('/client', authMiddleware, isClient, jobController.getJobsForClient);

// @route   GET /api/jobs/user/:userId
// @desc    Get job history for a user (client or provider)
// @access  Private (Authenticated users)
router.get('/user/:userId', authMiddleware, jobController.getJobHistory);

module.exports = router;
