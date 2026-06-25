# TRAINING_SPEC.md

# Plantify.PNP CNN Training Specification

Version: 2.0

Framework:
TensorFlow

Training Environment:
Google Colab / Kaggle

Target Deployment:
TensorFlow Lite (Android)

Model Architecture:
MobileNetV2

---

# Purpose

Dokumen ini merupakan spesifikasi resmi proses training model CNN pada proyek Plantify.PNP.

Dokumen digunakan sebagai acuan untuk:

* Dataset Collection
* Dataset Preparation
* Data Preprocessing
* Data Augmentation
* Model Training
* Model Evaluation
* TensorFlow Lite Export
* Flutter Integration

Dokumen ini menjadi sumber kebenaran utama untuk seluruh proses AI pada Plantify.PNP.

---

# Project Goal

Membangun model CNN yang mampu mengidentifikasi tanaman berdasarkan citra daun.

Model akan diintegrasikan ke aplikasi Flutter menggunakan TensorFlow Lite.

---

# Supported Plant Classes

Jumlah Kelas:

11

Daftar Tanaman:

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

Dataset Source:

100% foto asli yang dikumpulkan sendiri.

Tidak menggunakan dataset internet sebagai sumber utama.

---

Target Jumlah Foto:

200 foto per kelas

---

Total Target Dataset:

2200 foto

---

Object Focus

Objek utama:

Daun tanaman

---

Objek yang tidak menjadi fokus:

* bunga
* buah
* batang
* akar

---

# Dataset Folder Structure

dataset/

bleeding_heartvine/

markisa/

jambu_biji/

sirih_hijau/

talas/

sirih_merah/

nangka/

miana/

rombusa/

pucuk_merah/

heliconia/

---

# Image Collection Rules

Foto harus:

* fokus pada daun
* tidak blur
* tidak terlalu gelap
* tidak terlalu terang
* objek daun terlihat jelas

---

Variasi yang dianjurkan:

Jarak:

* dekat
* sedang
* jauh

Sudut:

* depan
* kiri
* kanan
* atas

Pencahayaan:

* pagi
* siang
* sore

---

Background

Background tidak wajib polos.

Background alami diperbolehkan.

Contoh:

* tanah
* rumput
* dedaunan lain
* lingkungan kampus

---

Tangan Pengambil Foto

Sebagian jari diperbolehkan terlihat.

Namun daun harus tetap menjadi objek dominan.

---

# Dataset Limitations

Karena keterbatasan lingkungan penelitian, setiap kelas tanaman diperkirakan hanya berasal dari 1–2 individu tanaman.

Contoh:

* 1–2 pohon nangka
* 1–2 tanaman sirih merah
* 1–2 rumpun talas

---

Konsekuensi:

Variasi individu tanaman masih terbatas.

Model mungkin lebih sulit melakukan generalisasi terhadap tanaman dari lokasi yang sangat berbeda.

---

Rekomendasi penelitian lanjutan:

Menambah jumlah individu tanaman pada setiap kelas.

---

# Dataset Split

Metode:

Stratified Split

Random Seed:

42

---

Proporsi:

Training:

70%

Validation:

15%

Testing:

15%

---

Contoh:

2200 gambar

Training:
1540

Validation:
330

Testing:
330

---

# Data Leakage Rules

Validation dan Testing tidak boleh digunakan selama proses training.

Setiap gambar hanya boleh berada pada satu subset.

Tidak boleh ada file yang muncul di lebih dari satu subset.

---

# Image Preprocessing

Target Input Size:

224 x 224

---

Color Mode:

RGB

---

Resize Strategy

Center Crop

↓

Resize

224 x 224

---

Jangan menggunakan stretch resize.

Karena dapat mengubah bentuk daun.

---

# MobileNetV2 Preprocessing

Gunakan preprocessing resmi MobileNetV2.

Function:

tf.keras.applications.mobilenet_v2.preprocess_input()

---

Output Range:

-1 sampai 1

---

Jangan menggunakan normalisasi manual yang berbeda.

Hal ini untuk menjaga konsistensi dengan MobileNetV2 pretrained ImageNet.

---

# Data Augmentation

Tujuan:

Mengurangi overfitting.

---

Augmentasi yang diperbolehkan:

Horizontal Flip

Rotation ringan

Zoom ringan

Brightness

Contrast

Translation ringan

---

Augmentasi yang tidak disarankan:

Extreme Rotation

Heavy Distortion

Perspective Warp berlebihan

---

Karena dapat merusak karakteristik bentuk daun.

---

# Model Architecture

Base Model:

MobileNetV2

---

Pretrained Weights:

ImageNet

---

Transfer Learning:

Enabled

---

# Training Phase 1

Tujuan:

Melatih classification head.

---

Base Model:

Frozen

---

Learning Rate:

0.001

---

Optimizer:

Adam

---

Loss Function:

Categorical Crossentropy

---

Metrics:

Accuracy

Precision

Recall

F1 Score

---

# Training Phase 2

Tujuan:

Fine Tuning

---

Unfreeze:

Sebagian layer akhir MobileNetV2

---

Learning Rate:

0.0001

---

Optimizer:

Adam

---

Catatan:

Learning rate diturunkan untuk menghindari kerusakan pretrained weights.

---

# Output Layer

Jumlah Neuron:

11

---

Activation:

Softmax

---

# Batch Size

Recommended:

16

atau

32

Disesuaikan dengan resource Colab atau Kaggle.

---

# Epoch

Initial Training:

20–30 Epoch

---

Early Stopping:

Enabled

---

Patience:

5

---

Model Checkpoint:

Enabled

---

# Overfitting Prevention

Gunakan:

* Data Augmentation
* Early Stopping
* Validation Monitoring

---

Indikasi Overfitting:

Training Accuracy tinggi

Validation Accuracy rendah

---

Jika terjadi:

Kurangi epoch atau tingkatkan augmentasi.

---

# Evaluation

Evaluasi wajib menggunakan:

1. Accuracy
2. Precision
3. Recall
4. F1 Score
5. Confusion Matrix

---

Target Accuracy

Minimum:

85%

Target:

85–90%

---

# Unknown Object Handling

Aplikasi menggunakan threshold confidence.

---

Threshold Awal:

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

Threshold 70% merupakan nilai awal.

Nilai final dapat disesuaikan berdasarkan hasil evaluasi model.

---

# TensorFlow Lite Export

Setelah training selesai:

Model

↓

SavedModel

↓

TensorFlow Lite

---

Output:

model.tflite

labels.txt

---

# Labels Rules

labels.txt harus dibuat otomatis dari struktur dataset.

Tidak ditulis manual.

---

Contoh:

bleeding_heartvine

markisa

jambu_biji

sirih_hijau

talas

sirih_merah

nangka

miana

rombusa

pucuk_merah

heliconia

---

Urutan labels.txt harus identik dengan urutan output model.

---

# Quantization Strategy

Jenis quantization belum ditentukan secara final.

Pemilihan dilakukan setelah model selesai dilatih.

---

Kandidat:

* Float16 Quantization
* Dynamic Range Quantization
* INT8 Quantization

---

Pemilihan akhir berdasarkan:

* ukuran model
* akurasi
* kecepatan inferensi pada perangkat Android target

---

# TensorFlow Lite Integration

Flutter akan menggunakan:

model.tflite

dan

labels.txt

---

Flow:

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

# Known Limitations

Model hanya mengenali:

11 kelas tanaman yang tersedia dalam dataset.

---

Model tidak dirancang untuk:

* seluruh spesies tanaman
* identifikasi penyakit tanaman
* klasifikasi bunga
* klasifikasi buah

---

Dataset belum sepenuhnya mencakup:

* daun basah setelah hujan
* daun rusak
* kondisi pencahayaan ekstrem
* variasi individu tanaman yang sangat banyak

---

# Agent Instructions

Agent wajib:

* menggunakan MobileNetV2
* menggunakan transfer learning
* menggunakan preprocessing resmi MobileNetV2
* membuat labels.txt otomatis
* melakukan evaluasi model
* mengekspor TensorFlow Lite
* menjaga sinkronisasi labels.txt dengan SQLite

Agent tidak boleh:

* mengganti arsitektur model tanpa alasan kuat
* mengubah jumlah kelas tanpa persetujuan
* menggunakan dataset internet sebagai sumber utama

Dokumen ini merupakan spesifikasi resmi proses training Plantify.PNP.
