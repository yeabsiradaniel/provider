const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const categorySchema = new Schema({
    name: {
        en: { type: String, required: true },
        am: { type: String, required: true },
    },
    icon: {
        type: String,
    },
    parent: {
        type: Schema.Types.ObjectId,
        ref: 'Category',
        default: null,
    },
    ancestors: [{
        type: Schema.Types.ObjectId,
        ref: 'Category',
    }],
}, { timestamps: true });

module.exports = mongoose.model('Category', categorySchema);
