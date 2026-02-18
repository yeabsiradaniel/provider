const mongoose = require('mongoose');

const OTPSchema = new mongoose.Schema({
    phoneNumber: {
        type: String,
        required: true,
    },
    otp: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
        expires: 300, // 5 minutes
    },
    attempts: {
        type: Number,
        default: 0,
    },
});

module.exports = mongoose.model('OTP', OTPSchema);
