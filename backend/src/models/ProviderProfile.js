const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const providerProfileSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        unique: true,
        index: true,
    },
    idPhoto: {
        type: String,
    },
    serviceCategories: [{
        category: {
            type: Schema.Types.ObjectId,
            ref: 'Category',
        },
        price: {
            type: Number,
        },
    }],
    radius: {
        type: Number,
        max: 10,
    },
    negotiable: {
        type: Boolean,
    },
    earnings: {
        type: Number,
        default: 0,
    },
    isOnline: {
        type: Boolean,
        default: false,
    },
    availability: {
        type: Map,
        of: Object,
        default: {},
    },
}, { timestamps: true });

module.exports = mongoose.model('ProviderProfile', providerProfileSchema);
