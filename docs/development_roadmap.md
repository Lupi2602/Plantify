# DEVELOPMENT_ROADMAP.md

# Plantify.PNP Flutter Development Roadmap

Version: 3.0

Status:
Active Development

Scope:
Flutter Application Development

---

# Purpose

Dokumen ini mendefinisikan roadmap resmi pengembangan aplikasi Flutter Plantify.PNP.

Dokumen ini digunakan untuk:

* Menentukan urutan implementasi
* Menjaga fokus pengembangan
* Mengurangi refactor yang tidak perlu
* Menghemat penggunaan token Agent
* Menjaga konsistensi implementasi

---

# Flutter Development Scope

Dokumen ini hanya mengatur implementasi aplikasi Flutter.

Dokumen ini TIDAK mengatur:

* Dataset Collection
* CNN Training
* Model Evaluation
* TensorFlow Training
* Kaggle Workflow
* Google Colab Workflow

---

Topik tersebut dijelaskan pada:

cnn/TRAINING_SPEC.md

---

TRAINING_SPEC.md digunakan sebagai referensi integrasi AI.

Agent tidak boleh menjalankan training model sebagai bagian dari roadmap Flutter.

---

# Development Philosophy

Plantify.PNP dikembangkan secara bertahap.

Setiap fase harus selesai dan stabil sebelum melanjutkan ke fase berikutnya.

---

Agent wajib:

* mengikuti urutan fase
* menyelesaikan satu fase sebelum fase berikutnya
* menghindari implementasi prematur
* fokus pada kebutuhan proyek

---

# Parallel Development Notes

Project memiliki dua jalur pengembangan yang berbeda.

---

1. Flutter Development

Mengikuti:

DEVELOPMENT_ROADMAP.md

---

2. CNN Development

Mengikuti:

TRAINING_SPEC.md

---

Kedua jalur dapat berjalan secara paralel.

Namun implementasi Flutter tidak bergantung pada proses training.

---

TensorFlow Lite Integration hanya dilakukan ketika:

* model.tflite tersedia
* labels.txt tersedia

---

# Official Development Flow

Project Setup

↓

UI Development

↓

Navigation

↓

SQLite

↓

Authentication

↓

Plant Management

↓

User Management

↓

History

↓

Scan Module

↓

TensorFlow Lite Integration

↓

Testing

↓

Optimization

↓

Release

---

# Phase 1

Project Initialization

Priority:
Critical

---

Objective

Membangun fondasi project Flutter.

---

Tasks

* Create Flutter Project
* Setup Material 3
* Setup Folder Structure
* Setup Theme
* Setup Assets Folder
* Setup Routing Configuration
* Setup Provider Configuration
* Create Base Widgets

---

Reference

* FLUTTER_ARCHITECTURE.md
* UI_GUIDELINE.md

---

Output

Project dapat dijalankan tanpa error.

---

Success Criteria

* flutter run berhasil
* Tidak ada compile error
* Struktur folder sesuai dokumentasi

---

# Phase 2

UI Implementation

Priority:
Critical

---

Objective

Mengimplementasikan seluruh tampilan aplikasi.

---

Reference

* UI_GUIDELINE.md
* Folder ui/

---

Tasks

* Splash Screen
* Login Screen
* Register Screen
* User Dashboard
* Scan Screen
* Result Screen
* Plant Detail Screen
* History Screen
* Profile Screen
* Admin Dashboard
* Manage Plant Screen
* Add Plant Screen
* Edit Plant Screen
* Manage User Screen

---

Rules

Gunakan dummy data sementara.

Belum perlu koneksi database.

Fokus pada:

* Visual
* Layout
* Responsiveness
* Material 3

---

Output

Seluruh halaman tersedia.

---

Success Criteria

* Semua halaman dapat ditampilkan
* Layout sesuai referensi UI
* Tidak ada halaman kosong

---

# Phase 3

Navigation & Routing

Priority:
Critical

---

Objective

Menghubungkan seluruh halaman aplikasi.

---

Tasks

* Named Routes
* Navigation Flow
* Bottom Navigation
* Admin Navigation
* Session Redirect Flow
* Role Redirect Flow

---

Reference

* PROJECT_CONTEXT.md
* UI_GUIDELINE.md

---

Output

Flow aplikasi berjalan.

---

Success Criteria

* Tidak ada halaman terputus
* Semua navigasi berfungsi

---

# Phase 4

SQLite Foundation

Priority:
Critical

---

Objective

Mengimplementasikan database lokal.

---

Reference

DATABASE_SPEC.md

---

Tasks

* Database Initialization
* Database Helper
* Database Versioning
* Foreign Key Activation
* Create Tables
* Repository Setup
* Model Classes

---

Tables

* users
* tanaman
* riwayat_scan

---

Output

SQLite siap digunakan.

---

Success Criteria

* Database berhasil dibuat
* CRUD dasar berhasil berjalan
* Foreign Key aktif

---

# Phase 5

Authentication Module

Priority:
High

---

Objective

Menghubungkan Login dan Register dengan SQLite.

---

Tasks

* Register User
* Login User
* Logout User
* Session Management
* SharedPreferences Integration
* Role Validation

---

Output

Authentication berjalan.

---

Success Criteria

* User dapat login
* Admin dapat login
* Session tersimpan
* Redirect role berjalan

---

# Phase 6

Plant Management Module

Priority:
High

---

Objective

Menyelesaikan fitur pengelolaan tanaman.

---

Tasks

* Plant List
* Add Plant
* Edit Plant
* Delete Plant
* Validation
* Image Picker Integration
* Local Image Storage

---

Important Rules

Gambar yang dipilih admin:

↓

disimpan ke local storage aplikasi

↓

path disimpan ke SQLite

---

Admin tidak menyimpan gambar ke folder assets.

---

Output

CRUD tanaman selesai.

---

Success Criteria

* Tambah tanaman berhasil
* Edit tanaman berhasil
* Hapus tanaman berhasil
* Upload gambar berhasil

---

# Phase 7

User Management Module

Priority:
Medium

---

Objective

Menyelesaikan fitur pengelolaan user.

---

Tasks

* User List
* Activate User
* Deactivate User

---

Output

Manajemen user selesai.

---

Success Criteria

* Status user dapat diubah
* Data tersimpan ke SQLite

---

# Phase 8

History Module

Priority:
High

---

Objective

Menyelesaikan fitur riwayat scan.

---

Tasks

* Read History
* Delete History
* Recent Scan Widget

---

Output

Riwayat tersedia.

---

Success Criteria

* Riwayat dapat ditampilkan
* Riwayat dapat dihapus
* Recent Scan berjalan

---

# Phase 9

Scan Module

Priority:
High

---

Objective

Menyelesaikan flow scan sebelum integrasi AI.

---

Tasks

* Camera Permission
* Gallery Permission
* Image Picker
* Image Preview
* Scan Flow
* Result Flow
* Dummy Prediction
* Auto Save Scan Result

---

Current State

Belum menggunakan TensorFlow Lite.

Menggunakan dummy prediction.

---

Flow

Pilih Gambar

↓

Dummy Prediction

↓

Result Screen

↓

Save History

↓

riwayat_scan

---

Success Criteria

* Pengguna dapat memilih gambar
* Result Screen tampil
* Dummy prediction berjalan
* Hasil otomatis tersimpan ke riwayat_scan

---

# Phase 10

TensorFlow Lite Integration

Priority:
High

---

Prerequisite

* model.tflite tersedia
* labels.txt tersedia
* label_model telah diverifikasi

---

Objective

Mengintegrasikan model AI ke Flutter.

---

Tasks

* TFLite Service
* Load Model
* Load Labels
* Image Preprocessing
* Prediction
* Confidence Calculation
* Threshold Logic
* Result Mapping
* Verify labels.txt
* Verify label_model
* Validate Mapping Consistency

---

Important Rules

Nilai:

label_model

pada tabel tanaman

harus identik dengan:

labels.txt

---

Contoh Benar

sirih_hijau

=

sirih_hijau

---

Contoh Salah

Sirih Hijau

SirihHijau

sirih-hijau

---

Output

Prediksi nyata berjalan.

---

Success Criteria

* Model berhasil dimuat
* Prediksi berhasil berjalan
* Threshold berjalan
* Mapping database berhasil
* Tidak ada label mismatch

---

# Phase 11

Application Testing

Priority:
Critical

---

Objective

Melakukan pengujian seluruh aplikasi.

---

Tasks

* Authentication Testing
* Navigation Testing
* Database Testing
* Role Testing
* History Testing
* Plant Management Testing
* Scan Testing
* TensorFlow Lite Testing

---

Output

Bug ditemukan dan diperbaiki.

---

Success Criteria

* Semua fitur berjalan normal

---

# Phase 12

Optimization

Priority:
Medium

---

Objective

Meningkatkan performa aplikasi.

---

Tasks

* Code Cleanup
* Reduce Rebuild
* Improve Loading Time
* Optimize Database Queries
* Optimize Image Handling
* Optimize Model Loading

---

Output

Aplikasi lebih ringan dan stabil.

---

Success Criteria

* Performa meningkat
* Memory usage stabil

---

# Phase 13

Release Preparation

Priority:
Final

---

Objective

Persiapan demo dan sidang.

---

Tasks

* Final Testing
* APK Build
* Screenshot Collection
* Documentation Review
* Demo Preparation

---

Output

APK Final

---

Success Criteria

* Aplikasi siap dipresentasikan
* APK dapat diinstal tanpa masalah

---

# Agent Rules

Agent wajib:

* mengikuti urutan roadmap
* menyelesaikan satu fase sebelum fase berikutnya
* fokus pada Flutter Development
* mengikuti seluruh dokumentasi proyek

---

Agent tidak boleh:

* membuat training pipeline
* menjalankan training CNN
* membuat notebook Kaggle
* membuat notebook Colab
* memodifikasi folder cnn/
* mengintegrasikan TensorFlow Lite sebelum model tersedia

---

# Reference Documents

1. PROJECT_CONTEXT.md
2. DATABASE_SPEC.md
3. UI_GUIDELINE.md
4. FLUTTER_ARCHITECTURE.md
5. TRAINING_SPEC.md

---

Dokumen ini merupakan roadmap resmi pengembangan Flutter Plantify.PNP.
