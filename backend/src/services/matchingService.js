// Service for matching engine logic
const ProviderProfile = require('../models/ProviderProfile');
const User = require('../models/User');

/**
 * Finds providers based on category, location.
 * Sorts by online status, distance, rating.
 */
const findProviders = async ({ category, lat, lng }) => {
    // 1. Fetch providers from DB based on category (not implemented, placeholder)
    let providers = await User.find({ role: 'provider', verified: true }).lean();

    // 2. Get online status from Firebase (placeholder)
    providers.forEach(p => p.isOnline = Math.random() > 0.5); // Mock online status

    // 3. Calculate distance (placeholder for real geo-calculation)
    providers.forEach(p => {
        const providerLocation = p.location;
        if (providerLocation && lat && lng) {
            // Simplified distance calculation
            p.distance = Math.sqrt(Math.pow(providerLocation.lat - lat, 2) + Math.pow(providerLocation.lng - lng, 2));
        } else {
            p.distance = Infinity;
        }
    });

    // 4. Sort providers
    providers.sort((a, b) => {
        // Sort by online status (online first)
        if (a.isOnline !== b.isOnline) {
            return b.isOnline - a.isOnline;
        }
        // Then by distance
        if (a.distance !== b.distance) {
            return a.distance - b.distance;
        }
        // Then by rating
        return b.rating - a.rating;
    });

    return providers;
};

module.exports = {
    findProviders,
};
