const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const { authMiddleware, isAdmin } = require('../middleware/authMiddleware');

// All routes in this file are protected and for admins only
router.use(authMiddleware);
router.use(isAdmin);

// @route   GET /api/admin/providers/pending
// @desc    Get list of providers pending verification
// @access  Private (Admin only)
router.get('/providers/pending', adminController.getPendingProviders);

// @route   POST /api/admin/providers/:id/verify
// @desc    Verify a provider
// @access  Private (Admin only)
router.post('/providers/:id/verify', adminController.verifyProvider);

// @route   POST /api/admin/providers/:id/unverify
// @desc    Un-verify a provider
// @access  Private (Admin only)
router.post('/providers/:id/unverify', adminController.unverifyProvider);

// @route   GET /api/admin/ledger
// @desc    Get the admin ledger for provider earnings
// @access  Private (Admin only)
router.get('/ledger', adminController.getLedger);

// User Management Routes
// @route   GET /api/admin/users
// @desc    Get all users
// @access  Private (Admin only)
router.get('/users', adminController.getAllUsers);

// @route   POST /api/admin/users
// @desc    Create a new user
// @access  Private (Admin only)
router.post('/users', adminController.createUser);

// @route   PUT /api/admin/users/:id
// @desc    Update a user by ID
// @access  Private (Admin only)
router.put('/users/:id', adminController.updateUser);

// @route   DELETE /api/admin/users/:id
// @desc    Delete a user by ID
// @access  Private (Admin only)
router.delete('/users/:id', adminController.deleteUser);

// Provider Profile Management Routes
// @route   GET /api/admin/provider-profiles
// @desc    Get all provider profiles
// @access  Private (Admin only)
router.get('/provider-profiles', adminController.getAllProviderProfiles);

// @route   PUT /api/admin/provider-profiles/:id
// @desc    Update a provider profile by ID
// @access  Private (Admin only)
router.put('/provider-profiles/:id', adminController.updateProviderProfile);

// Category Management Routes
// @route   POST /api/admin/categories
// @desc    Create a new category
// @access  Private (Admin only)
router.post('/categories', adminController.createCategory);

// @route   PUT /api/admin/categories/:id
// @desc    Update a category by ID
// @access  Private (Admin only)
router.put('/categories/:id', adminController.updateCategory);

// @route   DELETE /api/admin/categories/:id
// @desc    Delete a category by ID
// @access  Private (Admin only)
router.delete('/categories/:id', adminController.deleteCategory);

// Job Management Routes
// @route   GET /api/admin/jobs
// @desc    Get all jobs
// @access  Private (Admin only)
router.get('/jobs', adminController.getAllJobs);

// @route   PUT /api/admin/jobs/:id
// @desc    Update a job by ID
// @access  Private (Admin only)
router.put('/jobs/:id', adminController.updateJob);

// @route   DELETE /api/admin/jobs/:id
// @desc    Delete a job by ID
// @access  Private (Admin only)
router.delete('/jobs/:id', adminController.deleteJob);

// Review Management Routes
// @route   GET /api/admin/reviews
// @desc    Get all reviews
// @access  Private (Admin only)
router.get('/reviews', adminController.getAllReviews);

// @route   DELETE /api/admin/reviews/:id
// @desc    Delete a review by ID
// @access  Private (Admin only)
router.delete('/reviews/:id', adminController.deleteReview);

// Dashboard Route
// @route   GET /api/admin/dashboard
// @desc    Get aggregated stats for the admin dashboard
// @access  Private (Admin only)
router.get('/dashboard', adminController.getDashboardStats);

// @route   GET /api/admin/stats/jobs-by-month
// @desc    Get job counts aggregated by month
// @access  Private (Admin only)
router.get('/stats/jobs-by-month', adminController.getJobsByMonthStats);


module.exports = router;
