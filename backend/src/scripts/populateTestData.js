require('dotenv').config({ path: require('path').resolve(__dirname, '../../.env') });
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const User = require('../models/User');
const ProviderProfile = require('../models/ProviderProfile');
const Job = require('../models/Job');
const Review = require('../models/Review');
const Category = require('../models/Category');

const seedTestData = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('MongoDB Connected for Test Data Seeding');

        // --- Clean up old test data ---
        console.log('--- Clearing previous test data ---');
        const customerPhone = '+251111111111';
        const providerPhone = '+251222222222';

        const customer = await User.findOne({ phone: customerPhone });
        const provider = await User.findOne({ phone: providerPhone });

        if (customer) {
            await Job.deleteMany({ clientId: customer._id });
            await Review.deleteMany({ clientId: customer._id });
            await User.deleteOne({ _id: customer._id });
             console.log('Cleared old test customer and related data.');
        }
        if (provider) {
            await Job.deleteMany({ providerId: provider._id });
            await Review.deleteMany({ providerId: provider._id });
            await ProviderProfile.deleteOne({ userId: provider._id });
            await User.deleteOne({ _id: provider._id });
            console.log('Cleared old test provider and related data.');
        }

        // --- Create new test data ---
        console.log('--- Creating new test users ---');

        const salt = await bcrypt.genSalt(10);
        const customerPin = await bcrypt.hash('123456', salt);
        const providerPin = await bcrypt.hash('654321', salt);

        // 1. Create Customer
        const newCustomer = await User.create({
            phone: customerPhone,
            firstName: 'Test',
            lastName: 'Customer',
            pin: customerPin,
            role: 'client',
        });
        console.log('\n✅ Test Customer created:');
        console.log(`   Phone: ${customerPhone}`);
        console.log(`   PIN: 123456`);

        // 2. Create Provider
        const newProvider = await User.create({
            phone: providerPhone,
            firstName: 'Test',
            lastName: 'Provider',
            pin: providerPin,
            role: 'provider',
        });
         console.log('\n✅ Test Provider created:');
        console.log(`   Phone: ${providerPhone}`);
        console.log(`   PIN: 654321`);

        // 3. Find Categories
        const fullHouseElec = await Category.findOne({ 'name.en': 'Full House Installation and Maintenance' });
        const waterPipe = await Category.findOne({ 'name.en': 'Water Pipe Installation and Maintenance' });

        if (!fullHouseElec || !waterPipe) {
            throw new Error("Please run the 'populateCategories.js' script first and ensure sub-categories exist.");
        }

        // 4. Create Provider Profile
        const providerProfile = await ProviderProfile.create({
            userId: newProvider._id,
            serviceCategories: [
                { category: fullHouseElec._id, price: 1500 },
                { category: waterPipe._id, price: 500 }
            ],
            isOnline: true,
            earnings: 2300, // Starting with some earnings
        });
        console.log('✅ ProviderProfile created and assigned to specific services.');

        // 5. Create a PENDING job from customer to provider
        const pendingJob = await Job.create({
            clientId: newCustomer._id,
            providerId: newProvider._id,
            serviceName: 'Full House Installation and Maintenance',
            serviceCategory: fullHouseElec._id,
            description: 'My main fuse box is making a strange humming noise and smells like burning plastic. Need a full diagnostic as soon as possible.',
            status: 'PENDING',
            agreedPrice: null,
            location: { lat: 9.0054, lng: 38.7636 } // Example location in Addis
        });
        console.log('✅ Created a PENDING job for the provider to accept.');
        
        // 6. Create a COMPLETED job and a Review to give the provider a rating
        const completedJob = await Job.create({
            clientId: newCustomer._id,
            providerId: newProvider._id,
            serviceName: 'Water Pipe Installation and Maintenance',
            serviceCategory: waterPipe._id,
            description: 'Installed new pipes for the washing machine.',
            status: 'COMPLETED',
            agreedPrice: 800,
            acceptedAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000), // 3 days ago
            completedAt: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000), // 1 day ago
        });
        console.log('✅ Created a COMPLETED job.');

        await Review.create({
            jobId: completedJob._id,
            clientId: newCustomer._id,
            providerId: newProvider._id,
            rating: 4.5,
            comment: 'Excellent and professional service! Highly recommended.'
        });
        console.log('✅ Created a review for the completed job.');
        
        // Update provider's average rating
        const stats = await Review.aggregate([
            { $match: { providerId: newProvider._id } },
            { $group: { _id: '$providerId', avgRating: { $avg: '$rating' } } }
        ]);

        if (stats.length > 0) {
            await User.findByIdAndUpdate(newProvider._id, { rating: stats[0].avgRating });
            console.log(`✅ Provider's average rating updated to ${stats[0].avgRating}.`);
        }

        console.log('\n\nTest data seeded successfully!');
        console.log('You can now log in with the credentials printed above.');


    } catch (error) {
        console.error('Error seeding test data:', error);
    } finally {
        mongoose.connection.close();
    }
};

seedTestData();
