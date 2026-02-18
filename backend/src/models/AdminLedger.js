const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const adminLedgerSchema = new Schema({
    providerId: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        index: true,
    },
    jobId: {
        type: Schema.Types.ObjectId,
        ref: 'Job',
        required: true,
        index: true,
    },
    amount: {
        type: Number,
        required: true,
    },
    recordedAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('AdminLedger', adminLedgerSchema);
