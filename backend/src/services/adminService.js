// Service for admin operations
const User = require('../models/User');
const AdminLedger = require('../models/AdminLedger');

const getPendingProviders = async () => {
    // This assumes providers have uploaded their ID and are awaiting verification.
    // The `ProviderProfile` would contain the `idPhoto` URL.
    return await User.find({ role: 'provider', verified: false });
};

const verifyProvider = async (providerId) => {
    return await User.findByIdAndUpdate(providerId, { verified: true }, { new: true });
};

const getLedger = async () => {
    // In a real app, you'd have filtering by date, provider, etc.
    return await AdminLedger.find().populate('providerId', 'name phone').populate('jobId', 'serviceName agreedPrice').sort({ recordedAt: -1 });
};

module.exports = {
    getPendingProviders,
    verifyProvider,
    getLedger,
};
