const User = require('../models/User');

const getUserById = async (userId) => {
    try {
        const user = await User.findById(userId);
        return user;
    } catch (error) {
        throw new Error(error.message);
    }
};

const updateUser = async (userId, userData) => {
    try {
        // If phone number is being updated, check for duplicates
        if (userData.phone) {
            const existingUser = await User.findOne({ phone: userData.phone });
            if (existingUser && existingUser._id.toString() !== userId) {
                throw new Error('Phone number is already in use.');
            }
        }

        const user = await User.findByIdAndUpdate(userId, userData, { new: true });
        return user;
    } catch (error) {
        throw new Error(error.message);
    }
};

module.exports = {
    getUserById,
    updateUser,
};
