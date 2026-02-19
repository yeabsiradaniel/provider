require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const http = require('http');
const { Server } = require("socket.io");

// Import routes
const authRoutes = require('./routes/auth');
const providerRoutes = require('./routes/provider');
const jobRoutes = require('./routes/job');
const reviewRoutes = require('./routes/review');
const adminRoutes = require('./routes/admin');
const categoryRoutes = require('./routes/category');
const userRoutes = require('./routes/user');
const searchRoutes = require('./routes/search');
const chatRoutes = require('./routes/chat'); // Import chat routes

const app = express();
const server = http.createServer(app);
const io = new Server(server);

const PORT = process.env.PORT || 3001;

const { initGridFS } = require('./gridfs');

// --- Middleware ---
app.use(express.json()); 
app.use((req, res, next) => {
    req.io = io;
    next();
});
app.use('/uploads', express.static('uploads'));

// --- Database Connection ---
mongoose.connect(process.env.MONGO_URI).then(() => {
    console.log('MongoDB Connected');
    initGridFS();
}).catch(err => {
    console.error('MongoDB Connection Error:', err);
    process.exit(1);
});


// --- API Routes ---
app.get('/api', (req, res) => {
    res.send('API is running...');
});

app.use('/api/auth', authRoutes);
app.use('/api/provider', providerRoutes); 
app.use('/api/jobs', jobRoutes);
app.use('/api/reviews', reviewRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/users', userRoutes);
app.use('/api/search', searchRoutes);
app.use('/api/chat', chatRoutes); // Use chat routes

// --- Socket.IO Connection ---
io.on('connection', (socket) => {
  console.log('a user connected');

  socket.on('joinJobRoom', (jobId) => {
    socket.join(jobId);
    console.log(`User joined room for job: ${jobId}`);
  });

  socket.on('sendMessage', (data) => {
    // When a message is sent, broadcast it to the specific job room
    io.to(data.jobId).emit('receiveMessage', data);
  });

  socket.on('disconnect', () => {
    console.log('user disconnected');
  });
});


// --- Server Initialization ---
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
