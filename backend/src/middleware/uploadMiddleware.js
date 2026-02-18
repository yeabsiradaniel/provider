const multer = require('multer');
const path = require('path');

// Set storage engine
const storage = multer.memoryStorage();

// Check file type
function checkFileType(file, cb){
    // Allowed ext
    const filetypes = /jpeg|jpg|png|gif/;
    // Check ext
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    // Check mime
    const mimetype = filetypes.test(file.mimetype);

    if(mimetype && extname){
        return cb(null, true);
    } else {
        cb('Error: Images Only!');
    }
}

// Init upload
const upload = multer({
    storage: storage,
    limits: { fileSize: 10000000 }, // 10MB limit
    fileFilter: function(req, file, cb){
        checkFileType(file, cb);
    }
}).single('profilePhoto'); // 'profilePhoto' is the field name in the form-data

module.exports = upload;
