const providerService = require('../services/providerService');

const createOrUpdateProfile = async (req, res) => {
    try {
        const profile = await providerService.createProfile(req.user.id, req.body);
        res.status(201).json(profile);
    } catch (error) {
        res.status(500).json({ message: 'Error creating profile.', error: error.message });
    }
};

const getProfile = async (req, res) => {
    try {
        const profile = await providerService.getProfile(req.params.userId);
        if (!profile) {
            return res.status(404).json({ message: 'Provider profile not found.' });
        }
        res.status(200).json(profile);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching profile.', error: error.message });
    }
};

const updateServices = async (req, res) => {
    try {
        const { services } = req.body;
        if (!services) {
            return res.status(400).json({ message: 'Services array is required.' });
        }
        const profile = await providerService.updateServices(req.user.id, services);
        res.status(200).json(profile);
    } catch (error) {
        res.status(500).json({ message: 'Error updating services.', error: error.message });
    }
};


const searchProviders = async (req, res) => {
    try {
        const { categoryIds, lat, lng } = req.query;

        if (!categoryIds) {
            return res.status(400).json({ message: 'At least one category ID is required.' });
        }

        const idsArray = typeof categoryIds === 'string' ? categoryIds.split(',') : categoryIds;
        
        let userLocation = null;
        if (lat && lng) {
            userLocation = {
                lat: parseFloat(lat),
                lng: parseFloat(lng),
            };
        }

        const providers = await providerService.searchProviders(idsArray, userLocation);
        res.status(200).json(providers);
    } catch (error) {
        res.status(500).json({ message: 'Error searching for providers.', error: error.message });
    }
};

const updateCategories = async (req, res) => {
    try {
        const { categoryIds } = req.body;
        if (!categoryIds) {
            return res.status(400).json({ message: 'categoryIds array is required.' });
        }
        const profile = await providerService.updateCategories(req.user.id, categoryIds);
        res.status(200).json(profile);
    } catch (error) {
        res.status(500).json({ message: 'Error updating categories.', error: error.message });
    }
};

const toggleStatus = async (req, res) => {
    try {
        const { isOnline } = req.body;
        if (typeof isOnline !== 'boolean') {
            return res.status(400).json({ message: 'isOnline boolean is required.' });
        }
        const profile = await providerService.toggleStatus(req.user.id, isOnline);
        res.status(200).json(profile.toObject());
    } catch (error) {
        res.status(500).json({ message: 'Error updating status.', error: error.message });
    }
};

const getDashboardMetrics = async (req, res) => {
    try {
        const metrics = await providerService.getDashboardMetrics(req.user.id);
        res.status(200).json(metrics);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching dashboard metrics.', error: error.message });
    }
};

const getEarnings = async (req, res) => {
    try {
        const earnings = await providerService.getEarnings(req.user.id);
        res.status(200).json(earnings);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching earnings.', error: error.message });
    }
};

const getAvailability = async (req, res) => {
    try {
        const availability = await providerService.getAvailability(req.user.id);
        res.status(200).json(availability);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching availability.', error: error.message });
    }
};

const updateAvailability = async (req, res) => {
    try {
        const { availability } = req.body;
        if (!availability) {
            return res.status(400).json({ message: 'Availability data is required.' });
        }
        const profile = await providerService.updateAvailability(req.user.id, availability);
        res.status(200).json(profile.availability);
    } catch (error) {
        res.status(500).json({ message: 'Error updating availability.', error: error.message });
    }
};

const getMe = async (req, res) => {
    try {
        const profile = await providerService.getProfile(req.user.id);
        if (!profile) {
            return res.status(404).json({ message: 'Provider profile not found.' });
        }
        res.status(200).json(profile);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching profile.', error: error.message });
    }
};

module.exports = {
    createOrUpdateProfile,
    getProfile,
    getMe,
    updateServices,
    searchProviders,
    updateCategories,
    toggleStatus,
    getDashboardMetrics,
    getEarnings,
    getAvailability,
    updateAvailability,
};
