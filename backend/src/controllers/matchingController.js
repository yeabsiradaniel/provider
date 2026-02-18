const matchingService = require('../services/matchingService');

const searchProviders = async (req, res) => {
    try {
        const { category, lat, lng } = req.query;
        if (!category || !lat || !lng) {
            return res.status(400).json({ message: 'Category, lat, and lng are required query parameters.' });
        }

        const providers = await matchingService.findProviders({ category, lat, lng });
        res.status(200).json(providers);
    } catch (error) {
        res.status(500).json({ message: 'Error searching for providers.', error: error.message });
    }
};

module.exports = {
    searchProviders,
};
