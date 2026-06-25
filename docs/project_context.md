# PROJECT_CONTEXT.md

# Plantify.PNP Project Context

Version: 3.0

Project Status:
Active Development (Flutter Phase 2 Completed)

---

# Current Project Status

Implementasi aplikasi Flutter mengikuti tahapan yang diatur pada `DEVELOPMENT_ROADMAP.md`.

Status saat ini:
* **Phase 1 (Project Initialization)**: Selesai.
* **Phase 2 (UI Implementation)**: Selesai.
* **Phase berikutnya**: Akan mengikuti panduan dan urutan pada `DEVELOPMENT_ROADMAP.md`.

---

# Document Responsibility

Proyek ini memiliki beberapa dokumen sumber kebenaran (Source of Truth) yang mengatur area spesifik:

* **`PROJECT_CONTEXT.md`** (Dokumen ini) → Menjelaskan visi, tujuan utama, ruang lingkup (scope), daftar aktor, kebutuhan sistem, flow aplikasi, dan konteks proyek secara umum.
* **`DEVELOPMENT_ROADMAP.md`** → Menjelaskan urutan implementasi aplikasi Flutter (Phase 1–13) dan menjadi satu-satunya acuan urutan pengerjaan bagi Agent.
* **`FLUTTER_ARCHITECTURE.md`** → Menjelaskan struktur folder (Feature-First), arsitektur Clean Architecture (Simplified), dan pola implementasi kode menggunakan Provider.
* **`DATABASE_SPEC.md`** → Menjelaskan struktur, skema, relasi, dan tipe data dari database SQLite.
* **`UI_GUIDELINE.md`** → Menjelaskan standar UI/UX, warna, tipografi, dan aturan interpretasi desain Material 3 aplikasi.
* **`MASTER_PROMPT.md`** → Menjelaskan aturan implementasi, batasan, dan instruksi mutlak yang harus diikuti oleh Agent.
* **`cnn/TRAINING_SPEC.md`** → Menjelaskan spesifikasi model AI dan dataset (berada di luar scope pengembangan Flutter).

---

# Source of Truth Priority

Apabila terjadi konflik informasi antar dokumen, Agent wajib mengikuti urutan prioritas berikut:

1. PROJECT_CONTEXT.md
2. DATABASE_SPEC.md
3. FLUTTER_ARCHITECTURE.md
4. DEVELOPMENT_ROADMAP.md
5. MASTER_PROMPT.md
6. UI_GUIDELINE.md

*Catatan: DEVELOPMENT_ROADMAP.md merupakan sumber kebenaran khusus untuk urutan implementasi Flutter (Phase 1–13), sedangkan PROJECT_CONTEXT.md menjadi sumber kebenaran untuk konteks, tujuan, ruang lingkup, dan kebutuhan sistem.*

---

# General Development Principles

* Tidak menambah fitur di luar scope proyek.
* Tidak menghapus fitur yang telah ditetapkan.
* Tidak mengubah flow User maupun Admin.
* Tidak mengubah struktur Bottom Navigation.
* Tidak mengubah struktur database di luar DATABASE_SPEC.md.
* Tidak mengubah roadmap di luar DEVELOPMENT_ROADMAP.md.
* Tidak melakukan redesign UI yang bertentangan dengan UI_GUIDELINE.md.

---

# Project Identity

Project Name: Plantify.PNP
Project Type: Mobile Application
Platform: Android
Framework: Flutter
Architecture: Offline First (Clean Architecture Simplified + Feature-First)
Database: SQLite
AI Framework: TensorFlow Lite
CNN Architecture: MobileNetV2

---

# Project Description

Plantify.PNP adalah aplikasi mobile berbasis Flutter yang digunakan untuk mengidentifikasi jenis tanaman berdasarkan citra daun menggunakan model Convolutional Neural Network (CNN).

Model AI dilatih menggunakan TensorFlow (di luar scope aplikasi) dan diekspor ke TensorFlow Lite agar dapat dijalankan secara lokal pada perangkat Android tanpa koneksi internet. Aplikasi ini ditujukan untuk membantu pengguna mengenali tanaman yang terdapat di lingkungan kampus Politeknik Negeri Padang (PNP).

---

# Main Objectives

Aplikasi bertujuan untuk:
1. Mengidentifikasi tanaman berdasarkan foto daun.
2. Menampilkan informasi detail tanaman.
3. Menampilkan manfaat tanaman.
4. Menyimpan riwayat identifikasi secara otomatis.
5. Menyediakan pengelolaan informasi tanaman oleh admin.
6. Berjalan secara offline tanpa ketergantungan internet.
7. Mengintegrasikan model CNN ke aplikasi Flutter.

---

# Project Scope

## Included
Fitur yang termasuk dalam ruang lingkup aplikasi Flutter:
* Login & Register
* Logout
* Dashboard User
* Scan tanaman menggunakan kamera & galeri
* Identifikasi tanaman menggunakan TFLite
* Detail tanaman
* Riwayat scan (melihat dan menghapus)
* Profil pengguna (melihat dan mengubah nama)
* Admin Dashboard
* Kelola tanaman (CRUD)
* Kelola user (Aktif/Nonaktif)

*Catatan: Seluruh fitur pada daftar Included akan diimplementasikan secara bertahap sesuai urutan phase yang didefinisikan pada DEVELOPMENT_ROADMAP.md.*

## Excluded
Fitur berikut berada di luar ruang lingkup proyek:
* Deteksi penyakit tanaman
* Chatbot AI / Sistem rekomendasi AI
* Marketplace tanaman
* Reminder penyiraman & Informasi cuaca
* Sinkronisasi cloud & Multi-device synchronization
* Backend server / REST API
* Training model CNN (dilakukan terpisah via Kaggle/Colab)

---

# User Roles

Terdapat dua role utama dalam aplikasi.

## User
Hak akses:
* Login & Register
* Melakukan scan tanaman (Kamera/Galeri)
* Melihat hasil identifikasi & detail tanaman
* Melihat riwayat scan & menghapus riwayat
* Melihat profil & mengubah nama
* Logout

## Admin
Hak akses:
* Login
* Dashboard Admin
* Kelola data tanaman (Tambah, Edit, Hapus)
* Kelola pengguna (Melihat daftar, Aktifkan, Nonaktifkan pengguna - tidak bisa menghapus)
* Logout

*Catatan: Admin tidak mengelola Dataset CNN, proses Model Training, maupun pembuatan file TensorFlow Lite melalui aplikasi ini.*

---

# Authentication & Session

Authentication menggunakan `email` dan `password`.
Terdapat dua jenis role: `admin` dan `user`.
Data akun pengguna disimpan pada database SQLite.

Session Management (status login) menggunakan **SharedPreferences** untuk menyimpan:
* `logged_in_user_id`
* `logged_in_role`

**Flow:**
Splash Screen → Check Session → Role Check → Redirect ke Dashboard (User / Admin)
Jika session tidak ditemukan → Login Screen.

---

# Application Mode & Requirements

**Mode aplikasi:** Offline First
Seluruh fitur utama (termasuk identifikasi AI) harus tetap berjalan tanpa akses internet. Aplikasi tidak menggunakan REST API, Backend Server, maupun Firebase.

**Android Requirements:**
* Minimum: Android 8.0 (API 26)
* Target: Latest Android SDK supported by Flutter
* Required Permissions: Camera & Gallery (Storage)

---

# AI Identification System

**Input:** Foto daun tanaman (dari Kamera atau Galeri).
**Output:** Nama tanaman, Confidence score, Deskripsi, Manfaat.

**Identification Pipeline (Phase 10):**
Image → Preprocessing → TensorFlow Lite → Prediction → Confidence Score → Threshold Check → Result Screen

**Confidence Threshold:**
* Default: **70%** (Dapat disesuaikan berdasarkan hasil evaluasi akhir). Nilai threshold ini menggunakan `AppConstants.confidenceThreshold` sehingga dapat diubah tanpa mengubah logika aplikasi.
* Jika confidence ≥ 70% → Tampilkan hasil identifikasi valid.
* Jika confidence < 70% → Tampilkan "Tanaman Tidak Dikenali".

---

# Supported Plant Classes

Sistem mendeteksi 11 kelas tanaman:
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

*(Pembuatan dataset 200 foto per kelas dan akurasi model 85%-90% menjadi target di luar lingkup coding Flutter).*

---

# Key Features Logic

## User Navigation Structure
Menggunakan Bottom Navigation (diatur oleh `MainScaffold` dengan `IndexedStack`):
1. Home (Dashboard)
2. Scan
3. History
4. Profile

*Halaman turunan (Result, Plant Detail) ditempatkan di atas MainScaffold.*

## Admin Navigation Structure
Admin tidak menggunakan Bottom Navigation. Navigasi menggunakan Named Routes standard.
Admin Dashboard → Manage Plants → Manage Users (dan sub-halamannya).

## Dashboard User
Komponen utama:
* Welcome Section
* Search Bar (mencari tanaman berdasarkan nama)
* Quick Scan
* Plant Recommendation (menampilkan daftar tanaman secara acak, bukan rekomendasi AI)
* Recent Scan

## Scan Feature
* Flow: Pilih Gambar → TensorFlow Lite Prediction → Result Screen → Simpan otomatis ke SQLite (`riwayat_scan`).
* Selama fase implementasi sebelum integrasi TensorFlow Lite selesai, hasil identifikasi dapat disimulasikan sesuai DEVELOPMENT_ROADMAP.md.

## Profile Feature
User hanya dapat mengubah nama. Email, role, dan password bersifat statis (tidak dapat diubah setelah registrasi).

## Admin Plant Management
Admin dapat melakukan CRUD data tanaman (nama, deskripsi, manfaat, gambar, dan `label_model`).
Gambar tanaman disimpan secara lokal sesuai implementasi yang didefinisikan pada FLUTTER_ARCHITECTURE.md.

## Admin User Management
Admin dapat melihat daftar pengguna, mengaktifkan, atau menonaktifkan pengguna. Admin **tidak dapat** menghapus data pengguna.
