const User = require('../models/User');
const OTP = require('../models/OTP');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const requestOtp = async (phoneNumber) => {
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    console.log(`OTP for ${phoneNumber} is: ${otp}`);

    await OTP.findOneAndUpdate(
        { phoneNumber },
        { otp, attempts: 0 },
        { upsert: true, new: true, setDefaultsOnInsert: true }
    );
};

const verifyOtp = async (phoneNumber, otp, userData) => {
    const otpDoc = await OTP.findOne({ phoneNumber });

    if (!otpDoc) {
        throw new Error('OTP_EXPIRED_OR_INVALID');
    }

    if (otpDoc.otp !== otp) {
        otpDoc.attempts += 1;
        if (otpDoc.attempts >= 3) {
            await otpDoc.deleteOne();
            throw new Error('OTP_TOO_MANY_ATTEMPTS');
        }
        await otpDoc.save();
        throw new Error('OTP_INVALID');
    }

    let user = await User.findOne({ phone: phoneNumber });
    let isNewUser = false;

    if (!user) {
        // --- REGISTRATION FLOW ---
        isNewUser = true;
        const { firstName, lastName, pin, role, profilePhoto, idPhoto } = userData;

        // If it's a registration attempt, all these fields must be present
        if (!firstName || !lastName || !pin || !role) {
            // This case happens if someone tries to LOG IN with a non-existent number
            throw new Error('USER_NOT_FOUND');
        }

        const salt = await bcrypt.genSalt(10);
        const hashedPin = await bcrypt.hash(pin, salt);

        user = await User.create({
            phone: phoneNumber,
            firstName,
            lastName,
            pin: hashedPin,
            role,
            profilePhoto,
            idUrl: idPhoto, // Save idPhoto to idUrl field
        });

        if (user.role === 'provider') {
            const providerService = require('./providerService');
            await providerService.createProfile(user._id, {});
        }
    } else {
        // --- LOGIN OR DUPLICATE REGISTRATION ---
        const { firstName, lastName, pin } = userData;
        
        // If firstName is present, it's a registration attempt for an existing user
        if (firstName && lastName) {
            throw new Error('USER_ALREADY_EXISTS');
        }

        // --- LOGIN FLOW ---
        if (!pin) {
            // This case can happen if the login form doesn't send a pin
            throw new Error('INVALID_CREDENTIALS');
        }

        const isMatch = await bcrypt.compare(pin, user.pin);
        if (!isMatch) {
            throw new Error('INVALID_CREDENTIALS');
        }
    }

    await otpDoc.deleteOne();

    const token = jwt.sign({ userId: user._id, role: user.role }, process.env.JWT_SECRET, {
        expiresIn: '7d',
    });

    return { user, token, isNewUser };
};
const resetPin = async (phoneNumber, otp, newPin) => {
    const otpDoc = await OTP.findOne({ phoneNumber, otp });

    if (!otpDoc) {
        throw new Error('OTP_INVALID');
    }

    const user = await User.findOne({ phone: phoneNumber });

    if (!user) {
        throw new Error('USER_NOT_FOUND');
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPin = await bcrypt.hash(newPin, salt);

    user.pin = hashedPin;
    await user.save();

    await otpDoc.deleteOne();
};

module.exports = {
    requestOtp,
    verifyOtp,
    resetPin,
};
