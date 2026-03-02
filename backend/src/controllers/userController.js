const userService = require('../services/userService');

const getUser = async (req, res) => {
    try {
        const user = await userService.getUserById(req.params.userId);
        if (!user) {
            return res.status(404).json({ message: 'User not found.' });
        }
        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching user.', error: error.message });
    }
};

const getMe = async (req, res) => {
    try {
        const user = await userService.getUserById(req.user.id);
        if (!user) {
            return res.status(404).json({ message: 'User not found.' });
        }
        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching user.', error: error.message });
    }
};

const updateMe = async (req, res) => {
    console.log('--- updateMe Controller ---');
    console.log('Request Body:', req.body);
    try {
        const user = await userService.updateUser(req.user.id, req.body);
        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ message: 'Error updating user.', error: error.message });
    }
};

const uploadProfilePhoto = async (req, res) => {
    console.log('--- uploadProfilePhoto Controller ---');
    console.log('Request Files:', req.files);
    
    const file = req.files && req.files.profilePhoto ? req.files.profilePhoto[0] : null;

    if (!file) {
        return res.status(400).json({ message: 'No file uploaded.' });
    }

    try {
        const profilePhotoPath = `/uploads/${file.filename}`;
        const updatedUser = await userService.updateUser(req.user.id, { profilePhoto: profilePhotoPath });
        res.status(200).json(updatedUser);
    } catch (error) {
        res.status(500).json({ message: 'Error uploading photo.', error: error.message });
    }
};

const mongoose = require('mongoose');

const getPhoto = async (req, res) => {
    try {
        // This route may need to be adjusted if you are not using GridFS for all photos.
        // For now, we assume it's still needed for other photos.
        const gfs = getGFS();
        const file = await gfs.find({ _id: new mongoose.Types.ObjectId(req.params.fileId) }).toArray();
        if (!file || file.length === 0) {
            return res.status(404).json({ message: 'File not found.' });
        }
        
        res.set('Content-Type', file[0].contentType);
        const readStream = gfs.openDownloadStream(file[0]._id);
        readStream.pipe(res);

    } catch (error) {
        res.status(500).json({ message: 'Error fetching photo.', error: error.message });
    }
};


module.exports = {
    getUser,
    getMe,
    updateMe,
    uploadProfilePhoto,
    getPhoto,
};
