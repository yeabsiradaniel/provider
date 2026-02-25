const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const { authMiddleware } = require('../middleware/authMiddleware');

// @route   GET /api/chat/conversations
// @desc    Get all of a user's conversations (works for client and provider)
// @access  Private
router.get('/conversations', authMiddleware, chatController.getConversations);

// @route   GET /api/chat/:jobId/messages
// @desc    Get all messages for a specific job
// @access  Private
router.get('/:jobId/messages', authMiddleware, chatController.getMessages);

module.exports = router;
