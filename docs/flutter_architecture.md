# FLUTTER_ARCHITECTURE.md

# Plantify.PNP Flutter Architecture

Version: 4.0

Status:
Final

Framework:
Flutter

Platform:
Android

Architecture Style:
Feature First Architecture

State Management:
Provider

Database:
SQLite (sqflite)

Session Storage:
SharedPreferences

AI Integration:
TensorFlow Lite (Future Phase)

---

# Purpose

Dokumen ini mendefinisikan arsitektur resmi aplikasi Flutter Plantify.PNP.

Dokumen ini menjadi acuan utama implementasi source code Flutter dan harus digunakan bersama:

* PROJECT_CONTEXT.md
* DATABASE_SPEC.md
* UI_GUIDELINE.md
* DEVELOPMENT_ROADMAP.md
* TRAINING_SPEC.md

---

# Current Development Focus

Fokus pengembangan saat ini adalah:

Flutter Application Development

---

Project saat ini BELUM melakukan:

* CNN Training
* Dataset Processing
* TensorFlow Training
* Kaggle Workflow
* Google Colab Workflow

---

Training dilakukan secara terpisah pada:

cnn/TRAINING_SPEC.md

---

TRAINING_SPEC.md hanya digunakan sebagai referensi integrasi AI.

Bukan panduan implementasi Flutter.

---

# Architecture Principles

Plantify.PNP merupakan proyek skripsi skala kecil hingga menengah.

Arsitektur harus:

* Sederhana
* Modular
* Mudah Dipelajari
* Mudah Dipelihara
* Mudah Dikembangkan

---

Hindari:

* Overengineering
* Layer berlebihan
* Dependency Injection kompleks
* Clean Architecture yang tidak diperlukan

---

# Technology Stack

Framework

* Flutter

---

State Management

* Provider

---

Database

* SQLite
* sqflite

---

Session

* SharedPreferences

---

Image Handling

* image_picker
* path_provider

---

AI Inference

* tflite_flutter (Phase 10)

---

# High Level Architecture

Screen

↓

Provider

↓

Repository

↓

SQLite

---

TensorFlow Lite Flow

Screen

↓

Provider

↓

Repository

↓

TFLite Service

↓

TensorFlow Lite Model

---

Screen tidak boleh mengakses SQLite secara langsung.

---

# Folder Structure

lib/

├── app/

├── core/

├── shared/

├── features/

└── main.dart

---

# App Layer

Folder:

app/

---

Structure

app/

├── app.dart

├── app_router.dart

└── app_theme.dart

---

Responsibilities

* MaterialApp
* Theme Configuration
* Route Configuration
* Global Application Setup

---

# Core Layer

Folder:

core/

---

Structure

core/

├── constants/

├── database/

├── services/

├── theme/

├── routes/

├── utils/

└── exceptions/

---

# Database Layer

Folder:

core/database/

---

Files

database_helper.dart

database_initializer.dart

---

Responsibilities

* Open Database
* Create Tables
* Upgrade Database
* Migration
* Foreign Key Activation

---

Rules

PRAGMA foreign_keys = ON

---

Database Name

plantify.db

---

Source

DATABASE_SPEC.md

---

# Services Layer

Folder:

core/services/

---

Files

session_service.dart

permission_service.dart

image_picker_service.dart

storage_service.dart

tflite_service.dart

---

# Session Service

Responsibilities

* Save Session
* Read Session
* Remove Session

---

Storage

SharedPreferences

---

Keys

* logged_in_user_id
* logged_in_role

---

# Session Validation Rules

Saat aplikasi dibuka:

Splash Screen

↓

Check SharedPreferences

↓

Ambil user terbaru dari SQLite

↓

Periksa status user

---

Jika status = 1

↓

Masuk ke Dashboard

---

Jika status = 0

↓

Hapus Session

↓

Redirect ke Login

↓

Tampilkan pesan:

"Akun Anda telah dinonaktifkan."

---

# Permission Service

Responsibilities

* Camera Permission
* Gallery Permission

---

# Image Picker Service

Responsibilities

* Camera Capture
* Gallery Selection

---

Tidak mengandung business logic.

---

# Storage Service

Responsibilities

* Save Local Image
* Read Local Image
* Delete Local Image

---

Admin upload image disimpan ke local storage.

Bukan ke assets/.

---

# TFLite Service

Digunakan pada:

Phase 10

TensorFlow Lite Integration

---

Responsibilities

* Load Model
* Load Labels
* Run Inference
* Return Prediction
* Return Confidence
* Apply Threshold Logic
* Validate Label Consistency

---

Input

224 x 224 RGB Image

---

Output

Prediction Label

Confidence Score

---

# Label Consistency Validation

Saat model pertama kali dimuat:

↓

Load labels.txt

↓

Bandingkan dengan seluruh nilai label_model pada tabel tanaman

↓

Laporkan jika ada label yang tidak cocok

---

Tujuan:

Mencegah mismatch antara:

labels.txt

dan

tanaman.label_model

---

# CNN Reference

Folder:

cnn/

bukan bagian implementasi Flutter.

---

Training dilakukan pada:

* Google Colab
* Kaggle

---

Agent tidak boleh:

* membuat notebook training
* membuat script training
* menjalankan training model
* memodifikasi dataset
* memodifikasi folder cnn/

kecuali diminta secara eksplisit.

---

Output yang akan digunakan Flutter:

* model.tflite
* labels.txt

---

# Shared Layer

Folder:

shared/

---

Structure

shared/

├── widgets/

├── components/

└── models/

---

# Shared Widgets

Contoh

* AppButton
* AppTextField
* AppCard
* AppDialog
* LoadingWidget
* EmptyStateWidget
* ErrorStateWidget

---

# PlantImageWidget

Widget khusus untuk menampilkan gambar tanaman.

---

Responsibilities

Mendukung:

* Asset Path
* Local File Path

---

Rules

Jika path diawali:

assets/

↓

gunakan:

Image.asset()

---

Selain itu

↓

gunakan:

Image.file()

---

Seluruh halaman wajib menggunakan PlantImageWidget.

Jangan menduplikasi logika gambar pada setiap screen.

---

# Features Layer

Folder:

features/

---

Structure

features/

├── auth/

├── dashboard/

├── scan/

├── plant/

├── history/

├── profile/

└── admin/

---

# Standard Feature Structure

feature/

├── models/

├── repositories/

├── providers/

├── screens/

└── widgets/

---

# Authentication Feature

Responsibilities

* Login
* Register
* Logout
* Session Validation
* Role Validation

---

# Dashboard Feature

Responsibilities

* Welcome Section
* Search Plant
* Quick Scan
* Recommendation
* Recent Scan

---

Recommendation menggunakan data tanaman acak.

Bukan AI Recommendation.

---

# Scan Feature

Responsibilities

* Camera
* Gallery
* Scan Flow
* Result Flow

---

Current Phase

Dummy Prediction

---

Future Phase

TensorFlow Lite Prediction

---

Flow

Image

↓

Prediction

↓

Result Screen

↓

Save History

↓

riwayat_scan

---

# Plant Feature

Responsibilities

* Plant Detail
* Plant Description
* Plant Benefits

---

# Shared Plant Domain

PlantModel

PlantRepository

merupakan domain utama tanaman.

---

Admin Plant Management wajib menggunakan:

* PlantModel
* PlantRepository

yang sama.

---

Tidak diperbolehkan membuat:

* AdminPlantModel
* AdminPlantRepository

tanpa kebutuhan khusus.

---

# History Feature

Responsibilities

* View History
* Delete History

---

# Profile Feature

Responsibilities

* View Profile
* Edit Name
* Logout

---

# Admin Feature

Admin merupakan portal terpisah.

Admin tidak menggunakan Bottom Navigation.

---

Sub Modules

* Admin Dashboard
* Plant Management
* User Management

---

Responsibilities

* CRUD Tanaman
* Activate User
* Deactivate User

---

# State Management

Gunakan:

Provider

---

Recommended Providers

* AuthProvider
* PlantProvider
* HistoryProvider
* ScanProvider
* AdminProvider

---

setState hanya digunakan untuk local UI state.

---

# User Navigation

Splash

↓

Check Session

↓

Role Check

↓

User Dashboard

---

Bottom Navigation

1 Home

2 Scan

3 History

4 Profile

---

# Admin Navigation

Splash

↓

Check Session

↓

Role Check

↓

Admin Dashboard

---

Admin Dashboard

↓

Manage Plants

↓

Manage Users

---

Admin tidak menggunakan Bottom Navigation.

---

# Error Handling

Setiap feature wajib memiliki:

* Loading State
* Success State
* Error State
* Empty State

---

# Material 3

Wajib menggunakan:

useMaterial3: true

---

# Agent Rules

Agent wajib:

* menggunakan Provider
* menggunakan SQLite
* menggunakan SharedPreferences
* menggunakan Repository Pattern
* menggunakan Feature First Architecture
* mengikuti DATABASE_SPEC.md
* mengikuti UI_GUIDELINE.md
* mengikuti DEVELOPMENT_ROADMAP.md

---

Agent tidak boleh:

* menggunakan Firebase
* menggunakan Supabase
* menggunakan Backend Server
* menggunakan REST API
* menggunakan Riverpod
* menggunakan GetX
* menggunakan Bloc

tanpa instruksi tambahan.

---

Dokumen ini merupakan spesifikasi resmi arsitektur Flutter Plantify.PNP.
