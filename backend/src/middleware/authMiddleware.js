const jwt = require('jsonwebtoken');
const User = require('../models/User');

const authMiddleware = async (req, res, next) => {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).send({ error: 'Unauthorized: No token provided.' });
    }

    const token = authHeader.split('Bearer ')[1];

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        const user = await User.findById(decoded.userId);
        if (!user) {
            return res.status(401).send({ error: 'Unauthorized: User not found.' });
        }
        
        req.user = user;
        next();
    } catch (error) {
        return res.status(401).send({ error: 'Unauthorized: Invalid token.' });
    }
};

const isRole = (role) => (req, res, next) => {
    const hasAccess = req.user && req.user.role === role;
    
    if (!hasAccess) {
        return res.status(403).send({ error: `Forbidden: Requires ${role} role.` });
    }
    next();
};


const isAdmin = isRole('admin');
const isProvider = isRole('provider');
const isClient = isRole('client');

module.exports = {
    authMiddleware,
    isAdmin,
    isProvider,
    isClient,
};
