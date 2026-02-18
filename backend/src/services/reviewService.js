// Service for review management
const Review = require('../models/Review');
const User = require('../models/User');
const Job = require('../models/Job');

const createReview = async (clientId, reviewData) => {
    const { jobId, rating } = reviewData;

    // Ensure the client who is reviewing was part of the job
    const job = await Job.findOne({ _id: jobId, clientId: clientId });
    if (!job) {
        throw new Error('You can only review jobs you were a client for.');
    }
     if (job.status !== 'COMPLETED') {
        throw new Error('Cannot review a job that is not completed.');
    }

    const review = new Review({
        ...reviewData,
        clientId,
        providerId: job.providerId
    });
    await review.save();

    // Update provider's average rating (this is a simplified approach)
    const stats = await Review.aggregate([
        { $match: { providerId: job.providerId } },
        { $group: { _id: '$providerId', avgRating: { $avg: '$rating' } } }
    ]);

    if (stats.length > 0) {
        await User.findByIdAndUpdate(job.providerId, { rating: stats[0].avgRating });
    }

    return review;
};

module.exports = {
    createReview,
};
