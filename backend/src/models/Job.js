const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const jobSchema = new Schema({
    clientId: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    providerId: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        index: true,
    },
    serviceName: {
        type: String,
        required: true,
    },
    agreedPrice: {
        type: Number,
    },
    description: {
        type: String,
    },
    startDate: {
        type: Date,
    },
    endDate: {
        type: Date,
    },
    location: {
        lat: Number,
        lng: Number,
    },
    status: {
        type: String,
        enum: ['PENDING', 'ACCEPTED', 'ACTIVE', 'COMPLETED', 'DECLINED'],
        default: 'PENDING',
    },
    acceptedAt: {
        type: Date,
    },
    completedAt: {
        type: Date,
    },
    isRated: {
        type: Boolean,
        default: false,
    },
}, { timestamps: true });

module.exports = mongoose.model('Job', jobSchema);
