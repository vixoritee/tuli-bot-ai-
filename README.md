# Tulibot - Aplikasi Komunikasi Tunarungu

Aplikasi web aksesibilitas untuk membantu komunikasi antara tunarungu dan orang dengar, dengan fitur AI Assistant, modul belajar bahasa isyarat, dan kuis interaktif.

## Fitur Utama

1. **Komunikasi Dua Arah** - Split-screen untuk komunikasi real-time
2. **AI Assistant (Guru Digital)** - Tanya jawab dengan AI yang ramah
3. **Modul Belajar Bahasa Isyarat** - 3 kategori (Huruf, Angka, Percakapan)
4. **Quiz Interaktif** - 30 soal pilihan ganda dengan skor dan progress
5. **Riwayat** - Menyimpan riwayat percakapan dan skor kuis
6. **Pengenal Gestur** - Placeholder untuk camera-based gesture recognition
7. **Donasi** - Informasi donasi untuk pengembangan aplikasi
8. **Sistem Autentikasi** - Login dan Register untuk setiap user

## Cara Menjalankan

### 1. Instalasi Database
- Pastikan MySQL / XAMPP sudah berjalan
- Buka phpMyAdmin (http://localhost/phpmyadmin)
- Import file `database.sql`

### 2. Konfigurasi Environment
- Salin `.env` (sudah dibuat) dan sesuaikan isinya jika perlu:
```
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=tulibot
GEMINI_API_KEY=your_gemini_api_key_here
```

### 3. Instalasi Dependencies
```bash
npm install
```

### 4. Jalankan Server
```bash
npm start
```

### 5. Akses Aplikasi
Buka browser dan kunjungi: http://localhost:3000

## Teknologi yang Digunakan

- **Backend**: Node.js + Express
- **Database**: MySQL (tanpa ORM)
- **Frontend**: HTML, CSS, Vanilla JavaScript
- **Desain**: Glassmorphism + High Contrast
- **AI**: Google Gemini API (optional)

## Fitur Browser yang Didukung

Gunakan **Chrome / Microsoft Edge** untuk fitur Speech Recognition terbaik!

## Struktur Proyek

```
Tulibot/
├── public/
│   ├── css/
│   │   └── style.css
│   └── js/
│       └── main.js
├── views/
│   └── index.html
├── database.sql
├── server.js
├── package.json
├── .env
└── README.md
```
