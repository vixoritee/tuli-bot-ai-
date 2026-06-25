require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
const bcrypt = require('bcryptjs');
const session = require('express-session');
const fetch = require('node-fetch');
const OpenAI = require('openai');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));

// Session configuration
app.use(session({
    secret: process.env.SESSION_SECRET || 'tulibot-secret-key-2024',
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false, maxAge: 24 * 60 * 60 * 1000 } // 1 day
}));

// Database connection
const db = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'tulibot'
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to database:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

// Middleware to check authentication
const isAuthenticated = (req, res, next) => {
    if (req.session.userId) {
        next();
    } else {
        res.status(401).json({ error: 'Unauthorized' });
    }
};

// --- Authentication Routes ---

// Register
app.post('/api/register', async (req, res) => {
    const { username, email, fullName, password } = req.body;
    
    if (!username || !email || !password) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const query = 'INSERT INTO users (username, email, full_name, password) VALUES (?, ?, ?, ?)';
        
        db.query(query, [username, email, fullName || null, hashedPassword], (err, result) => {
            if (err) {
                if (err.code === 'ER_DUP_ENTRY') {
                    return res.status(400).json({ error: 'Username or email already exists' });
                }
                return res.status(500).json({ error: err.message });
            }
            req.session.userId = result.insertId;
            res.json({ success: true, userId: result.insertId, username });
        });
    } catch (error) {
        res.status(500).json({ error: 'Server error' });
    }
});

// Login
app.post('/api/login', async (req, res) => {
    const { username, password } = req.body;
    
    if (!username || !password) {
        return res.status(400).json({ error: 'Username and password are required' });
    }

    const query = 'SELECT * FROM users WHERE username = ?';
    db.query(query, [username], async (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        
        if (results.length === 0) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const user = results[0];
        const isValid = await bcrypt.compare(password, user.password);
        
        if (!isValid) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        req.session.userId = user.id;
        res.json({ success: true, userId: user.id, username: user.username });
    });
});

// Logout
app.post('/api/logout', (req, res) => {
    req.session.destroy((err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true });
    });
});

// Get current user
app.get('/api/user', isAuthenticated, (req, res) => {
    const query = 'SELECT id, username, email, full_name, created_at FROM users WHERE id = ?';
    db.query(query, [req.session.userId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(404).json({ error: 'User not found' });
        res.json(results[0]);
    });
});

// --- AI Assistant Routes ---

// Initialize OpenAI client if API key is available
let openaiClient = null;
if (process.env.OPENAI_API_KEY && process.env.OPENAI_API_KEY !== 'your_openai_api_key_here') {
    openaiClient = new OpenAI({
        apiKey: process.env.OPENAI_API_KEY
    });
}

// Send chat message to AI (Gemini or OpenAI)
app.post('/api/chat', isAuthenticated, async (req, res) => {
    const { user_message } = req.body;
    const userId = req.session.userId;
    const AI_PROVIDER = process.env.AI_PROVIDER || 'gemini';
    
    console.log('AI Provider:', AI_PROVIDER);
    console.log('User message:', user_message);
    
    let ai_response = 'Saya adalah Guru Digital Tulibot, siap membantu Anda belajar bahasa isyarat!';
    
    try {
        if (AI_PROVIDER === 'openai' && openaiClient) {
            // Use OpenAI (GPT)
            console.log('Using OpenAI API...');
            const response = await openaiClient.chat.completions.create({
                model: 'gpt-4o-mini',
                messages: [
                    {
                        role: 'system',
                        content: `Anda adalah Guru Digital Tulibot, asisten yang ramah dan berpengetahuan untuk komunitas tunarungu. Tugas Anda adalah:
1. Menjawab pertanyaan tentang bahasa isyarat (BISINDO/SIBI) dengan jelas dan ringkas
2. Memberikan penjelasan yang mudah dipahami
3. Membantu pengguna belajar bahasa isyarat
4. Selalu berbicara dengan bahasa Indonesia yang santai dan friendly`
                    },
                    {
                        role: 'user',
                        content: user_message
                    }
                ],
                temperature: 0.7,
                max_tokens: 500
            });
            ai_response = response.choices[0].message.content;
            console.log('OpenAI response:', ai_response);
        } else if (AI_PROVIDER === 'gemini' && process.env.GEMINI_API_KEY) {
            // Use Gemini (default)
            console.log('Using Gemini API...');
            const apiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${process.env.GEMINI_API_KEY}`;
            
            const response = await fetch(apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    systemInstruction: {
                        parts: [{
                            text: `Anda adalah Guru Digital Tulibot, asisten yang ramah dan berpengetahuan untuk komunitas tunarungu. Tugas Anda adalah:
1. Menjawab pertanyaan tentang bahasa isyarat (BISINDO/SIBI) dengan jelas dan ringkas
2. Memberikan penjelasan yang mudah dipahami
3. Membantu pengguna belajar bahasa isyarat
4. Selalu berbicara dengan bahasa Indonesia yang santai dan friendly`
                        }]
                    },
                    contents: [{
                        parts: [{
                            text: user_message
                        }]
                    }],
                    generationConfig: {
                        temperature: 0.7,
                        maxOutputTokens: 500
                    }
                })
            });
            
            console.log('Gemini API status:', response.status);
            
            const data = await response.json();
            console.log('Gemini API response data:', JSON.stringify(data, null, 2));
            
            if (data.candidates && data.candidates[0] && data.candidates[0].content && data.candidates[0].content.parts) {
                ai_response = data.candidates[0].content.parts[0].text;
            } else if (data.error) {
                console.error('Gemini API Error:', data.error);
                ai_response = `Maaf, terjadi kesalahan: ${data.error.message || 'Silakan coba lagi nanti.'}`;
            } else {
                ai_response = 'Maaf, saya tidak dapat memproses permintaan Anda saat ini. Silakan coba lagi.';
            }
        } else {
            ai_response = 'AI Assistant belum dikonfigurasi. Silakan tambahkan API Key di file .env';
        }
    } catch (error) {
        console.error('AI API Error:', error);
        ai_response = `Maaf, terjadi kesalahan koneksi: ${error.message || 'Silakan coba lagi nanti.'}`;
    }
    
    // Save to database
    const insertQuery = 'INSERT INTO chat_history (user_id, user_message, ai_response) VALUES (?, ?, ?)';
    db.query(insertQuery, [userId, user_message, ai_response], (err, result) => {
        if (err) console.error('Save chat history error:', err);
    });
    
    res.json({ success: true, ai_response });
});

// Get chat history
app.get('/api/chat-history', isAuthenticated, (req, res) => {
    const query = 'SELECT * FROM chat_history WHERE user_id = ? ORDER BY created_at DESC LIMIT 50';
    db.query(query, [req.session.userId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// --- Two-Way Communication Routes ---

// Save two-way communication history
app.post('/api/two-way-history', isAuthenticated, (req, res) => {
    const { deaf_text, hearing_speech, language } = req.body;
    const query = 'INSERT INTO two_way_history (user_id, deaf_text, hearing_speech, language) VALUES (?, ?, ?, ?)';
    db.query(query, [req.session.userId, deaf_text, hearing_speech, language], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true, id: result.insertId });
    });
});

// Get two-way history
app.get('/api/two-way-history', isAuthenticated, (req, res) => {
    const query = 'SELECT * FROM two_way_history WHERE user_id = ? ORDER BY created_at DESC LIMIT 50';
    db.query(query, [req.session.userId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Delete two-way history item
app.delete('/api/two-way-history/:id', isAuthenticated, (req, res) => {
    const query = 'DELETE FROM two_way_history WHERE id = ? AND user_id = ?';
    db.query(query, [req.params.id, req.session.userId], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true });
    });
});

// --- Quiz Routes ---

// Get quiz questions
app.get('/api/quiz-questions', (req, res) => {
    const query = 'SELECT * FROM quiz_questions ORDER BY RAND() LIMIT 30';
    db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Save quiz score
app.post('/api/quiz-score', isAuthenticated, (req, res) => {
    const { score, total_questions } = req.body;
    const query = 'INSERT INTO quiz_scores (user_id, score, total_questions) VALUES (?, ?, ?)';
    db.query(query, [req.session.userId, score, total_questions], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true, id: result.insertId });
    });
});

// Get quiz scores
app.get('/api/quiz-scores', isAuthenticated, (req, res) => {
    const query = 'SELECT * FROM quiz_scores WHERE user_id = ? ORDER BY created_at DESC LIMIT 20';
    db.query(query, [req.session.userId], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Delete quiz score
app.delete('/api/quiz-scores/:id', isAuthenticated, (req, res) => {
    const query = 'DELETE FROM quiz_scores WHERE id = ? AND user_id = ?';
    db.query(query, [req.params.id, req.session.userId], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true });
    });
});

// --- Lessons Routes ---

// Get sign language lessons
app.get('/api/lessons', (req, res) => {
    const { category } = req.query;
    let query = 'SELECT * FROM sign_language_lessons';
    let params = [];
    
    if (category) {
        query += ' WHERE category = ?';
        params.push(category);
    }
    
    db.query(query, params, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// --- Main Route ---

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'index.html'));
});

// Start server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
