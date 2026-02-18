const express = require('express');
const router = express.Router();
const reviewController = require('../controllers/reviewController');
const { authMiddleware, isClient } = require('../middleware/authMiddleware');

// @route   POST /api/reviews
// @desc    Client creates a review for a completed job
// @access  Private (Client only)
router.post('/', authMiddleware, isClient, reviewController.createReview);

module.exports = router;
