const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const upload = require('../middleware/uploadMiddleware');

// @route   POST /api/auth/request-otp
// @desc    Request an OTP for a given phone number
// @access  Public
router.post('/request-otp', authController.requestOtp);

// @route   POST /api/auth/verify-otp
// @desc    Verify the OTP and get a JWT
// @access  Public
router.post('/verify-otp', upload, authController.verifyOtp);

// @route   POST /api/auth/reset-pin
// @desc    Reset the user's PIN
// @access  Public
router.post('/reset-pin', authController.resetPin);

module.exports = router;
