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
const chatService = require('./services/chatService'); // Import chat service
const Job = require('./models/Job'); // Import Job model

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

const jwt = require('jsonwebtoken');

// --- Socket.IO Authentication Middleware ---
io.use((socket, next) => {
    console.log('[SOCKET-TRACE] Authentication attempt', { socketId: socket.id });
    const token = socket.handshake.auth.token;
    if (!token) {
        console.log('[SOCKET-TRACE] Authentication failed: Token not provided', { socketId: socket.id });
        return next(new Error('Authentication error: Token not provided'));
    }
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            console.log('[SOCKET-TRACE] Authentication failed: Invalid token', { socketId: socket.id });
            return next(new Error('Authentication error: Invalid token'));
        }
        socket.user = decoded; // Attach user info to the socket
        console.log('[SOCKET-TRACE] Authentication successful', { socketId: socket.id, userId: socket.user.userId, role: socket.user.role });
        next();
    });
});

// --- Socket.IO Connection ---
io.on('connection', (socket) => {
  console.log('[SOCKET-TRACE] User connected', { socketId: socket.id, userId: socket.user.userId });

  // Automatically join a room based on the user's ID
  const userRoom = socket.user.userId.toString();
  socket.join(userRoom);
  console.log('[SOCKET-TRACE] User joined personal room', { socketId: socket.id, userId: socket.user.userId, room: userRoom });

  socket.on('joinJobRoom', (jobId) => {
    const jobRoom = jobId.toString();
    socket.join(jobRoom);
    console.log(`[SOCKET-TRACE] User joined job room`, { socketId: socket.id, userId: socket.user.userId, room: jobRoom });
  });

  socket.on('sendMessage', async (data) => {
    console.log('[SOCKET-TRACE] sendMessage event received', { socketId: socket.id, userId: socket.user.userId, data });
    try {
        const message = await chatService.createMessage(socket.user.userId, data);
        const job = await Job.findById(data.jobId);

        // --- DEBUG LOGGING ---
        console.log('[SOCKET-DEBUG] Fetched Job Object:', JSON.stringify(job, null, 2));
        // --- END DEBUG LOGGING ---

        if (job) {
            const jobRoom = data.jobId.toString();
            const clientRoom = job.clientId.toString();
            const providerRoom = job.providerId.toString();

            // Emit to the specific job room, and the personal rooms of both users
            io.to(jobRoom).to(clientRoom).to(providerRoom).emit('receiveMessage', message);

            console.log('[SOCKET-TRACE] Emitting receiveMessage to rooms', {
                rooms: [jobRoom, clientRoom, providerRoom],
                messageId: message._id.toString()
            });
        }
    } catch (error) {
      console.error('[SOCKET-TRACE] Error in sendMessage event', { socketId: socket.id, userId: socket.user.userId, error: error.message });
    }
  });

  socket.on('disconnect', () => {
    console.log('[SOCKET-TRACE] User disconnected', { socketId: socket.id, userId: socket.user.userId });
  });
});


// --- Server Initialization ---
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
