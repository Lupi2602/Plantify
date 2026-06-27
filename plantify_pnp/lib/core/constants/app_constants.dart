/// Konstanta global aplikasi Plantify.PNP.
///
/// Referensi: PROJECT_CONTEXT.md, DATABASE_SPEC.md, FLUTTER_ARCHITECTURE.md
class AppConstants {
  AppConstants._();

  // ─── App Identity ────────────────────────────────────────────────────────────
  static const String appName = 'Plantify.PNP';
  static const String appTagline = 'Identifikasi Tanaman Kampus PNP';
  static const String appVersion = '1.0.0';

  // ─── Database ─────────────────────────────────────────────────────────────────
  /// Nama file database SQLite. Referensi: DATABASE_SPEC.md
  static const String databaseName = 'plantify.db';

  /// Versi database awal. Increment saat melakukan migration (onUpgrade).
  static const int databaseVersion = 1;

  // ─── AI / Identification ──────────────────────────────────────────────────────
  /// Threshold confidence untuk identifikasi tanaman.
  /// Jika confidence < aiThreshold, tampilkan "Tanaman Tidak Dikenali".
  /// Referensi: PROJECT_CONTEXT.md, DATABASE_SPEC.md, TRAINING_SPEC.md
  static const double aiThreshold = 0.70;

  /// Alias eksplisit untuk [aiThreshold]. Digunakan oleh ResultScreen.
  static const double confidenceThreshold = aiThreshold;

  /// Pesan yang ditampilkan ketika confidence di bawah threshold.
  static const String unknownPlantMessage = 'Tanaman Tidak Dikenali';

  // ─── Splash Screen ────────────────────────────────────────────────────────────
  /// Durasi splash screen dalam detik. Referensi: UI_GUIDELINE.md
  static const int splashDurationSeconds = 3;

  // ─── Search Debounce ──────────────────────────────────────────────────────────
  /// Durasi debounce pencarian global dalam milidetik.
  /// Referensi: Phase 7 Final Pre-Implementation Revision
  static const int searchDebounceMs = 300;

  // ─── Dashboard ────────────────────────────────────────────────────────────────
  /// Jumlah maksimal item pada Recent Scan di Dashboard. Referensi: UI_GUIDELINE.md
  static const int recentScanLimit = 5;

  // ─── Session / SharedPreferences Keys ─────────────────────────────────────────
  /// Key untuk menyimpan ID user yang sedang login. Referensi: DATABASE_SPEC.md
  static const String keyLoggedInUserId = 'logged_in_user_id';

  /// Key untuk menyimpan role user yang sedang login. Referensi: DATABASE_SPEC.md
  static const String keyLoggedInRole = 'logged_in_role';

  // ─── User Roles ───────────────────────────────────────────────────────────────
  /// Nilai role admin pada tabel users. Referensi: DATABASE_SPEC.md
  static const String roleAdmin = 'admin';

  /// Nilai role user biasa pada tabel users. Referensi: DATABASE_SPEC.md
  static const String roleUser = 'user';

  // ─── User Status ──────────────────────────────────────────────────────────────
  /// Status user aktif. Referensi: DATABASE_SPEC.md
  static const int statusActive = 1;

  /// Status user nonaktif. Referensi: DATABASE_SPEC.md
  static const int statusInactive = 0;

  // ─── Asset Paths ──────────────────────────────────────────────────────────────
  /// Prefix untuk membedakan asset path dari local file path.
  /// Digunakan oleh PlantImageWidget untuk memilih Image.asset() atau Image.file().
  /// Referensi: DATABASE_SPEC.md — Image Rendering Rules
  static const String assetPathPrefix = 'assets/';

  /// Base path untuk gambar tanaman pada seed data.
  static const String plantImagesPath = 'assets/images/plants/';

  // ─── Seed Data Credentials ───────────────────────────────────────────────────
  /// Default admin email untuk seed data. Referensi: DATABASE_SPEC.md
  static const String seedAdminEmail = 'admin@plantify.com';

  /// Default admin password (plain text, akan di-hash saat insert).
  static const String seedAdminPassword = 'admin123';

  /// Default user email untuk seed data. Referensi: DATABASE_SPEC.md
  static const String seedUserEmail = 'user@plantify.com';

  /// Default user password (plain text, akan di-hash saat insert).
  static const String seedUserPassword = 'user123';
}
