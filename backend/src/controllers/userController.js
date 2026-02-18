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
    try {
        const user = await userService.updateUser(req.user.id, req.body);
        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ message: 'Error updating user.', error: error.message });
    }
};

const { getGFS } = require('../gridfs');
const { Readable } = require('stream');

const uploadProfilePhoto = async (req, res) => {
    if (!req.file) {
        return res.status(400).json({ message: 'No file uploaded.' });
    }

    try {
        const gfs = getGFS();
        const readableStream = new Readable();
        readableStream.push(req.file.buffer);
        readableStream.push(null);

        const uploadStream = gfs.openUploadStream(req.file.originalname, {
            contentType: req.file.mimetype,
        });

        uploadStream.on('finish', async () => {
            const updatedUser = await userService.updateUser(req.user.id, { profilePhoto: uploadStream.id.toString() });
            res.status(200).json(updatedUser);
        });

        readableStream.pipe(uploadStream);

    } catch (error) {
        res.status(500).json({ message: 'Error uploading photo.', error: error.message });
    }
};

const mongoose = require('mongoose');

const getPhoto = async (req, res) => {
    try {
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
