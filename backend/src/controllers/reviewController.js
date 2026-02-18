const reviewService = require('../services/reviewService');

const createReview = async (req, res) => {
    try {
        // Basic validation
        const { jobId, rating } = req.body;
        if (!jobId || !rating) {
            return res.status(400).json({ message: 'Job ID and rating are required.' });
        }

        const review = await reviewService.createReview(req.user.id, req.body);
        res.status(201).json(review);
    } catch (error) {
        res.status(400).json({ message: 'Error creating review.', error: error.message });
    }
};

module.exports = {
    createReview,
};
