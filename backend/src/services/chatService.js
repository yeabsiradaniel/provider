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

    // Update the parent job to refresh the 'updatedAt' timestamp.
    // This ensures the conversation moves to the top of the list.
    await Job.findByIdAndUpdate(jobId, { updatedAt: new Date() });

    return message;
};

const getConversations = async (user) => {
    const userId = user.id;
    const userRole = user.role;

    let matchQuery;

    if (userRole === 'provider') {
        matchQuery = { providerId: userId };
    } else { // Assumes 'client'
        matchQuery = { clientId: userId };
    }

    const jobs = await Job.find({
        ...matchQuery,
        status: { $in: ['PENDING', 'ACCEPTED', 'ACTIVE', 'COMPLETED'] }
    })
    .populate('clientId', 'firstName lastName profilePhoto phone role')
    .populate('providerId', 'firstName lastName profilePhoto phone role')
    .sort({ updatedAt: -1 }); 

    return jobs;
};
module.exports = {
    getMessages,
    createMessage,
    getConversations,
};
