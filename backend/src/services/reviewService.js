// Service for review management
const Review = require('../models/Review');
const User = require('../models/User');
const Job = require('../models/Job');
const ProviderProfile = require('../models/ProviderProfile');
const AdminLedger = require('../models/AdminLedger');


const createReview = async (clientId, reviewData) => {
    const { jobId, rating, paidAmount } = reviewData;

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

    // Mark the job as rated
    job.isRated = true;
    job.agreedPrice = paidAmount; // Also update the job's price with what was actually paid
    await job.save();

    // Update provider's average rating (this is a simplified approach)
    const ratingStats = await Review.aggregate([
        { $match: { providerId: job.providerId } },
        { $group: { _id: '$providerId', avgRating: { $avg: '$rating' } } }
    ]);

    if (ratingStats.length > 0) {
        await User.findByIdAndUpdate(job.providerId, { rating: ratingStats[0].avgRating });
    }

    // Update provider's earnings
    const providerProfile = await ProviderProfile.findOne({ userId: job.providerId });
    if (providerProfile && paidAmount) {
        providerProfile.earnings += paidAmount;
        await providerProfile.save();
    }

    // Create ledger entries for the transaction
    if (paidAmount && paidAmount > 0) {
        const commissionAmount = paidAmount * 0.10; // 10% commission

        // 1. Record the payout to the provider
        const payoutEntry = new AdminLedger({
            jobId,
            providerId: job.providerId,
            amount: paidAmount,
            type: 'payout',
        });
        await payoutEntry.save();

        // 2. Record the commission earned by the platform
        const commissionEntry = new AdminLedger({
            jobId,
            providerId: job.providerId,
            amount: -commissionAmount, // Negative value for commission debit
            type: 'commission',
        });
        await commissionEntry.save();
    }

    return review;
};

module.exports = {
    createReview,
};
