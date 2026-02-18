require('dotenv').config({ path: require('path').resolve(__dirname, '../../.env') });
const mongoose = require('mongoose');
const User = require('../models/User');
const ProviderProfile = require('../models/ProviderProfile');
const Category = require('../models/Category');

const diagnoseData = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('--- Database Diagnosis Script ---');

        // 1. Find the category in question
        const categoryName = 'Full House Installation and Maintenance';
        const targetCategory = await Category.findOne({ 'name.en': categoryName });

        if (!targetCategory) {
            console.error(`❌ CRITICAL: Could not find the category "${categoryName}". Please ensure the category seed script has been run.`);
            return;
        }
        const targetCategoryId = targetCategory._id.toString();
        console.log(`✅ Found category "${categoryName}" with ID: ${targetCategoryId}`);

        // 2. Find the test provider
        const providerPhone = '222222222';
        const testProviderUser = await User.findOne({ phone: providerPhone });

        if (!testProviderUser) {
            console.error(`❌ CRITICAL: Could not find the Test Provider with phone number ${providerPhone}. Please ensure the test data seed script has been run.`);
            return;
        }
        const testProviderUserId = testProviderUser._id;
        console.log(`✅ Found Test Provider with user ID: ${testProviderUserId}`);

        // 3. Find the provider's profile
        const providerProfile = await ProviderProfile.findOne({ userId: testProviderUserId });

        if (!providerProfile) {
            console.error(`❌ CRITICAL: Could not find a ProviderProfile for the Test Provider.`);
            return;
        }
        console.log(`✅ Found ProviderProfile for Test Provider.`);

        // 4. Check if the category ID is in the provider's service list
        const serviceCategoryIds = providerProfile.serviceCategories.map(id => id.toString());
        console.log(`Provider's registered serviceCategory IDs are: [${serviceCategoryIds.join(', ')}]`);

        const isMatch = serviceCategoryIds.includes(targetCategoryId);

        console.log('\\n--- Diagnosis Result ---');
        if (isMatch) {
            console.log('✅ SUCCESS: The Test Provider IS correctly assigned to the target category.');
            console.log('This means the issue is likely in the backend API query logic or the frontend request.');
        } else {
            console.error('❌ FAILURE: The Test Provider is NOT assigned to the target category.');
            console.error(`The provider's categories are [${serviceCategoryIds.join(', ')}], but we are looking for ${targetCategoryId}.`);
            console.error('This suggests an issue with how the test data is seeded. Please re-run `node src/scripts/populateTestData.js`.');
        }

    } catch (error) {
        console.error('An unexpected error occurred during diagnosis:', error);
    } finally {
        mongoose.connection.close();
    }
};

diagnoseData();
