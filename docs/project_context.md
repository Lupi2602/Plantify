# PROJECT_CONTEXT.md

# Plantify.PNP Project Context

Version: 2.0

Project Status:
Planning & Development Phase

---

# Project Identity

Project Name:

Plantify.PNP

---

Project Type:

Mobile Application

---

Platform:

Android

---

Framework:

Flutter

---

Architecture:

Offline First

---

Database:

SQLite

---

AI Framework:

TensorFlow Lite

---

CNN Architecture:

MobileNetV2

---

# Project Description

Plantify.PNP adalah aplikasi mobile berbasis Flutter yang digunakan untuk mengidentifikasi jenis tanaman berdasarkan citra daun menggunakan model Convolutional Neural Network (CNN).

Model AI dilatih menggunakan TensorFlow dan diekspor ke TensorFlow Lite agar dapat dijalankan secara lokal pada perangkat Android tanpa koneksi internet.

Aplikasi ditujukan untuk membantu pengguna mengenali tanaman yang terdapat di lingkungan kampus Politeknik Negeri Padang (PNP).

---

# Main Objectives

Aplikasi bertujuan untuk:

1. Mengidentifikasi tanaman berdasarkan foto daun.
2. Menampilkan informasi tanaman.
3. Menampilkan manfaat tanaman.
4. Menyimpan riwayat identifikasi.
5. Menyediakan pengelolaan informasi tanaman oleh admin.
6. Berjalan secara offline tanpa internet.
7. Mengintegrasikan model CNN ke aplikasi Flutter.

---

# Project Scope

## Included

Fitur yang termasuk dalam ruang lingkup proyek:

* Login
* Register
* Logout
* Dashboard User
* Dashboard Admin
* Scan tanaman menggunakan kamera
* Upload gambar dari galeri
* Identifikasi tanaman
* Detail tanaman
* Riwayat scan
* Profil pengguna
* Kelola tanaman
* Kelola user

---

## Excluded

Fitur berikut berada di luar ruang lingkup proyek:

* Deteksi penyakit tanaman
* Chatbot AI
* Marketplace tanaman
* Reminder penyiraman
* Cuaca
* Sistem rekomendasi AI
* Sinkronisasi cloud
* Backend server
* Multi-device synchronization

---

# User Roles

Terdapat dua role utama.

---

## User

Hak akses:

* Login
* Register
* Scan tanaman
* Upload galeri
* Melihat hasil identifikasi
* Melihat detail tanaman
* Melihat riwayat scan
* Menghapus riwayat scan
* Melihat profil
* Logout

---

## Admin

Hak akses:

* Login
* Logout
* Dashboard Admin
* Kelola tanaman
* Kelola user

Admin tidak mengelola:

* Dataset CNN
* Model Training
* TensorFlow Lite

---

# Authentication

Authentication menggunakan:

* Email
* Password

---

Role:

* admin
* user

---

Session Management menggunakan:

SharedPreferences

---

Session Data:

* logged_in_user_id
* logged_in_role

---

Flow:

Splash Screen

↓

Check Session

↓

Role Check

↓

Dashboard sesuai role

---

Jika session tidak ditemukan:

↓

Login Screen

---

# Application Mode

Mode aplikasi:

Offline First

---

Seluruh fitur utama harus tetap berjalan tanpa internet.

---

Tidak menggunakan:

* REST API
* Backend Server
* Cloud Database
* Firebase

---

# Android Requirements

Minimum Android Version:

Android 8.0 (API 26)

---

Required Permissions:

* Camera
* Gallery Access

---

Aplikasi harus mendukung:

* Android 8+
* Android 9+
* Android 10+
* Android 11+
* Android 12+
* Android 13+

---

# AI Identification System

Input:

Foto daun tanaman.

---

Source:

* Kamera
* Galeri

---

Output:

* Nama tanaman
* Confidence score
* Deskripsi
* Manfaat

---

# Identification Pipeline

Image

↓

Preprocessing

↓

TensorFlow Lite

↓

Prediction

↓

Confidence Score

↓

Threshold Check

↓

Result Screen

---

# Confidence Threshold

Default:

70%

---

Jika confidence ≥ 70%

↓

Tampilkan hasil identifikasi.

---

Jika confidence < 70%

↓

Tampilkan:

"Tanaman Tidak Dikenali"

---

Catatan:

Threshold final dapat disesuaikan berdasarkan hasil evaluasi model.

---

# Supported Plant Classes

Jumlah kelas:

11

---

Daftar tanaman:

1. Bleeding Heartvine
2. Markisa
3. Jambu Biji
4. Sirih Hijau
5. Talas
6. Sirih Merah
7. Nangka
8. Miana
9. Rombusa
10. Pucuk Merah
11. Heliconia

---

# Dataset Information

Source:

100% foto sendiri.

---

Target Dataset:

200 foto per kelas.

---

Jumlah kelas:

11

---

Target Total Dataset:

2200 foto.

---

Objek utama:

Daun tanaman.

---

Dataset tidak menggunakan gambar internet sebagai sumber utama.

---

# Target Model Performance

Target Accuracy:

85% - 90%

---

Metrics:

* Accuracy
* Precision
* Recall
* F1 Score

---

# Database

Database Engine:

SQLite

---

Database Name:

plantify.db

---

Tabel utama:

1. users
2. tanaman
3. riwayat_scan

---

Referensi lengkap:

DATABASE_SPEC.md

---

# User Navigation Structure

Bottom Navigation digunakan untuk User.

---

Menu:

1. Home
2. Scan
3. History
4. Profile

---

Halaman turunan:

Scan

↓

Result

↓

Plant Detail

---

# Admin Navigation Structure

Admin Dashboard

↓

Manage Plants

↓

Manage Users

---

Admin tidak menggunakan Bottom Navigation.

---

# Dashboard User

Komponen utama:

* Welcome Section
* Search Bar
* Quick Scan
* Plant Recommendation
* Recent Scan

---

Search Bar

Digunakan untuk mencari tanaman berdasarkan nama tanaman.

---

Plant Recommendation

Menampilkan daftar tanaman secara acak.

Tidak menggunakan AI Recommendation System.

---

# Scan Feature

User dapat:

* mengambil foto menggunakan kamera
* memilih foto dari galeri

---

Setelah gambar dipilih:

↓

Identifikasi dilakukan menggunakan TensorFlow Lite

↓

Result Screen

---

# Result Screen

Menampilkan:

* gambar tanaman
* nama tanaman
* confidence score
* deskripsi
* manfaat

---

Jika confidence rendah:

Tampilkan:

Tanaman Tidak Dikenali

---

# History Feature

Riwayat disimpan otomatis setelah identifikasi berhasil.

---

User dapat:

* melihat riwayat
* menghapus riwayat

---

# Profile Feature

Menampilkan:

* nama
* email
* role

---

Fase awal:

User hanya dapat mengubah nama.

---

Email dan password belum dapat diubah.

---

# Admin Plant Management

Admin dapat:

* tambah tanaman
* edit tanaman
* hapus tanaman

---

Data yang dikelola:

* nama tanaman
* deskripsi
* manfaat
* gambar
* label model

---

# Admin User Management

Admin dapat:

* melihat daftar user
* mengaktifkan user
* menonaktifkan user

---

# Development Phases

## Phase 1

Flutter UI Prototype

Target:

* seluruh UI selesai
* dummy data
* navigation selesai

---

## Phase 2

SQLite Integration

Target:

* authentication
* data persistence
* CRUD tanaman
* riwayat scan

---

## Phase 3

CNN Training

Target:

* dataset selesai
* MobileNetV2 training
* evaluation

---

## Phase 4

TensorFlow Lite Integration

Target:

* model.tflite
* labels.txt
* real prediction

---

## Phase 5

Testing & Optimization

Target:

* bug fixing
* performance optimization
* final deployment

---

# Success Criteria

Aplikasi dianggap berhasil apabila:

1. Dapat mengidentifikasi 11 jenis tanaman.
2. Berjalan secara offline.
3. Menampilkan hasil identifikasi.
4. Menampilkan detail tanaman.
5. Menyimpan riwayat scan.
6. Memiliki fitur admin dan user.
7. Mengintegrasikan TensorFlow Lite.
8. Mencapai akurasi minimal 85%.
9. Mengikuti desain UI Plantify.PNP.

---

# Source of Truth

Dokumen ini merupakan sumber kebenaran utama proyek.

Dokumen lain yang harus sinkron dengan dokumen ini:

* DATABASE_SPEC.md
* UI_GUIDELINE.md
* FLUTTER_ARCHITECTURE.md
* TRAINING_SPEC.md
* DEVELOPMENT_ROADMAP.md
* MASTER_PROMPT.md
