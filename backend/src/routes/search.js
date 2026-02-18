const express = require('express');
const router = express.Router();
const searchController = require('../controllers/searchController');
const { authMiddleware } = require('../middleware/authMiddleware'); // Assuming search requires authentication

// @route   GET /api/search/suggestions
// @desc    Get search suggestions for categories and providers
// @access  Private (Authenticated users) - can be public if needed
router.get('/suggestions', authMiddleware, searchController.getSuggestions);

module.exports = router;
