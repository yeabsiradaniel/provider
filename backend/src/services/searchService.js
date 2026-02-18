const Category = require('../models/Category');
const User = require('../models/User');

const getSearchSuggestions = async (query) => {
    const searchResults = [];
    const searchRegex = new RegExp(query, 'i'); // Case-insensitive search

    // Search Categories
    const categories = await Category.find({ 
        $or: [
            { 'name.en': searchRegex },
            { 'name.am': searchRegex },
        ]
    });
    categories.forEach(cat => {
        searchResults.push({
            type: 'category',
            id: cat._id,
            name: cat.name.en, // Return English name for display
        });
    });

    // Search Providers (by first name, last name or phone)
    const providers = await User.find({
        role: 'provider',
        $or: [
            { firstName: searchRegex },
            { lastName: searchRegex },
            { phone: searchRegex },
        ],
    });
    providers.forEach(p => {
        searchResults.push({
            type: 'provider',
            id: p._id,
            name: `${p.firstName} ${p.lastName}`,
        });
    });

    return searchResults;
};

module.exports = {
    getSearchSuggestions,
};
