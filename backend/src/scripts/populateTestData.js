require('dotenv').config({ path: require('path').resolve(__dirname, '../../.env') });
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const User = require('../models/User');

const seedAdmin = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('MongoDB Connected for Admin Seeding');

        const adminPhone = '+251900000000';
        const adminPin = '000000';

        // Check if admin already exists
        const existingAdmin = await User.findOne({ phone: adminPhone });
        if (existingAdmin) {
            console.log('Admin user already exists. No action taken.');
            return;
        }

        // If admin does not exist, create it
        console.log('--- Creating new admin user ---');
        const salt = await bcrypt.genSalt(10);
        const hashedPin = await bcrypt.hash(adminPin, salt);

        await User.create({
            phone: adminPhone,
            firstName: 'Admin',
            lastName: 'User',
            pin: hashedPin,
            role: 'admin',
            verified: true,
        });

        console.log('\n✅ Admin User created successfully:');
        console.log(`   Phone: ${adminPhone}`);
        console.log(`   PIN: ${adminPin}`);

    } catch (error) {
        console.error('Error seeding admin user:', error);
    } finally {
        mongoose.connection.close();
    }
};

seedAdmin();
