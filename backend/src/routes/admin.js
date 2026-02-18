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

// @route   GET /api/admin/ledger
// @desc    Get the admin ledger for provider earnings
// @access  Private (Admin only)
router.get('/ledger', adminController.getLedger);

module.exports = router;
