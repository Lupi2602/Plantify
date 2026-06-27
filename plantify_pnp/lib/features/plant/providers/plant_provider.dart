// ignore_for_file: prefer_initializing_formals
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:plantify_pnp/features/plant/models/plant_model.dart';
import 'package:plantify_pnp/features/plant/repositories/plant_repository.dart';
import 'package:plantify_pnp/features/plant/services/plant_storage_service.dart';

/// State management utama untuk domain Tanaman (Plant).
///
/// Mengelola alur data antara UI eksternal dan [PlantRepository] secara reaktif.
/// Bebas dari dependensi [BuildContext] maupun navigasi langsung.
///
/// Mematuhi standar 4 UI States:
/// - Loading state : [isLoading] == true
/// - Error state   : [errorMessage] != null
/// - Empty state   : [isLoading] == false && [displayPlants].isEmpty
/// - Success state : [isLoading] == false && [displayPlants].isNotEmpty
///
/// Referensi: FLUTTER_ARCHITECTURE.md — State Management & Core Providers
class PlantProvider extends ChangeNotifier {
  final PlantRepository _repository;
  final IPlantStorageService _storageService;

  PlantProvider({
    required PlantRepository repository,
    required IPlantStorageService storageService,
  })  : _repository = repository,
        _storageService = storageService;

  // ─── Raw States ────────────────────────────────────────────────────────────
  List<PlantModel> _plants = [];
  List<PlantModel> _searchResults = [];
  List<PlantModel> _recommendations = [];

  bool _isLoading = false;
  bool _isInitialized = false;
  String _searchQuery = '';
  String? _errorMessage;

  // ─── Getters & Derived States ──────────────────────────────────────────────
  List<PlantModel> get plants => _plants;

  /// Derived state: menyederhanakan UI agar tidak perlu percabangan if-else.
  /// Jika sedang mencari ([_searchQuery] tidak kosong), mengembalikan [_searchResults].
  /// Jika tidak mencari, mengembalikan daftar utama [_plants].
  List<PlantModel> get displayPlants =>
      _searchQuery.isEmpty ? _plants : _searchResults;

  List<PlantModel> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;

  // ─── Official Entry Point (Revisi 3 & Hardening) ───────────────────────────

  /// Method inisialisasi resmi provider dengan mekanisme safety guard.
  /// Dipanggil secara berurutan (sequential) untuk mencegah balapan state [isLoading].
  Future<void> initialize() async {
    _errorMessage = null;
    if (_isInitialized) return;

    await loadAllPlants();
    await loadRecommendations();
    _isInitialized = true;
  }

  // ─── Actions: Read ─────────────────────────────────────────────────────────

  /// Mengambil seluruh tanaman dari database.
  Future<void> loadAllPlants() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      _plants = await _repository.getAll();
    } catch (e) {
      _errorMessage = 'Gagal memuat daftar tanaman: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mengambil rekomendasi tanaman berdasarkan kebijakan cache (Revisi 5).
  /// Rekomendasi hanya diacak ulang jika cache kosong atau [forceRefresh] == true.
  Future<void> loadRecommendations({bool forceRefresh = false}) async {
    _errorMessage = null;
    if (_recommendations.isNotEmpty && !forceRefresh) {
      return; // Gunakan in-memory cache
    }

    try {
      _recommendations = await _repository.getRecommendations();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat rekomendasi: $e';
      notifyListeners();
    }
  }

  /// Mencari tanaman berdasarkan string query.
  Future<void> searchPlants(String query) async {
    _errorMessage = null;
    _searchQuery = query.trim();
    if (_searchQuery.isEmpty) {
      clearSearch();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _repository.search(_searchQuery);
    } catch (e) {
      _errorMessage = 'Gagal melakukan pencarian: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset state pencarian ke kondisi awal (Revisi 4).
  void clearSearch() {
    _searchQuery = '';
    _searchResults.clear();
    _errorMessage = null;
    notifyListeners();
  }

  // ─── Actions: Write (CRUD dengan Refresh Strategy Seragam) ─────────────────

  /// Menambahkan tanaman baru ke database beserta orchestration gambar lokal.
  /// Strategi refresh: loadAllPlants() -> loadRecommendations(forceRefresh: true)
  Future<bool> addPlant(PlantModel plant, {File? imageFile}) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    String? savedPath;
    PlantModel plantToSave = plant;

    if (imageFile != null) {
      try {
        savedPath = await _storageService.saveImage(imageFile);
        plantToSave = plant.copyWith(gambar: savedPath);
      } catch (e) {
        _errorMessage = 'Gagal menyimpan gambar ke penyimpanan lokal: $e';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }

    try {
      final affectedRows = await _repository.insert(plantToSave);
      if (affectedRows == 0) {
        if (savedPath != null) {
          await _storageService.deleteImage(savedPath); // Rollback!
        }
        _errorMessage = 'Gagal menambahkan tanaman. Silakan periksa kembali input Anda.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      await _executeOfficialRefreshStrategy();
      return true;
    } on DatabaseException catch (e) {
      if (savedPath != null) {
        await _storageService.deleteImage(savedPath); // Rollback!
      }
      if (e.toString().toLowerCase().contains('unique')) {
        _errorMessage = 'Nama tanaman atau label model tersebut sudah terdaftar.';
      } else {
        _errorMessage = 'Terjadi kesalahan sistem database.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      if (savedPath != null) {
        await _storageService.deleteImage(savedPath); // Rollback!
      }
      _errorMessage = 'Gagal menambahkan tanaman: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Memperbarui data tanaman di database beserta orchestration gambar lokal.
  /// Strategi refresh: loadAllPlants() -> loadRecommendations(forceRefresh: true)
  Future<bool> updatePlant(PlantModel plant, {File? newImageFile}) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    String oldImagePath = plant.gambar;
    String? newlyCopiedPath;
    PlantModel plantToUpdate = plant;

    if (newImageFile != null) {
      try {
        newlyCopiedPath = await _storageService.saveImage(newImageFile);
        plantToUpdate = plant.copyWith(gambar: newlyCopiedPath);
      } catch (e) {
        _errorMessage = 'Gagal menyalin gambar baru ke penyimpanan lokal: $e';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }

    try {
      final affectedRows = await _repository.update(plantToUpdate);
      if (affectedRows == 0) {
        if (newlyCopiedPath != null) {
          await _storageService.deleteImage(newlyCopiedPath); // Rollback!
        }
        _errorMessage = 'Data tanaman tidak ditemukan atau sudah berubah.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      if (newlyCopiedPath != null && oldImagePath != newlyCopiedPath) {
        final cleanupSuccess = await _storageService.deleteImage(oldImagePath);
        if (!cleanupSuccess) {
          debugPrint('Warning: Gagal membersihkan file gambar lama: $oldImagePath');
        }
      }
      await _executeOfficialRefreshStrategy();
      return true;
    } on DatabaseException catch (e) {
      if (newlyCopiedPath != null) {
        await _storageService.deleteImage(newlyCopiedPath); // Rollback!
      }
      if (e.toString().toLowerCase().contains('unique')) {
        _errorMessage = 'Nama tanaman atau label model tersebut sudah terdaftar.';
      } else {
        _errorMessage = 'Terjadi kesalahan sistem database.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      if (newlyCopiedPath != null) {
        await _storageService.deleteImage(newlyCopiedPath); // Rollback!
      }
      _errorMessage = 'Gagal memperbarui tanaman: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Menghapus tanaman berdasarkan id.
  /// Strategi refresh: loadAllPlants() -> loadRecommendations(forceRefresh: true)
  Future<bool> deletePlant(int id) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final targetPlant = await _repository.getById(id);
      final affectedRows = await _repository.delete(id);
      if (affectedRows == 0) {
        _errorMessage = 'Data tanaman tidak ditemukan atau sudah berubah.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      if (targetPlant != null) {
        final cleanupSuccess = await _storageService.deleteImage(targetPlant.gambar);
        if (!cleanupSuccess) {
          debugPrint('Warning: Gagal membersihkan file gambar saat menghapus tanaman: ${targetPlant.gambar}');
        }
      }
      await _executeOfficialRefreshStrategy();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghapus tanaman: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Helper internal pelaksana strategi refresh resmi (Revisi 3 Rencana Final).
  Future<void> _executeOfficialRefreshStrategy() async {
    _plants = await _repository.getAll();
    _recommendations = await _repository.getRecommendations();
    // Jika sedang mencari, segarkan juga hasil cari
    if (_searchQuery.isNotEmpty) {
      _searchResults = await _repository.search(_searchQuery);
    }
    _isLoading = false;
    notifyListeners();
  }
}
