const express = require('express');
const router = express.Router();
const categoryController = require('../controllers/categoryController');

// @route   GET /api/categories
// @desc    Get all service categories and their sub-categories
// @access  Public
router.get('/', categoryController.getCategories);

module.exports = router;
