const chatService = require('../services/chatService');

const getMessages = async (req, res) => {
    try {
        const messages = await chatService.getMessages(req.params.jobId, req.user.id);
        res.status(200).json(messages);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching messages.', error: error.message });
    }
};

const getConversations = async (req, res) => {
    try {
        // The user object (with role) is attached by the authMiddleware
        const conversations = await chatService.getConversations(req.user);
        res.status(200).json(conversations);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching conversations.', error: error.message });
    }
};

module.exports = {
    getMessages,
    getConversations,
};
