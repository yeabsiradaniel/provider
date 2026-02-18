const mongoose = require('mongoose');

let gfs;

const initGridFS = () => {
    gfs = new mongoose.mongo.GridFSBucket(mongoose.connection.db, {
        bucketName: 'uploads'
    });
};

const getGFS = () => {
    if (!gfs) {
        throw new Error('GridFS not initialized');
    }
    return gfs;
};

module.exports = {
    initGridFS,
    getGFS,
};
