const mongoose = require('mongoose');
// Service for provider-related business logic
const ProviderProfile = require('../models/ProviderProfile');
const User = require('../models/User');
const Category = require('../models/Category');

// Haversine formula to calculate distance between two lat/lng points
const haversineDistance = (coords1, coords2) => {
    const toRad = (x) => x * Math.PI / 180;
    const R = 6371; // Earth radius in km

    const dLat = toRad(coords2.lat - coords1.lat);
    const dLon = toRad(coords2.lng - coords1.lng);
    const lat1 = toRad(coords1.lat);
    const lat2 = toRad(coords2.lat);

    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c; // in kilometers
};


const createProfile = async (userId, profileData) => {
    // In reality, upload idPhoto to a cloud storage and get URL
    const profile = new ProviderProfile({ userId, ...profileData });
    await profile.save();
    return profile;
};

const getProfile = async (userId) => {
    try {
        const profile = await ProviderProfile.findOne({ userId })
            .populate('userId', 'firstName lastName phone rating profilePhoto role')
            .populate('serviceCategories.category');
        
        return profile;
    } catch (error) {
        throw error;
    }
};

const updateServices = async (userId, services) => {
    return await ProviderProfile.findOneAndUpdate({ userId }, { serviceCategories: services }, { new: true });
};


const searchProviders = async (categoryIds, userLocation) => {
    try {
        const idsAsStrings = categoryIds.map(id => id.trim());

        const query = {
            'serviceCategories.category': { $in: idsAsStrings },
        };

        const profiles = await ProviderProfile.find(query)
            .populate('userId', 'firstName lastName phone rating profilePhoto location role')
            .populate('serviceCategories.category');
            
        const validProfiles = profiles.filter(p => p.userId);
        
        if (!validProfiles || validProfiles.length === 0) {
            return [];
        }

        const profilesWithScores = validProfiles.map(p => {
            const providerCategoryIds = p.serviceCategories.map(sc => sc.category._id.toString());
            const requestedCategoryIds = idsAsStrings;
            const matchCount = providerCategoryIds.filter(id => requestedCategoryIds.includes(id)).length;
            const matchScore = matchCount;

            let distance = Infinity;
            if (userLocation && p.userId && p.userId.location) {
                distance = haversineDistance(userLocation, p.userId.location);
            }
            
            return { ...p.toObject(), distance, matchScore }; 
        });
        
        profilesWithScores.sort((a, b) => {
            if (a.matchScore !== b.matchScore) return b.matchScore - a.matchScore;
            if (a.isOnline !== b.isOnline) return b.isOnline ? -1 : 1;
            if (a.distance !== b.distance) return a.distance - b.distance;
            const ratingA = a.userId ? a.userId.rating || 0 : 0;
            const ratingB = b.userId ? b.userId.rating || 0 : 0;
            if (ratingA !== ratingB) return ratingB - ratingA;
            return 0;
        });

        return profilesWithScores;
    } catch (error) {
        throw new Error(error.message);
    }
};

const updateCategories = async (userId, categoryIds) => {
    return await ProviderProfile.findOneAndUpdate(
        { userId },
        { serviceCategories: categoryIds },
        { new: true }
    );
};

const toggleStatus = async (userId, isOnline) => {
    await ProviderProfile.findOneAndUpdate(
        { userId },
        { isOnline },
        { new: true }
    );
    return await getProfile(userId);
};


const getDashboardMetrics = async (providerId) => {
    const providerProfile = await ProviderProfile.findOne({ userId: providerId });
    if (!providerProfile) {
        throw new Error('Provider profile not found.');
    }

    const user = await User.findById(providerId);
    if (!user) {
        throw new Error('User not found.');
    }

    return {
        totalEarnings: providerProfile.earnings,
        avgRating: user.rating,
    };
};

const Job = require('../models/Job');

const getEarnings = async (providerId) => {
    const completedJobs = await Job.find({
        providerId,
        status: 'COMPLETED',
    }).populate('clientId', 'firstName lastName profilePhoto phone role')
      .populate('providerId', 'firstName lastName profilePhoto phone role')
      .sort({ completedAt: -1 });

    const monthlyEarnings = {};
    const recentTransactions = [];

    for (const job of completedJobs) {
        const month = new Date(job.completedAt).toLocaleString('default', { month: 'short' });
        monthlyEarnings[month] = (monthlyEarnings[month] || 0) + job.agreedPrice;
        if (recentTransactions.length < 5) {
            recentTransactions.push(job);
        }
    }

    const earningsResult = {
        monthlyEarnings,
        recentTransactions,
    };
    return earningsResult;
};

const getAvailability = async (providerId) => {
    const profile = await ProviderProfile.findOne({ userId: providerId });
    if (!profile) {
        throw new Error('Provider profile not found.');
    }
    return profile.availability;
};

const updateAvailability = async (providerId, availabilityData) => {
    return await ProviderProfile.findOneAndUpdate(
        { userId: providerId },
        { availability: availabilityData },
        { new: true }
    );
};

module.exports = {
    createProfile,
    getProfile,
    updateServices,
    searchProviders,
    updateCategories,
    toggleStatus,
    getDashboardMetrics,
    getEarnings,
    getAvailability,
    updateAvailability,
};
