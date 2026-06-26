import 'package:flutter/foundation.dart';
import 'package:plantify_pnp/core/database/database_helper.dart';
import 'package:plantify_pnp/core/services/session_service.dart';
import 'package:plantify_pnp/features/auth/models/user_model.dart';
import 'package:plantify_pnp/features/auth/repositories/user_repository.dart';

/// Provider pengelola state autentikasi dan sesi pengguna.
///
/// Mematuhi prinsip Clean Provider: murni mengelola business logic dan state,
/// buta terhadap lapisan presentasi ([Navigator], [BuildContext], [RouteConstants]).
/// Menggunakan Constructor Injection untuk meminimalkan coupling.
///
/// Referensi: FLUTTER_ARCHITECTURE.md — State Management, Auth Feature
class AuthProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  final SessionService _sessionService;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({
    UserRepository? userRepository,
    SessionService? sessionService,
  })  : _userRepository = userRepository ?? UserRepository(),
        _sessionService = sessionService ?? SessionService();

  // ─── Getters ───────────────────────────────────────────────────────────────
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // ─── Login Flow ────────────────────────────────────────────────────────────
  /// Masuk ke aplikasi menggunakan email dan password.
  ///
  /// Urutan ketat:
  /// 1. trim()
  /// 2. lowercase()
  /// 3. findByEmail()
  /// 4. hash password
  /// 5. compare hash
  /// 6. cek status user
  /// 7. save session
  /// 8. set currentUser
  /// 9. notifyListeners()
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cleanEmail = email.trim().toLowerCase();
      final user = await _userRepository.findByEmail(cleanEmail);

      if (user == null) {
        _errorMessage = 'Email atau password salah';
        return false;
      }

      final hashedInput = DatabaseHelper.hashPassword(password);
      if (user.password != hashedInput) {
        _errorMessage = 'Email atau password salah';
        return false;
      }

      if (!user.isActive) {
        _errorMessage = 'Akun Anda telah dinonaktifkan';
        return false;
      }

      await _sessionService.saveSession(user.id!, user.role);
      _currentUser = user;
      return true;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem saat login';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Register Flow ─────────────────────────────────────────────────────────
  /// Mendaftarkan pengguna baru ke database SQLite.
  ///
  /// Tidak membuat sesi maupun login otomatis setelah registrasi berhasil.
  Future<bool> register(String nama, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cleanEmail = email.trim().toLowerCase();
      final existingUser = await _userRepository.findByEmail(cleanEmail);

      if (existingUser != null) {
        _errorMessage = 'Email sudah terdaftar';
        return false;
      }

      final hashedPassword = DatabaseHelper.hashPassword(password);
      final now = DatabaseHelper.currentTimestamp();

      final newUser = UserModel(
        nama: nama.trim(),
        email: cleanEmail,
        password: hashedPassword,
        role: 'user',
        status: 1,
        createdAt: now,
        updatedAt: now,
      );

      await _userRepository.insert(newUser);
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mendaftarkan akun';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Session Check ─────────────────────────────────────────────────────────
  /// Memeriksa apakah terdapat sesi login aktif saat aplikasi dimulai.
  Future<bool> checkSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = await _sessionService.getLoggedInUserId();
      if (userId == null) return false;

      final user = await _userRepository.findById(userId);
      if (user == null || !user.isActive) {
        await _sessionService.clearSession();
        if (user != null && !user.isActive) {
          _errorMessage = 'Akun Anda telah dinonaktifkan';
        }
        return false;
      }

      _currentUser = user;
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memulihkan sesi';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Edit Name Flow ────────────────────────────────────────────────────────
  /// Memperbarui nama pengguna yang sedang aktif.
  Future<bool> updateName(String newName) async {
    if (_currentUser == null || _currentUser!.id == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final trimmedName = newName.trim();
      await _userRepository.updateNama(_currentUser!.id!, trimmedName);
      _currentUser = _currentUser!.copyWith(
        nama: trimmedName,
        updatedAt: DatabaseHelper.currentTimestamp(),
      );
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui profil';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Logout Flow ───────────────────────────────────────────────────────────
  /// Keluar dari aplikasi dengan menghapus sesi di SharedPreferences.
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _sessionService.clearSession();
      _currentUser = null;
    } catch (e) {
      _errorMessage = 'Gagal membersihkan sesi saat logout';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
