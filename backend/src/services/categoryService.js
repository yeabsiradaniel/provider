const Category = require('../models/Category');

const getCategories = async () => {
    try {
        // 1. Fetch all categories from the database at once.
        const allCategories = await Category.find({});

        // 2. Create a map for efficient lookups.
        const categoryMap = new Map();
        allCategories.forEach(cat => {
            categoryMap.set(cat._id.toString(), {
                _id: cat._id,
                name: cat.name,
                icon: cat.icon,
                parent: cat.parent ? cat.parent.toString() : null,
                subCategories: [], // Initialize subCategories array
            });
        });

        // 3. Build the tree structure.
        const categoryTree = [];
        allCategories.forEach(cat => {
            if (cat.parent && categoryMap.has(cat.parent.toString())) {
                // This is a sub-category. Find its parent and add it to the parent's subCategories.
                const parent = categoryMap.get(cat.parent.toString());
                parent.subCategories.push(categoryMap.get(cat._id.toString()));
            } else {
                // This is a top-level category.
                categoryTree.push(categoryMap.get(cat._id.toString()));
            }
        });

        console.log('[categoryService] Generated category tree:', JSON.stringify(categoryTree, null, 2));

        return categoryTree;
    } catch (error) {
        console.error('Error fetching and building category tree:', error);
        throw new Error('Error fetching categories');
    }
};

module.exports = {
    getCategories,
};
