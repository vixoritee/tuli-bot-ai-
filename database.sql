-- Membuat database Tulibot
CREATE DATABASE IF NOT EXISTS tulibot CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tulibot;

-- Tabel Users untuk autentikasi
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel untuk menyimpan riwayat chat AI Assistant per user
CREATE TABLE IF NOT EXISTS chat_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    user_message TEXT NOT NULL,
    ai_response TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabel untuk menyimpan skor kuis bahasa isyarat per user
CREATE TABLE IF NOT EXISTS quiz_scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    total_questions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabel untuk riwayat komunikasi dua arah per user
CREATE TABLE IF NOT EXISTS two_way_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    deaf_text TEXT,
    hearing_speech TEXT,
    language VARCHAR(20) DEFAULT 'id-ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabel untuk modul belajar bahasa isyarat
CREATE TABLE IF NOT EXISTS sign_language_lessons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    sign_image_url VARCHAR(500),
    level VARCHAR(20),
    pdf_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel untuk soal kuis
CREATE TABLE IF NOT EXISTS quiz_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert data modul belajar Huruf A-Z
INSERT INTO sign_language_lessons (category, title, description, level) VALUES
('huruf', 'Huruf A', 'Bahasa isyarat BISINDO untuk huruf A', 'Level 1'),
('huruf', 'Huruf B', 'Bahasa isyarat BISINDO untuk huruf B', 'Level 1'),
('huruf', 'Huruf C', 'Bahasa isyarat BISINDO untuk huruf C', 'Level 1'),
('huruf', 'Huruf D', 'Bahasa isyarat BISINDO untuk huruf D', 'Level 1'),
('huruf', 'Huruf E', 'Bahasa isyarat BISINDO untuk huruf E', 'Level 1'),
('huruf', 'Huruf F', 'Bahasa isyarat BISINDO untuk huruf F', 'Level 1'),
('huruf', 'Huruf G', 'Bahasa isyarat BISINDO untuk huruf G', 'Level 1'),
('huruf', 'Huruf H', 'Bahasa isyarat BISINDO untuk huruf H', 'Level 1'),
('huruf', 'Huruf I', 'Bahasa isyarat BISINDO untuk huruf I', 'Level 1'),
('huruf', 'Huruf J', 'Bahasa isyarat BISINDO untuk huruf J', 'Level 1'),
('huruf', 'Huruf K', 'Bahasa isyarat BISINDO untuk huruf K', 'Level 1'),
('huruf', 'Huruf L', 'Bahasa isyarat BISINDO untuk huruf L', 'Level 1'),
('huruf', 'Huruf M', 'Bahasa isyarat BISINDO untuk huruf M', 'Level 1'),
('huruf', 'Huruf N', 'Bahasa isyarat BISINDO untuk huruf N', 'Level 1'),
('huruf', 'Huruf O', 'Bahasa isyarat BISINDO untuk huruf O', 'Level 1'),
('huruf', 'Huruf P', 'Bahasa isyarat BISINDO untuk huruf P', 'Level 1'),
('huruf', 'Huruf Q', 'Bahasa isyarat BISINDO untuk huruf Q', 'Level 1'),
('huruf', 'Huruf R', 'Bahasa isyarat BISINDO untuk huruf R', 'Level 1'),
('huruf', 'Huruf S', 'Bahasa isyarat BISINDO untuk huruf S', 'Level 1'),
('huruf', 'Huruf T', 'Bahasa isyarat BISINDO untuk huruf T', 'Level 1'),
('huruf', 'Huruf U', 'Bahasa isyarat BISINDO untuk huruf U', 'Level 1'),
('huruf', 'Huruf V', 'Bahasa isyarat BISINDO untuk huruf V', 'Level 1'),
('huruf', 'Huruf W', 'Bahasa isyarat BISINDO untuk huruf W', 'Level 1'),
('huruf', 'Huruf X', 'Bahasa isyarat BISINDO untuk huruf X', 'Level 1'),
('huruf', 'Huruf Y', 'Bahasa isyarat BISINDO untuk huruf Y', 'Level 1'),
('huruf', 'Huruf Z', 'Bahasa isyarat BISINDO untuk huruf Z', 'Level 1');

-- Insert data modul belajar Angka 1-20
INSERT INTO sign_language_lessons (category, title, description, level) VALUES
('angka', 'Angka 1', 'Bahasa isyarat BISINDO untuk angka 1', 'Level 1'),
('angka', 'Angka 2', 'Bahasa isyarat BISINDO untuk angka 2', 'Level 1'),
('angka', 'Angka 3', 'Bahasa isyarat BISINDO untuk angka 3', 'Level 1'),
('angka', 'Angka 4', 'Bahasa isyarat BISINDO untuk angka 4', 'Level 1'),
('angka', 'Angka 5', 'Bahasa isyarat BISINDO untuk angka 5', 'Level 1'),
('angka', 'Angka 6', 'Bahasa isyarat BISINDO untuk angka 6', 'Level 1'),
('angka', 'Angka 7', 'Bahasa isyarat BISINDO untuk angka 7', 'Level 1'),
('angka', 'Angka 8', 'Bahasa isyarat BISINDO untuk angka 8', 'Level 1'),
('angka', 'Angka 9', 'Bahasa isyarat BISINDO untuk angka 9', 'Level 1'),
('angka', 'Angka 10', 'Bahasa isyarat BISINDO untuk angka 10', 'Level 1'),
('angka', 'Angka 11', 'Bahasa isyarat BISINDO untuk angka 11', 'Level 2'),
('angka', 'Angka 12', 'Bahasa isyarat BISINDO untuk angka 12', 'Level 2'),
('angka', 'Angka 13', 'Bahasa isyarat BISINDO untuk angka 13', 'Level 2'),
('angka', 'Angka 14', 'Bahasa isyarat BISINDO untuk angka 14', 'Level 2'),
('angka', 'Angka 15', 'Bahasa isyarat BISINDO untuk angka 15', 'Level 2'),
('angka', 'Angka 16', 'Bahasa isyarat BISINDO untuk angka 16', 'Level 2'),
('angka', 'Angka 17', 'Bahasa isyarat BISINDO untuk angka 17', 'Level 2'),
('angka', 'Angka 18', 'Bahasa isyarat BISINDO untuk angka 18', 'Level 2'),
('angka', 'Angka 19', 'Bahasa isyarat BISINDO untuk angka 19', 'Level 2'),
('angka', 'Angka 20', 'Bahasa isyarat BISINDO untuk angka 20', 'Level 2');

-- Insert data modul belajar Percakapan Dasar with Levels
INSERT INTO sign_language_lessons (category, title, description, level, pdf_url) VALUES
('pembelajaran', 'Level 1: Salam & Sapaan', 'Pelajari bahasa isyarat untuk salam dan sapaan dasar', 'Level 1', '/assets/pembelajaran/Level_1_Salam_dan_Sapaan.pdf'),
('pembelajaran', 'Level 2: Perkenalan Diri', 'Pelajari bahasa isyarat untuk memperkenalkan diri kepada orang lain', 'Level 2', '/assets/pembelajaran/Level_2_Perkenalan_Diri.pdf'),
('pembelajaran', 'Level 3: Tanya Jawab Dasar', 'Pelajari bahasa isyarat untuk tanya jawab dalam komunikasi sehari-hari', 'Level 3', '/assets/pembelajaran/Level_3_Tanya_Jawab_Dasar.pdf'),
('pembelajaran', 'Level 4: Keluarga & Hubungan', 'Pelajari bahasa isyarat untuk berbicara tentang keluarga dan hubungan', 'Level 4', '/assets/pembelajaran/Level_4_Keluarga_dan_Hubungan.pdf'),
('pembelajaran', 'Level 5: Waktu & Aktivitas Harian', 'Pelajari bahasa isyarat untuk berbicara tentang waktu dan kegiatan sehari-hari', 'Level 5', '/assets/pembelajaran/Level_5_Waktu_dan_Aktivitas_Harian.pdf'),
('pembelajaran', 'Level 6: Tempat & Arah', 'Pelajari bahasa isyarat untuk berbicara tentang tempat dan arah', 'Level 6', '/assets/pembelajaran/Level_6_Tempat_dan_Arah.pdf'),
('pembelajaran', 'Level 7: Perasaan & Emosi', 'Pelajari bahasa isyarat untuk mengekspresikan perasaan dan emosi', 'Level 7', '/assets/pembelajaran/Level_7_Perasaan_dan_Emosi.pdf'),
('pembelajaran', 'Level 8: Belanja & Transaksi', 'Pelajari bahasa isyarat untuk belanja dan transaksi keuangan', 'Level 8', '/assets/pembelajaran/Level_8_Belanja_dan_Transaksi.pdf'),
('pembelajaran', 'Level 9: Pekerjaan & Sekolah', 'Pelajari bahasa isyarat untuk berbicara tentang pekerjaan dan sekolah', 'Level 9', '/assets/pembelajaran/Level_9_Pekerjaan_dan_Sekolah.pdf'),
('pembelajaran', 'Level 10: Darurat & Kesehatan', 'Pelajari bahasa isyarat untuk situasi darurat dan kesehatan', 'Level 10', '/assets/pembelajaran/Level_10_Darurat_dan_Kesehatan.pdf');

-- Insert 30 soal kuis tanpa emoji, dengan skor 100 total
INSERT INTO quiz_questions (question, option_a, option_b, option_c, correct_option) VALUES
('Apa bahasa isyarat untuk angka 1?', 'Jari telunjuk diangkat', 'Jari telunjuk dan tengah diangkat', 'Jari telunjuk, tengah, dan manis diangkat', 'A'),
('Apa bahasa isyarat untuk angka 2?', 'Jari telunjuk, tengah, manis diangkat', 'Jari telunjuk dan tengah diangkat', 'Jari telunjuk diangkat', 'B'),
('Apa bahasa isyarat untuk "Halo"?', 'Menggeleng-geleng kepala', 'Menggeleng-geleng tangan ke samping', 'Mengangguk-angguk kepala', 'B'),
('Apa bahasa isyarat untuk "Terima Kasih"?', 'Menempelkan telapak tangan ke dada', 'Menggeleng-geleng tangan ke samping', 'Mengangguk-angguk kepala', 'A'),
('Apa bahasa isyarat untuk huruf A?', 'Tangan mengepal dengan ibu jari di samping', 'Tangan terbuka lebar', 'Jari telunjuk diangkat', 'A'),
('Apa bahasa isyarat untuk huruf B?', 'Tangan mengepal dengan ibu jari di samping', 'Tangan terbuka dengan jari-jari rapat', 'Jari telunjuk dan tengah diangkat', 'B'),
('Apa bahasa isyarat untuk "Tolong"?', 'Mengangkat kedua tangan ke atas dengan telapak tangan menghadap ke depan', 'Menempelkan telapak tangan ke dada', 'Menggeleng-geleng tangan', 'A'),
('Apa bahasa isyarat untuk "Selamat Pagi"?', 'Mengangkat tangan ke arah matahari', 'Menempelkan telapak tangan ke dada', 'Menggeleng-geleng tangan', 'A'),
('Apa bahasa isyarat untuk angka 3?', 'Jari telunjuk diangkat', 'Jari telunjuk dan tengah diangkat', 'Jari telunjuk, tengah, dan manis diangkat', 'C'),
('Apa bahasa isyarat untuk angka 4?', 'Empat jari diangkat kecuali ibu jari', 'Tiga jari diangkat', 'Lima jari diangkat', 'A'),
('Apa bahasa isyarat untuk huruf C?', 'Tangan membentuk huruf C', 'Tangan mengepal', 'Tangan terbuka', 'A'),
('Apa bahasa isyarat untuk huruf D?', 'Jari telunjuk diangkat, jari lain mengepal', 'Tangan terbuka', 'Tangan mengepal', 'A'),
('Apa bahasa isyarat untuk angka 5?', 'Lima jari diangkat', 'Empat jari diangkat', 'Tiga jari diangkat', 'A'),
('Apa bahasa isyarat untuk "Selamat Siang"?', 'Mengangkat tangan ke atas pada ketinggian dada', 'Menempelkan telapak tangan ke dada', 'Menggeleng-geleng tangan', 'A'),
('Apa bahasa isyarat untuk "Selamat Malam"?', 'Mengangkat tangan ke atas dengan jari-jari menyentak seperti bintang', 'Menempelkan telapak tangan ke dada', 'Menggeleng-geleng tangan', 'A'),
('Apa bahasa isyarat untuk "Saya"?', 'Menunjuk ke dada sendiri', 'Menunjuk ke orang lain', 'Menggeleng-geleng tangan', 'A'),
('Apa bahasa isyarat untuk "Kamu"?', 'Menunjuk ke orang lain', 'Menunjuk ke dada sendiri', 'Menggeleng-geleng tangan', 'A'),
('Apa bahasa isyarat untuk "Kita"?', 'Menunjuk ke dada sendiri lalu ke orang lain', 'Menunjuk ke orang lain', 'Menunjuk ke dada sendiri', 'A'),
('Apa bahasa isyarat untuk "Senang"?', 'Menggambarkan senyum di wajah dengan jari', 'Menggambarkan sedih di wajah', 'Menggeleng-geleng tangan', 'A'),
('Apa bahasa isyarat untuk "Sedih"?', 'Menggambarkan air mata di wajah dengan jari', 'Menggambarkan senyum di wajah', 'Menggeleng-geleng tangan', 'A'),
('Apa bahasa isyarat untuk "Marah"?', 'Membentuk tangan seperti cakar di dekat wajah', 'Menggambarkan senyum di wajah', 'Menggeleng-geleng tangan', 'A'),
('Apa bahasa isyarat untuk "Tidak"?', 'Menggeleng-geleng kepala atau menggerakkan tangan ke samping', 'Mengangguk-angguk kepala', 'Menggeleng-geleng tangan ke atas', 'A'),
('Apa bahasa isyarat untuk "Ya"?', 'Mengangguk-angguk kepala', 'Menggeleng-geleng kepala', 'Menggeleng-geleng tangan', 'A'),
('Apa bahasa isyarat untuk "Bagus"?', 'Jempol diangkat ke atas', 'Jempol diangkat ke bawah', 'Jari telunjuk diangkat', 'A'),
('Apa bahasa isyarat untuk "Buruk"?', 'Jempol diangkat ke bawah', 'Jempol diangkat ke atas', 'Jari telunjuk diangkat', 'A'),
('Apa bahasa isyarat untuk "Makan"?', 'Menempelkan tangan ke mulut seperti memegang sendok', 'Menempelkan tangan ke perut', 'Menempelkan tangan ke dada', 'A'),
('Apa bahasa isyarat untuk "Minum"?', 'Menempelkan tangan ke mulut seperti memegang gelas', 'Menempelkan tangan ke perut', 'Menempelkan tangan ke dada', 'A'),
('Apa bahasa isyarat untuk "Rumah"?', 'Membentuk atap rumah dengan tangan', 'Membentuk kotak dengan tangan', 'Membentuk lingkaran dengan tangan', 'A'),
('Apa bahasa isyarat untuk "Sekolah"?', 'Menempelkan tangan ke kepala seperti memegang buku', 'Membentuk atap rumah dengan tangan', 'Menempelkan tangan ke dada', 'A'),
('Apa bahasa isyarat untuk "Teman"?', 'Menyambungkan kedua jari telunjuk', 'Menyambungkan kedua jari kelingking', 'Menyambungkan kedua ibu jari', 'A');
