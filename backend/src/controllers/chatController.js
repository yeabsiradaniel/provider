const chatService = require('../services/chatService');

const getMessages = async (req, res) => {
    try {
        const messages = await chatService.getMessages(req.params.jobId, req.user.id);
        res.status(200).json(messages);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching messages.', error: error.message });
    }
};

const postMessage = async (req, res) => {
    try {
        const message = await chatService.createMessage(req.user.id, req.body);
        res.status(201).json(message);
    } catch (error) {
        res.status(500).json({ message: 'Error posting message.', error: error.message });
    }
};

module.exports = {
    getMessages,
    postMessage,
};
