const Message = require('../models/Message');
const Job = require('../models/Job');

const getMessages = async (jobId, userId) => {
    // Security check: Ensure the user is part of this job's conversation
    const job = await Job.findById(jobId);
    if (!job) {
        throw new Error('Job not found.');
    }
    if (job.clientId.toString() !== userId.toString() && job.providerId.toString() !== userId.toString()) {
        throw new Error('User not authorized to view this chat.');
    }

    return await Message.find({ jobId }).sort({ createdAt: 'asc' });
};

const createMessage = async (senderId, messageData) => {
    const { jobId, receiverId, text } = messageData;
    
    const message = new Message({
        jobId,
        senderId,
        receiverId,
        text
    });
    await message.save();
    return message;
};

module.exports = {
    getMessages,
    createMessage,
};
