const adminService = require('../services/adminService');

const getPendingProviders = async (req, res) => {
    try {
        const providers = await adminService.getPendingProviders();
        res.status(200).json(providers);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching pending providers.', error: error.message });
    }
};

const verifyProvider = async (req, res) => {
    try {
        const provider = await adminService.verifyProvider(req.params.id);
        if (!provider) {
            return res.status(404).json({ message: 'Provider not found.' });
        }
        res.status(200).json({ message: 'Provider verified successfully.', provider });
    } catch (error) {
        res.status(500).json({ message: 'Error verifying provider.', error: error.message });
    }
};

const getLedger = async (req, res) => {
    try {
        const ledger = await adminService.getLedger();
        res.status(200).json(ledger);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching ledger.', error: error.message });
    }
};

module.exports = {
    getPendingProviders,
    verifyProvider,
    getLedger,
};
