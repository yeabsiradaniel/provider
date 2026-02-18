const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const { authMiddleware } = require('../middleware/authMiddleware');

// @route   GET /api/chat/:jobId/messages
// @desc    Get all messages for a specific job
// @access  Private
router.get('/:jobId/messages', authMiddleware, chatController.getMessages);

// @route   POST /api/chat/message
// @desc    Save a new chat message
// @access  Private
router.post('/message', authMiddleware, chatController.postMessage);

module.exports = router;
