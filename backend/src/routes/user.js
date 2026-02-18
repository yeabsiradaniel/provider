const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { authMiddleware } = require('../middleware/authMiddleware');

const upload = require('../middleware/uploadMiddleware');

// @route   GET /api/users/me
// @desc    Get current user's profile
// @access  Private
router.get('/me', authMiddleware, userController.getMe);

// @route   PUT /api/users/me
// @desc    Update current user's profile
// @access  Private
router.put('/me', authMiddleware, userController.updateMe);

// @route   POST /api/users/me/upload-photo
// @desc    Upload a new profile photo
// @access  Private
router.post('/me/upload-photo', authMiddleware, upload, userController.uploadProfilePhoto);

// @route   GET /api/users/photo/:fileId
// @desc    Get a photo from GridFS
// @access  Public
router.get('/photo/:fileId', userController.getPhoto);

// @route   GET /api/users/:userId
// @desc    Get a user's profile
// @access  Public
router.get('/:userId', userController.getUser);

module.exports = router;
