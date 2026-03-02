// Service for admin operations
const User = require('../models/User');
const AdminLedger = require('../models/AdminLedger');
const ProviderProfile = require('../models/ProviderProfile');
const Category = require('../models/Category');
const Job = require('../models/Job');
const Review = require('../models/Review');

const getPendingProviders = async () => {
    // This assumes providers have uploaded their ID and are awaiting verification.
    // The `ProviderProfile` would contain the `idPhoto` URL.
    return await User.find({ role: 'provider', verified: false });
};

const verifyProvider = async (providerId) => {
    return await User.findByIdAndUpdate(providerId, { verified: true }, { new: true });
};

const getLedger = async () => {
    // In a real app, you'd have filtering by date, provider, etc.
    return await AdminLedger.find().populate('providerId', 'firstName lastName phone').populate('jobId', 'serviceName agreedPrice').sort({ recordedAt: -1 });
};

const getAllUsers = async () => {
    return await User.find().select('-pin'); // Exclude pin from the result
};

const createUser = async (userData) => {
    // In a real app, you'd have more validation here.
    // This is a simplified version for admin creation.
    if (userData.pin) {
        const bcrypt = require('bcryptjs');
        const salt = await bcrypt.genSalt(10);
        userData.pin = await bcrypt.hash(userData.pin, salt);
    }
    const user = new User(userData);
    await user.save();
    return user;
};

const updateUser = async (userId, userData) => {
    if (userData.pin) {
        const bcrypt = require('bcryptjs');
        const salt = await bcrypt.genSalt(10);
        userData.pin = await bcrypt.hash(userData.pin, salt);
    }
    return await User.findByIdAndUpdate(userId, userData, { new: true }).select('-pin');
};

const deleteUser = async (userId) => {
    // In a real app, you might want to soft-delete or handle related documents.
    return await User.findByIdAndDelete(userId);
};

const getAllProviderProfiles = async () => {
    return await ProviderProfile.find()
        .populate('userId', '-pin')
        .populate({
            path: 'serviceCategories',
            populate: {
                path: 'category',
                model: 'Category'
            }
        });
};

const updateProviderProfile = async (profileId, profileData) => {
    return await ProviderProfile.findByIdAndUpdate(profileId, profileData, { new: true });
};

const createCategory = async (categoryData) => {
    const category = new Category(categoryData);
    await category.save();
    return category;
};

const updateCategory = async (categoryId, categoryData) => {
    return await Category.findByIdAndUpdate(categoryId, categoryData, { new: true });
};

const deleteCategory = async (categoryId) => {
    // Prevent deletion if the category has sub-categories
    const category = await Category.findById(categoryId);
    if (category && category.subCategories && category.subCategories.length > 0) {
        throw new Error('Cannot delete a category with sub-categories.');
    }
    return await Category.findByIdAndDelete(categoryId);
};

const getAllJobs = async () => {
    return await Job.find()
        .populate('clientId', 'firstName lastName phone')
        .populate('providerId', 'firstName lastName phone')
        .sort({ createdAt: -1 });
};

const updateJob = async (jobId, jobData) => {
    return await Job.findByIdAndUpdate(jobId, jobData, { new: true });
};

const deleteJob = async (jobId) => {
    return await Job.findByIdAndDelete(jobId);
};

const getAllReviews = async () => {
    return await Review.find()
        .populate('clientId', 'firstName lastName')
        .populate('providerId', 'firstName lastName')
        .populate('jobId', 'serviceName')
        .sort({ createdAt: -1 });
};

const deleteReview = async (reviewId) => {
    return await Review.findByIdAndDelete(reviewId);
};

const getDashboardStats = async () => {
    const [
        totalUsers,
        totalProviders,
        totalJobs,
        pendingProviders,
        recentJobs,
        commissionData
    ] = await Promise.all([
        User.countDocuments(),
        User.countDocuments({ role: 'provider' }),
        Job.countDocuments(),
        User.find({ role: 'provider', verified: false }).select('firstName lastName phone').limit(5),
        Job.find().sort({ createdAt: -1 }).limit(5).populate('clientId', 'firstName').populate('providerId', 'firstName'),
        AdminLedger.aggregate([
            { $match: { type: 'commission' } },
            { $group: { _id: null, total: { $sum: '$amount' } } }
        ])
    ]);

    const totalCommission = (commissionData.length > 0 ? commissionData[0].total : 0) * -1;

    return {
        totalUsers,
        totalProviders,
        totalJobs,
        totalCommission,
        pendingProviders,
        recentJobs
    };
};

const getJobsByMonthStats = async () => {
    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    const stats = await Job.aggregate([
        {
            $group: {
                _id: {
                    year: { $year: "$createdAt" },
                    month: { $month: "$createdAt" }
                },
                count: { $sum: 1 }
            }
        },
        { $sort: { "_id.year": 1, "_id.month": 1 } }
    ]);

    return stats.map(item => ({
        name: `${monthNames[item._id.month - 1]} ${item._id.year}`,
        Jobs: item.count
    }));
};

const unverifyProvider = async (providerId) => {
    return await User.findByIdAndUpdate(providerId, { verified: false }, { new: true });
};


module.exports = {
    getPendingProviders,
    verifyProvider,
    unverifyProvider,
    getLedger,
    getAllUsers,
    createUser,
    updateUser,
    deleteUser,
    getAllProviderProfiles,
    updateProviderProfile,
    createCategory,
    updateCategory,
    deleteCategory,
    getAllJobs,
    updateJob,
    deleteJob,
    getAllReviews,
    deleteReview,
    getDashboardStats,
    getJobsByMonthStats,
};
