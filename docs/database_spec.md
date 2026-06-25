# DATABASE_SPEC.md

# Plantify.PNP Database Specification

Version: 2.0

Database Engine: SQLite

Database Name: plantify.db

---

# Purpose

Dokumen ini merupakan spesifikasi resmi database Plantify.PNP.

Dokumen ini menjadi sumber kebenaran utama (Single Source of Truth) untuk:

* SQLite Schema
* Entity Relationship
* Repository Pattern
* Data Validation Rules
* Authentication Data
* Scan History Storage

Seluruh implementasi database wajib mengikuti dokumen ini.

---

# Database Overview

Plantify.PNP menggunakan SQLite sebagai database lokal.

Karena aplikasi bersifat Offline First, seluruh data disimpan langsung pada perangkat pengguna.

Database digunakan untuk:

1. User Authentication
2. Role Management
3. Plant Information
4. Scan History

Tidak menggunakan:

* MySQL
* PostgreSQL
* Firebase
* Supabase
* REST API
* Backend Server
* Cloud Database

---

# Database Architecture

Database terdiri dari 3 tabel utama:

1. users
2. tanaman
3. riwayat_scan

---

# Entity Relationship Diagram

users

1

↓

N

riwayat_scan

N

↑

1

tanaman

---

# TABLE: users

## Description

Menyimpan akun pengguna aplikasi.

Digunakan untuk:

* Login
* Register
* Session Management
* Role Management

---

## Columns

### id

Type:

INTEGER

Properties:

PRIMARY KEY AUTOINCREMENT

---

### nama

Type:

TEXT

Required:

YES

Description:

Nama pengguna.

Contoh:

Luthfi Tsani Ranofan

---

### email

Type:

TEXT

Required:

YES

Unique:

YES

Collation:

NOCASE

Description:

Digunakan untuk login.

Semua email wajib disimpan dalam lowercase.

Contoh:

[user@plantify.com](mailto:user@plantify.com)

---

### password

Type:

TEXT

Required:

YES

Description:

Password yang telah di-hash menggunakan SHA-256.

Password tidak boleh disimpan dalam bentuk plain text.

---

### role

Type:

TEXT

Required:

YES

Allowed Values:

* admin
* user

Validation:

CHECK(role IN ('admin','user'))

Default:

user

---

### status

Type:

INTEGER

Required:

YES

Allowed Values:

1 = aktif

0 = nonaktif

Validation:

CHECK(status IN (0,1))

Default:

1

---

### created_at

Type:

TEXT

Format:

YYYY-MM-DD HH:mm:ss

---

### updated_at

Type:

TEXT

Format:

YYYY-MM-DD HH:mm:ss

---

# TABLE: tanaman

## Description

Menyimpan seluruh informasi tanaman yang tersedia dalam aplikasi.

Data pada tabel ini dapat dikelola oleh admin.

Admin dapat:

* Tambah tanaman
* Edit tanaman
* Hapus tanaman

Admin tidak mengelola:

* Dataset CNN
* Training
* TensorFlow Lite
* Model AI

---

## Columns

### id

Type:

INTEGER

PRIMARY KEY AUTOINCREMENT

---

### nama_tanaman

Type:

TEXT

Required:

YES

Unique:

YES

Description:

Nama tanaman.

Contoh:

Sirih Hijau

---

### deskripsi

Type:

TEXT

Required:

YES

Description:

Penjelasan umum tanaman.

---

### manfaat

Type:

TEXT

Required:

YES

Description:

Manfaat tanaman.

---

### gambar

Type:

TEXT

Required:

YES

Description:

Path gambar tanaman yang digunakan aplikasi.

Kolom ini dapat menyimpan dua jenis path:

1. Asset Path
2. Local File Path

---

Asset Path

Digunakan untuk data tanaman bawaan aplikasi (seed data).

Contoh:

assets/images/plants/sirih_hijau.jpg

assets/images/plants/talas.jpg

assets/images/plants/nangka.jpg

---

Local File Path

Digunakan untuk gambar yang ditambahkan atau diperbarui oleh admin saat aplikasi berjalan.

Contoh:

/storage/emulated/0/Android/data/com.plantify.pnp/files/plants/sirih_hijau.jpg

atau

/data/user/0/com.plantify.pnp/files/plants/sirih_hijau.jpg

---

Storage Rules

Admin tidak dapat menyimpan gambar ke folder assets/.

Folder assets hanya digunakan untuk gambar bawaan aplikasi yang dikompilasi saat build.

---

Jika admin memilih gambar menggunakan image picker:

↓

gambar disalin ke storage aplikasi menggunakan path_provider

↓

path file disimpan ke database

↓

kolom gambar menyimpan local file path

---

Image Rendering Rules

Flutter harus mendukung kedua tipe path.

Jika path dimulai dengan:

assets/

↓

gunakan:

Image.asset()

---

Selain itu:

↓

gunakan:

Image.file()

---

Tujuan:

Memastikan gambar bawaan dan gambar yang ditambahkan admin dapat ditampilkan dengan benar menggunakan satu kolom database yang sama.

---

### label_model

Type:

TEXT

Required:

YES

Unique:

YES

Description:

Label yang digunakan oleh model TensorFlow Lite.

Nilai label harus identik dengan labels.txt hasil training.

---

Synchronization Rules

Nilai label_model wajib identik dengan labels.txt yang digunakan oleh model TensorFlow Lite.

Perbedaan huruf besar/kecil, spasi, tanda hubung, atau underscore tidak diperbolehkan.

---

Contoh Benar:

sirih_hijau

sirih_merah

talas

jambu_biji

---

Contoh Salah:

Sirih Hijau

SirihHijau

sirih-hijau

Jambu Biji

---

Label Mapping Examples

sirih_hijau

↓

Sirih Hijau

---

sirih_merah

↓

Sirih Merah

---

jambu_biji

↓

Jambu Biji

---

Tujuan:

Memastikan output model TensorFlow Lite dapat dipetakan ke tabel tanaman tanpa kesalahan lookup.

---

### created_at

Type:

TEXT

Format:

YYYY-MM-DD HH:mm:ss

---

### updated_at

Type:

TEXT

Format:

YYYY-MM-DD HH:mm:ss

---

# TABLE: riwayat_scan

## Description

Menyimpan hasil identifikasi tanaman yang dilakukan oleh pengguna.

Data tersimpan secara otomatis setelah proses identifikasi berhasil.

User dapat:

* Melihat riwayat
* Menghapus riwayat

---

## Columns

### id

Type:

INTEGER

PRIMARY KEY AUTOINCREMENT

---

### user_id

Type:

INTEGER

Required:

YES

Foreign Key:

users.id

Description:

Pengguna yang melakukan identifikasi.

---

### tanaman_id

Type:

INTEGER

Required:

NO

Foreign Key:

tanaman.id

ON DELETE SET NULL

Description:

Tanaman hasil identifikasi.

Jika tanaman dihapus oleh admin, riwayat scan tetap dipertahankan.

---

### nama_hasil

Type:

TEXT

Required:

YES

Description:

Snapshot nama tanaman saat scan dilakukan.

Contoh:

Sirih Hijau

---

### confidence

Type:

REAL

Required:

YES

Description:

Nilai confidence hasil prediksi.

Contoh:

87.45

---

### gambar_scan

Type:

TEXT

Required:

YES

Description:

Path gambar hasil scan.

---

### created_at

Type:

TEXT

Required:

YES

Format:

YYYY-MM-DD HH:mm:ss

Description:

Waktu identifikasi dilakukan.

---

# Relationships

## Users → Riwayat Scan

Relationship:

One To Many

1 user dapat memiliki banyak riwayat scan.

Contoh:

Luthfi

├── Scan 1

├── Scan 2

└── Scan 3

---

## Tanaman → Riwayat Scan

Relationship:

One To Many

1 tanaman dapat muncul pada banyak riwayat scan.

Contoh:

Sirih Hijau

├── Scan User A

├── Scan User B

└── Scan User C

---

# Authentication Rules

Login menggunakan:

* Email
* Password

Password wajib di-hash menggunakan SHA-256 sebelum disimpan ke SQLite.

---

Email wajib:

* trim()
* lowercase()

sebelum proses login maupun register.

---

Role menentukan dashboard yang akan ditampilkan.

Role:

admin

↓

Dashboard Admin

---

Role:

user

↓

Dashboard User

---

# Session Management

Session tidak disimpan pada SQLite.

Session disimpan menggunakan SharedPreferences.

Data yang disimpan:

* logged_in_user_id
* logged_in_role

---

# Scan Result Rules

Input:

Foto daun

Source:

* Kamera
* Galeri

---

Output:

* Nama Tanaman
* Confidence
* Deskripsi
* Manfaat

---

Threshold Default:

70%

---

Jika confidence >= 70%

Maka:

Simpan ke riwayat_scan.

---

Jika confidence < 70%

Maka:

Tampilkan:

"Tanaman Tidak Dikenali"

dan tidak disimpan ke riwayat.

---

# Supported Plant Classes

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

# Seed Data

## Default Admin

Nama:

Administrator

Email:

[admin@plantify.com](mailto:admin@plantify.com)

Password:

admin123

Role:

admin

Status:

aktif

---

## Default User

Nama:

User Demo

Email:

[user@plantify.com](mailto:user@plantify.com)

Password:

user123

Role:

user

Status:

aktif

---

# SQLite Rules

Agent wajib menggunakan:

sqflite

---

Saat database dibuka:

Foreign Key wajib diaktifkan.

PRAGMA foreign_keys = ON;

---

Database wajib mendukung:

* versioning
* onCreate
* onUpgrade

---

Database version dimulai dari:

Version 1

---

# TensorFlow Lite Mapping

Output model:

sirih_hijau

↓

Cari pada tabel tanaman:

label_model = sirih_hijau

↓

Ambil:

* nama_tanaman
* deskripsi
* manfaat
* gambar

↓

Tampilkan ke halaman Result Screen

---

# Agent Implementation Rules

Agent wajib:

* menggunakan SQLite
* menggunakan sqflite
* menggunakan foreign key
* menggunakan repository pattern
* menggunakan model class
* mengaktifkan foreign key
* mendukung migration database

Agent tidak boleh:

* menambahkan backend server
* menambahkan MySQL
* menambahkan Firebase
* menambahkan Supabase
* menambahkan API eksternal

tanpa instruksi tambahan.

Dokumen ini merupakan spesifikasi resmi database Plantify.PNP.
