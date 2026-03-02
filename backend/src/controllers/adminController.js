const adminService = require('../services/adminService');

const getPendingProviders = async (req, res) => {
    try {
        const providers = await adminService.getPendingProviders();
        res.status(200).json(providers);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching pending providers.', error: error.message });
    }
};

const verifyProvider = async (req, res) => {
    try {
        const provider = await adminService.verifyProvider(req.params.id);
        if (!provider) {
            return res.status(404).json({ message: 'Provider not found.' });
        }
        res.status(200).json({ message: 'Provider verified successfully.', provider });
    } catch (error) {
        res.status(500).json({ message: 'Error verifying provider.', error: error.message });
    }
};

const getLedger = async (req, res) => {
    try {
        const ledger = await adminService.getLedger();
        res.status(200).json(ledger);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching ledger.', error: error.message });
    }
};

const getAllUsers = async (req, res) => {
    try {
        const users = await adminService.getAllUsers();
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching all users.', error: error.message });
    }
};

const createUser = async (req, res) => {
    try {
        const user = await adminService.createUser(req.body);
        res.status(201).json(user);
    } catch (error) {
        res.status(400).json({ message: 'Error creating user.', error: error.message });
    }
};

const updateUser = async (req, res) => {
    try {
        const user = await adminService.updateUser(req.params.id, req.body);
        if (!user) {
            return res.status(404).json({ message: 'User not found.' });
        }
        res.status(200).json(user);
    } catch (error) {
        res.status(400).json({ message: 'Error updating user.', error: error.message });
    }
};

const deleteUser = async (req, res) => {
    try {
        const user = await adminService.deleteUser(req.params.id);
        if (!user) {
            return res.status(404).json({ message: 'User not found.' });
        }
        res.status(200).json({ message: 'User deleted successfully.' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting user.', error: error.message });
    }
};

const getAllProviderProfiles = async (req, res) => {
    try {
        const profiles = await adminService.getAllProviderProfiles();
        res.status(200).json(profiles);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching provider profiles.', error: error.message });
    }
};

const updateProviderProfile = async (req, res) => {
    try {
        const profile = await adminService.updateProviderProfile(req.params.id, req.body);
        if (!profile) {
            return res.status(404).json({ message: 'Provider profile not found.' });
        }
        res.status(200).json(profile);
    } catch (error) {
        res.status(400).json({ message: 'Error updating provider profile.', error: error.message });
    }
};

const createCategory = async (req, res) => {
    try {
        const category = await adminService.createCategory(req.body);
        res.status(201).json(category);
    } catch (error) {
        res.status(400).json({ message: 'Error creating category.', error: error.message });
    }
};

const updateCategory = async (req, res) => {
    try {
        const category = await adminService.updateCategory(req.params.id, req.body);
        if (!category) {
            return res.status(404).json({ message: 'Category not found.' });
        }
        res.status(200).json(category);
    } catch (error) {
        res.status(400).json({ message: 'Error updating category.', error: error.message });
    }
};

const deleteCategory = async (req, res) => {
    try {
        const category = await adminService.deleteCategory(req.params.id);
        if (!category) {
            return res.status(404).json({ message: 'Category not found.' });
        }
        res.status(200).json({ message: 'Category deleted successfully.' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting category.', error: error.message });
    }
};

const getAllJobs = async (req, res) => {
    try {
        const jobs = await adminService.getAllJobs();
        res.status(200).json(jobs);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching all jobs.', error: error.message });
    }
};

const updateJob = async (req, res) => {
    try {
        const job = await adminService.updateJob(req.params.id, req.body);
        if (!job) {
            return res.status(404).json({ message: 'Job not found.' });
        }
        res.status(200).json(job);
    } catch (error) {
        res.status(400).json({ message: 'Error updating job.', error: error.message });
    }
};

const deleteJob = async (req, res) => {
    try {
        const job = await adminService.deleteJob(req.params.id);
        if (!job) {
            return res.status(404).json({ message: 'Job not found.' });
        }
        res.status(200).json({ message: 'Job deleted successfully.' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting job.', error: error.message });
    }
};

const getAllReviews = async (req, res) => {
    try {
        const reviews = await adminService.getAllReviews();
        res.status(200).json(reviews);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching all reviews.', error: error.message });
    }
};

const deleteReview = async (req, res) => {
    try {
        const review = await adminService.deleteReview(req.params.id);
        if (!review) {
            return res.status(404).json({ message: 'Review not found.' });
        }
        res.status(200).json({ message: 'Review deleted successfully.' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting review.', error: error.message });
    }
};

const getDashboardStats = async (req, res) => {
    try {
        const stats = await adminService.getDashboardStats();
        res.status(200).json(stats);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching dashboard stats.', error: error.message });
    }
};

const unverifyProvider = async (req, res) => {
    try {
        const provider = await adminService.unverifyProvider(req.params.id);
        if (!provider) {
            return res.status(404).json({ message: 'Provider not found.' });
        }
        res.status(200).json({ message: 'Provider un-verified successfully.', provider });
    } catch (error) {
        res.status(500).json({ message: 'Error un-verifying provider.', error: error.message });
    }
};

const getJobsByMonthStats = async (req, res) => {
    try {
        const stats = await adminService.getJobsByMonthStats();
        res.status(200).json(stats);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching job stats.', error: error.message });
    }
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
