// ignore_for_file: prefer_initializing_formals

import 'package:flutter/foundation.dart';
import 'package:plantify_pnp/features/auth/models/user_model.dart';
import 'package:plantify_pnp/features/auth/repositories/user_repository.dart';

/// State management untuk modul Admin User Management.
///
/// Bertanggung jawab mengelola daftar user, pencarian lokal, dan aksi ubah status.
/// Menggunakan pola Mandatory Constructor Injection untuk menerima [UserRepository].
///
/// Referensi: FLUTTER_ARCHITECTURE.md — AdminProvider, Phase 7 Final Architecture
class AdminProvider extends ChangeNotifier {
  final UserRepository _userRepository;

  AdminProvider({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  // ─── Private State ────────────────────────────────────────────────────────
  List<UserModel> _users = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  // ─── Getters ──────────────────────────────────────────────────────────────
  List<UserModel> get users => _users;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Daftar user setelah difilter berdasarkan [searchQuery] (case-insensitive).
  List<UserModel> get displayUsers {
    if (_searchQuery.trim().isEmpty) return _users;
    final query = _searchQuery.trim().toLowerCase();
    return _users.where((user) {
      final nama = user.nama.toLowerCase();
      final email = user.email.toLowerCase();
      return nama.contains(query) || email.contains(query);
    }).toList();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  /// Memuat seluruh data pengguna dari SQLite.
  /// Memanggil isLoading = true di awal, dan mengisinya dengan hasil query.
  Future<void> loadAllUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _userRepository.getAll();
    } catch (e) {
      _errorMessage = 'Gagal memuat daftar pengguna: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Memperbarui query pencarian dan memicu rebuild UI.
  void searchUsers(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Mengubah status aktif/nonaktif pengguna.
  ///
  /// Menerapkan Self Lock Protection dan Admin Shield sebelum memanggil Repository.
  /// Mengembalikan true apabila update sukses di SQLite, false apabila ditolak atau gagal.
  Future<bool> toggleUserStatus(int targetUserId, int currentLoggedInAdminId) async {
    _errorMessage = null;

    // 1. Self Lock Protection
    if (targetUserId == currentLoggedInAdminId) {
      _errorMessage = 'Anda tidak dapat menonaktifkan akun Anda sendiri.';
      notifyListeners();
      return false;
    }

    // 2. Cari target user di list saat ini
    final targetIndex = _users.indexWhere((u) => u.id == targetUserId);
    if (targetIndex == -1) {
      _errorMessage = 'Pengguna tidak ditemukan di memori.';
      notifyListeners();
      return false;
    }

    final targetUser = _users[targetIndex];

    // 3. Admin Shield
    if (targetUser.isAdmin) {
      _errorMessage = 'Akun Administrator tidak dapat dinonaktifkan.';
      notifyListeners();
      return false;
    }

    // 4. Hitung status baru (1 -> 0, 0 -> 1)
    final newStatus = targetUser.isActive ? 0 : 1;

    try {
      final affectedRows = await _userRepository.updateStatus(targetUserId, newStatus);
      if (affectedRows > 0) {
        // Reload data dari SQLite sebagai Single Source of Truth
        await loadAllUsers();
        return true;
      } else {
        _errorMessage = 'Gagal memperbarui status pengguna di database.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem saat memperbarui status: $e';
      notifyListeners();
      return false;
    }
  }
}
