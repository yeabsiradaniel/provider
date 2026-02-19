const authService = require('../services/authService');

const requestOtp = async (req, res) => {
    const { phoneNumber } = req.body;

    if (!phoneNumber) {
        return res.status(400).json({ message: 'Phone number is required.' });
    }

    try {
        await authService.requestOtp(phoneNumber);
        res.status(200).json({ message: 'OTP sent.' });
    } catch (error) {
        console.error('Request OTP Error:', error);
        res.status(500).json({ message: 'Error requesting OTP.', error: error.message });
    }
};

const verifyOtp = async (req, res) => {
    const { phoneNumber, otp, firstName, lastName, pin, role, profilePhoto, idPhoto } = req.body;

    if (!phoneNumber || !otp) {
        return res.status(400).json({ message: 'Phone number and OTP are required.' });
    }

    try {
        const userData = { firstName, lastName, pin, role, profilePhoto, idPhoto };
        const { user, token, isNewUser } = await authService.verifyOtp(phoneNumber, otp, userData);
        res.status(200).json({ user, token, isNewUser });
    } catch (error) {
        console.error('Verify OTP Error:', error);
        let statusCode = 400; // Default to Bad Request
        let message = 'Error verifying OTP.';
        let errorCode = 'UNKNOWN_ERROR';

        switch (error.message) {
            case 'OTP_EXPIRED_OR_INVALID':
                message = 'OTP expired or is invalid. Please request a new one.';
                errorCode = 'OTP_EXPIRED_OR_INVALID';
                break;
            case 'OTP_TOO_MANY_ATTEMPTS':
                message = 'Too many incorrect attempts. Please request a new OTP.';
                errorCode = 'OTP_TOO_MANY_ATTEMPTS';
                break;
            case 'OTP_INVALID':
                message = 'Invalid OTP.';
                errorCode = 'OTP_INVALID';
                break;
            case 'USER_NOT_FOUND':
                message = 'User not found. Please register.';
                statusCode = 404; // Not Found
                errorCode = 'USER_NOT_FOUND';
                break;
            case 'USER_ALREADY_EXISTS':
                message = 'User already exists. Please log in.';
                statusCode = 409; // Conflict
                errorCode = 'USER_ALREADY_EXISTS';
                break;
            case 'INVALID_CREDENTIALS':
                message = 'Invalid PIN.';
                errorCode = 'INVALID_CREDENTIALS';
                break;
            case 'Missing required user data.':
                message = 'Missing required user data for registration.';
                errorCode = 'MISSING_USER_DATA';
                break;
            default:
                message = error.message;
                statusCode = 500;
                break;
        }
        res.status(statusCode).json({ errorCode, message });
    }
};

const resetPin = async (req, res) => {
    const { phoneNumber, otp, newPin } = req.body;

    if (!phoneNumber || !otp || !newPin) {
        return res.status(400).json({ message: 'Phone number, OTP, and new PIN are required.' });
    }

    try {
        await authService.resetPin(phoneNumber, otp, newPin);
        res.status(200).json({ message: 'PIN reset successful.' });
    } catch (error) {
        console.error('Reset PIN Error:', error);
        let statusCode = 400; // Default to Bad Request
        let message = 'Error resetting PIN.';
        let errorCode = 'UNKNOWN_ERROR';

        switch (error.message) {
            case 'OTP_INVALID':
                message = 'Invalid OTP for PIN reset.';
                errorCode = 'OTP_INVALID';
                break;
            case 'USER_NOT_FOUND':
                message = 'User not found. Cannot reset PIN.';
                statusCode = 404; // Not Found
                errorCode = 'USER_NOT_FOUND';
                break;
            default:
                message = error.message;
                statusCode = 500;
                break;
        }
        res.status(statusCode).json({ errorCode, message });
    }
};

module.exports = {
    requestOtp,
    verifyOtp,
    resetPin,
};
