# UI_GUIDELINE.md

# Plantify.PNP User Interface Guideline

Version: 2.0

Reference Source:

Folder:

ui/

Semua desain yang terdapat pada folder ui/ merupakan referensi utama visual aplikasi.

Agent wajib membaca seluruh screenshot UI sebelum melakukan implementasi Flutter.

---

# Purpose

Dokumen ini mendefinisikan standar UI dan UX Plantify.PNP.

Tujuan:

* menjaga konsistensi desain
* menjaga konsistensi flow
* menghindari perubahan struktur UI oleh Agent
* memastikan implementasi Flutter sesuai rancangan

---

# UI Reference Interpretation Rules

Folder:

ui/

berisi screenshot referensi visual yang digunakan sebagai panduan implementasi Flutter.

Screenshot UI digunakan untuk memahami:

* struktur halaman
* flow pengguna
* hierarki informasi
* penempatan komponen utama
* arah visual desain aplikasi

---

Screenshot UI bukan desain final yang wajib direplikasi secara pixel-perfect.

Agent tidak diwajibkan membuat tampilan 100% identik dengan screenshot.

---

Agent diperbolehkan melakukan penyesuaian jika diperlukan untuk:

* Material 3 Implementation
* Responsive Layout
* Accessibility
* Usability
* Konsistensi antar halaman
* Konsistensi dengan dokumentasi proyek
* Keterbatasan fitur yang tersedia pada scope proyek

---

Agent wajib mempertahankan:

* Tujuan halaman
* Struktur informasi utama
* Navigasi utama
* Flow User
* Flow Admin
* Hierarki fitur

---

Agent tidak boleh mempertahankan elemen visual yang:

* Tidak memiliki fungsi pada scope proyek
* Bertentangan dengan dokumentasi lain
* Tidak sesuai dengan use case
* Tidak sesuai dengan database
* Tidak sesuai dengan roadmap implementasi

---

Contoh:

Jika screenshot menampilkan komponen yang tidak terdapat pada use case atau dokumentasi resmi proyek, maka komponen tersebut tidak wajib diimplementasikan.

Jika screenshot menampilkan layout yang kurang sesuai dengan Material 3 atau responsive design, Agent diperbolehkan menyesuaikan layout tanpa mengubah tujuan halaman.

---

Document Priority Order

Jika terdapat perbedaan informasi antar dokumen:

Prioritas tertinggi:

1. PROJECT_CONTEXT.md
2. DATABASE_SPEC.md
3. FLUTTER_ARCHITECTURE.md
4. DEVELOPMENT_ROADMAP.md
5. MASTER_PROMPT.md
6. UI_GUIDELINE.md
7. Screenshot pada folder ui/

Screenshot UI berfungsi sebagai referensi visual, bukan sumber kebenaran utama aplikasi.

---

Tujuan aturan ini adalah memastikan aplikasi yang dibangun tetap sesuai kebutuhan proyek, meskipun tampilan akhir tidak identik 100% dengan screenshot referensi.


# Design Philosophy

Plantify.PNP merupakan aplikasi identifikasi tanaman.

Karakter desain yang diinginkan:

* Modern
* Clean
* Simple
* Natural
* Educational
* Friendly
* Mobile First

UI harus mudah digunakan oleh pengguna umum tanpa memerlukan pelatihan khusus.

---

# Design Rules

Agent wajib mempertahankan:

* Struktur halaman
* Navigasi utama
* Informasi utama
* Hierarki fitur
* Flow User
* Flow Admin

---

Agent diperbolehkan memperbaiki:

* Typography
* Material 3 Implementation
* Spacing
* Padding
* Margin
* Alignment
* Responsive Layout
* Accessibility

---

Agent tidak boleh:

* Menambah fitur baru
* Menghapus fitur yang ada pada Use Case
* Mengubah flow aplikasi
* Mengubah struktur Bottom Navigation
* Mendesain ulang aplikasi dari nol

---

# Color System

Primary Color

Nature Green

Suggested:

#2E7D32

---

Secondary Color

Light Green

Suggested:

#81C784

---

Background

#FFFFFF

---

Surface

#F8F9FA

---

Success

#2E7D32

---

Warning

#FFA000

---

Error

#D32F2F

---

# Typography

Preferred Font

Poppins

---

Fallback

Roboto

---

Heading Large

24-28

Bold

---

Heading Medium

20-22

Semi Bold

---

Body Text

14-16

Regular

---

Caption

12-13

Regular

---

# Border Radius

Small

8

---

Medium

12

---

Large

16

---

Card

20

---

# Elevation

Gunakan Material 3 Card.

---

Hindari shadow berlebihan.

---

# Icons

Gunakan:

Material Symbols Rounded

---

Jangan mencampur icon pack lain.

---

# Splash Screen

Reference:

ui/splash.png

---

Components

* Logo Placeholder
* Plantify.PNP
* Tagline

---

Duration

2-3 detik

---

Flow

Splash

↓

Check Session

↓

Role Check

↓

Dashboard

atau

↓

Login

---

# Login Screen

Reference:

ui/login.png

---

Components

Fields

* Email
* Password

---

Button

* Login

---

Link

* Register

---

Behavior

Admin Account

↓

Dashboard Admin

---

User Account

↓

Dashboard User

---

# Register Screen

Reference:

ui/register.png

---

Components

Fields

* Nama
* Email
* Password
* Confirm Password

---

Button

* Register

---

Link

* Login

---

# User Dashboard

Reference:

ui/dashboard_user.png

---

Main Components

1. Welcome Section
2. Search Bar
3. Quick Scan Card
4. Plant Recommendation
5. Recent Scan

---

# Search Bar

Function:

Mencari tanaman berdasarkan nama tanaman.

---

Source Data:

Tabel tanaman.

---

Result:

Menampilkan daftar tanaman yang sesuai.

---

Tidak menggunakan AI Search.

---

# Quick Scan Card

Function:

Akses cepat menuju halaman Scan.

---

Action

Tap

↓

Scan Screen

---

# Plant Recommendation

Function:

Menampilkan beberapa tanaman secara acak.

---

Source:

Tabel tanaman.

---

Bukan:

* AI Recommendation
* Machine Learning Recommendation

---

Tujuan:

Memberikan eksplorasi tanaman kepada pengguna.

---

# Recent Scan

Function:

Menampilkan hasil scan terbaru pengguna.

---

Maximum:

5 item terakhir.

---

Action

Tap

↓

Result Detail

---

# User Bottom Navigation

Bottom Navigation wajib digunakan.

---

Items

1 Home
2 Scan
3 History
4 Profile

---

Agent tidak boleh mengubah jumlah menu.

---

Agent tidak boleh menambah menu baru.

---

# Scan Screen

Reference:

ui/scan.png

---

Components

Button:

* Camera
* Gallery

---

Function

Ambil gambar daun.

---

Source

* Kamera
* Galeri

---

Flow

Pilih gambar

↓

Identifikasi

↓

Result Screen

---

# Result Screen

Reference:

ui/result.png

---

Display

* Gambar hasil scan
* Nama tanaman
* Confidence score
* Deskripsi
* Manfaat

---

Button

* Scan Again
* View Detail

---

# Confidence Display

Format:

87.35%

---

# Unknown Result State

Jika confidence < threshold

Tampilkan:

Tanaman Tidak Dikenali

---

Tampilkan:

* ilustrasi sederhana
* pesan informatif
* tombol scan ulang

---

# Plant Detail Screen

Reference:

ui/detail_tanaman.png

---

Display

* Gambar tanaman
* Nama tanaman
* Deskripsi
* Manfaat

---

Data berasal dari:

Tabel tanaman

---

# History Screen

Reference:

ui/history.png

---

Display

List Riwayat

---

Item Information

* Nama tanaman
* Tanggal scan
* Confidence score

---

Actions

* View Detail
* Delete History

---

Riwayat tersimpan otomatis setelah identifikasi berhasil.

---

# Empty History State

Jika belum ada riwayat

Tampilkan:

* ilustrasi
* pesan informatif
* tombol menuju Scan

---

# Profile Screen

Reference:

ui/profile.png

---

Display

* Nama
* Email
* Role

---

Actions

* Edit Profile
* Logout

---

# Edit Profile Scope

Fase awal:

User hanya dapat mengubah:

* Nama

---

Belum dapat mengubah:

* Email
* Password

---

# Admin Dashboard

Reference:

ui/dashboard_admin.png

---

Summary Cards

* Total Plants
* Total Users
* Total Scans

---

Menu

* Manage Plants
* Manage Users

---

# Manage Plants Screen

Reference:

ui/kelola_tanaman.png

---

Display

Daftar tanaman

---

Actions

* Add
* Edit
* Delete

---

# Add Plant Screen

Reference:

ui/tambah_tanaman.png

---

Fields

* Nama Tanaman
* Deskripsi
* Manfaat
* Gambar
* Label Model

---

# Edit Plant Screen

Memiliki struktur yang sama dengan Add Plant.

---

# Manage Users Screen

Reference:

ui/kelola_user.png

---

Display

Daftar user

---

Actions

* Activate User
* Deactivate User

---

Admin tidak dapat menghapus user.

---

# Loading State

Gunakan:

CircularProgressIndicator

atau

Skeleton Loader

---

# Error State

Gunakan:

Snackbar

Dialog

atau

Error Card

---

Pesan harus mudah dipahami pengguna.

---

# Empty State

Setiap halaman yang menampilkan data wajib memiliki Empty State.

---

Contoh:

* Belum ada tanaman
* Belum ada riwayat
* Tidak ada hasil pencarian

---

# Responsive Design Rules

Support:

* Small Android
* Medium Android
* Large Android

---

Hindari:

Fixed Width

---

Gunakan:

Expanded

Flexible

LayoutBuilder

---

# Material 3

Wajib menggunakan:

useMaterial3: true

---

# Accessibility Rules

Minimum Touch Target:

48dp

---

Text harus tetap terbaca pada berbagai ukuran layar.

---

# Agent Instructions

Agent wajib:

1. Membaca seluruh screenshot pada folder ui/.
2. Mengikuti struktur UI yang tersedia.
3. Mengikuti flow User dan Admin.
4. Menggunakan Material 3.
5. Mempertahankan konsep desain utama.
6. Memperbaiki inkonsistensi desain jika ditemukan.

---

Agent tidak boleh:

* Mendesain ulang aplikasi.
* Menambah fitur baru.
* Mengubah flow aplikasi.
* Mengubah struktur navigasi utama.

Dokumen ini merupakan spesifikasi resmi UI Plantify.PNP.
