const searchService = require('../services/searchService');

const getSuggestions = async (req, res) => {
    try {
        const { query } = req.query;
        if (!query) {
            return res.status(400).json({ message: 'Query parameter is required.' });
        }
        const suggestions = await searchService.getSearchSuggestions(query);
        res.status(200).json(suggestions);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching search suggestions.', error: error.message });
    }
};

module.exports = {
    getSuggestions,
};
