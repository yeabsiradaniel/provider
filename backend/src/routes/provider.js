const express = require('express');
const router = express.Router();
const providerController = require('../controllers/providerController');
const matchingController = require('../controllers/matchingController');
const { authMiddleware, isProvider, isClient } = require('../middleware/authMiddleware');

// --- Provider Profile & Services ---

// @route   POST /api/provider/profile
// @desc    Create or update provider profile
// @access  Private (Provider only)
router.post('/profile', authMiddleware, isProvider, providerController.createOrUpdateProfile);

// @route   GET /api/provider/profile/me
// @desc    Get current provider's profile
// @access  Private (Provider only)
router.get('/profile/me', authMiddleware, isProvider, providerController.getMe);

// @route   GET /api/provider/profile/:userId
// @desc    Get a provider's profile
// @access  Private (All authenticated)
router.get('/profile/:userId', authMiddleware, providerController.getProfile);

// @route   POST /api/provider/services
// @desc    Add or update services for a provider
// @access  Private (Provider only)
router.post('/services', authMiddleware, isProvider, providerController.updateServices);


// @route   GET /api/provider/me/availability
// @desc    Get availability for the current provider
// @access  Private (Provider only)
router.get('/me/availability', authMiddleware, isProvider, providerController.getAvailability);

// @route   PUT /api/provider/me/availability
// @desc    Update availability for the current provider
// @access  Private (Provider only)
router.put('/me/availability', authMiddleware, isProvider, providerController.updateAvailability);

// @route   GET /api/provider/me/earnings
// @desc    Get earnings data for the current provider
// @access  Private (Provider only)
router.get('/me/earnings', authMiddleware, isProvider, providerController.getEarnings);

// @route   GET /api/provider/me/dashboard
// @desc    Get dashboard metrics for the current provider
// @access  Private (Provider only)
router.get('/me/dashboard', authMiddleware, isProvider, providerController.getDashboardMetrics);

// @route   PUT /api/provider/me/status
// @desc    Update online status for the current provider
// @access  Private (Provider only)
router.put('/me/status', authMiddleware, isProvider, providerController.toggleStatus);

// @route   PUT /api/provider/me/categories
// @desc    Update service categories for the current provider
// @access  Private (Provider only)
router.put('/me/categories', authMiddleware, isProvider, providerController.updateCategories);

// @route   GET /api/providers/search
// @desc    Search for available providers by category
// @access  Private (Authenticated users)
router.get('/search', authMiddleware, providerController.searchProviders);


module.exports = router;
