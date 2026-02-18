require('dotenv').config({ path: 'backend/.env' });
const mongoose = require('mongoose');
const User = require('../models/User');
const bcrypt = require('bcryptjs');

const users = [
    {
        _id: '60d5f2a1b3f3b3b3b3b3b3a1',
        role: 'client',
        phone: '911223344',
        firstName: 'Dawit',
        lastName: 'Abebe',
        pin: '123456', // will be hashed
        profilePhoto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
        location: {
            lat: 9.01,
            lng: 38.76,
            updatedAt: new Date(),
        },
    },
    {
        _id: '697650fc4453ccdf7b9f04d4',
        role: 'client',
        phone: '+251911111111',
        firstName: 'Yeab',
        lastName: 'Abebe',
        pin: '123456', // This should be updated if you registered with a different PIN
        profilePhoto: '', // Clear the bad data
        location: {
            lat: 9.03,
            lng: 38.74,
            updatedAt: new Date(),
        },
    },
];

const seedUsers = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('MongoDB Connected');

        for (const userData of users) {
            const salt = await bcrypt.genSalt(10);
            const hashedPin = await bcrypt.hash(userData.pin, salt);
            userData.pin = hashedPin;

            // Use mongoose.Types.ObjectId to create a valid ObjectId
            userData._id = new mongoose.Types.ObjectId(userData._id);

            await User.findOneAndUpdate({ _id: userData._id }, userData, { upsert: true });
        }

        console.log('Users seeded successfully!');
    } catch (error) {
        console.error('Error seeding users:', error);
    } finally {
        mongoose.connection.close();
    }
};

seedUsers();
