import 'package:shared_preferences/shared_preferences.dart';

/// Service persisten untuk menyimpan dan membaca sesi pengguna.
///
/// Bertanggung jawab eksklusif terhadap [SharedPreferences].
/// Sesuai prinsip arsitektur, service ini tidak mengandung business logic
/// atau pemanggilan database SQLite.
///
/// Keys:
/// - logged_in_user_id (int)
/// - logged_in_role (String)
///
/// Referensi: FLUTTER_ARCHITECTURE.md — Services Layer
class SessionService {
  static const String _keyUserId = 'logged_in_user_id';
  static const String _keyRole = 'logged_in_role';

  /// Menyimpan sesi login aktif.
  Future<void> saveSession(int userId, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyRole, role);
  }

  /// Mengambil ID user yang sedang login. Mengembalikan null jika sesi kosong.
  Future<int?> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  /// Mengambil role user yang sedang login ('admin' atau 'user').
  Future<String?> getLoggedInRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  /// Menghapus seluruh data sesi (digunakan saat logout atau sesi invalid).
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyRole);
  }
}
