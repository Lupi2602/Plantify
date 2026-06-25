/// Named route constants untuk seluruh halaman aplikasi Plantify.PNP.
///
/// Digunakan oleh AppRouter dan seluruh Navigator.pushNamed() calls.
/// Referensi: FLUTTER_ARCHITECTURE.md, PROJECT_CONTEXT.md
class RouteConstants {
  RouteConstants._();

  // ─── Auth Routes ──────────────────────────────────────────────────────────────
  /// Splash Screen — titik masuk awal aplikasi.
  static const String splash = '/';

  /// Login Screen.
  static const String login = '/login';

  /// Register Screen.
  static const String register = '/register';

  // ─── User Routes ──────────────────────────────────────────────────────────────
  /// Dashboard utama user (Home tab).
  static const String dashboard = '/dashboard';

  /// Scan Screen — kamera & galeri.
  static const String scan = '/scan';

  /// Result Screen — hasil identifikasi tanaman.
  static const String result = '/result';

  /// Plant Detail Screen — informasi lengkap tanaman.
  static const String plantDetail = '/plant-detail';

  /// History Screen — riwayat scan.
  static const String history = '/history';

  /// Profile Screen — data diri user.
  static const String profile = '/profile';

  /// Edit Profile Screen — ubah nama user.
  static const String editProfile = '/edit-profile';

  // ─── Admin Routes ─────────────────────────────────────────────────────────────
  /// Admin Dashboard — portal utama admin.
  static const String adminDashboard = '/admin/dashboard';

  /// Manage Plants Screen — daftar tanaman.
  static const String managePlants = '/admin/plants';

  /// Add Plant Screen — form tambah tanaman baru.
  static const String addPlant = '/admin/plants/add';

  /// Edit Plant Screen — form edit tanaman.
  static const String editPlant = '/admin/plants/edit';

  /// Manage Users Screen — daftar user.
  static const String manageUsers = '/admin/users';
}
