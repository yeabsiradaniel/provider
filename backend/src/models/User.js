const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const userSchema = new Schema({
    role: {
        type: String,
        enum: ['client', 'provider', 'admin'],
        required: true,
        index: true,
    },
    phone: {
        type: String,
        required: true,
        unique: true,
        index: true,
    },
    firstName: {
        type: String,
        required: true,
    },
    lastName: {
        type: String,
        required: true,
    },
    pin: {
        type: String,
        required: true,
    },
    profilePhoto: {
        type: String,
    },
    idUrl: {
        type: String,
    },
    rating: {
        type: Number,
        default: 0,
    },
    verified: {
        type: Boolean,
        default: false,
    },
    location: {
        lat: Number,
        lng: Number,
        updatedAt: Date,
    },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
