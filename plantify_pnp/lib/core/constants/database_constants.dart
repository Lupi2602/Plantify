/// Konstanta nama database, versi, nama tabel, dan nama kolom untuk Plantify.PNP.
///
/// Seluruh referensi ke nama tabel dan kolom pada DatabaseHelper maupun
/// Repository wajib menggunakan konstanta dari class ini — tidak boleh
/// menggunakan string literal secara langsung.
///
/// Tujuan: menghindari typo, memudahkan refactor, dan memastikan konsistensi
/// antara DDL (DatabaseHelper) dan DML (Repository).
///
/// Referensi: DATABASE_SPEC.md — Seluruh spesifikasi tabel
class DatabaseConstants {
  DatabaseConstants._();

  // ─── Database ──────────────────────────────────────────────────────────────
  static const String dbName    = 'plantify.db';
  static const int    dbVersion = 1;

  // ─── Table Names ───────────────────────────────────────────────────────────
  static const String tableUsers       = 'users';
  static const String tableTanaman     = 'tanaman';
  static const String tableRiwayatScan = 'riwayat_scan';

  // ─── Common Columns ────────────────────────────────────────────────────────
  /// Primary key — digunakan di semua tabel.
  static const String colId        = 'id';
  /// Timestamp pembuatan baris — format: YYYY-MM-DD HH:mm:ss
  static const String colCreatedAt = 'created_at';
  /// Timestamp pembaruan baris — format: YYYY-MM-DD HH:mm:ss
  static const String colUpdatedAt = 'updated_at';

  // ─── Table: users ──────────────────────────────────────────────────────────
  /// Nama lengkap pengguna.
  static const String colNama     = 'nama';
  /// Email unik pengguna — COLLATE NOCASE, disimpan lowercase.
  static const String colEmail    = 'email';
  /// Password ter-hash SHA-256.
  static const String colPassword = 'password';
  /// Role pengguna: 'admin' | 'user'.
  static const String colRole     = 'role';
  /// Status akun: 1 = aktif, 0 = nonaktif.
  static const String colStatus   = 'status';

  // ─── Table: tanaman ────────────────────────────────────────────────────────
  /// Nama tampilan tanaman (unik).
  static const String colNamaTanaman = 'nama_tanaman';
  /// Deskripsi umum tanaman.
  static const String colDeskripsi   = 'deskripsi';
  /// Manfaat tanaman.
  static const String colManfaat     = 'manfaat';
  /// Path gambar tanaman (asset path atau local file path).
  static const String colGambar      = 'gambar';
  /// Label TensorFlow Lite — harus identik dengan labels.txt.
  static const String colLabelModel  = 'label_model';

  // ─── Table: riwayat_scan ───────────────────────────────────────────────────
  /// Foreign key ke tabel users.
  static const String colUserId     = 'user_id';
  /// Foreign key ke tabel tanaman (nullable — ON DELETE SET NULL).
  static const String colTanamanId  = 'tanaman_id';
  /// Snapshot nama tanaman saat scan — tetap tersimpan meski tanaman dihapus.
  static const String colNamaHasil  = 'nama_hasil';
  /// Nilai confidence hasil identifikasi (0.0 – 100.0).
  static const String colConfidence = 'confidence';
  /// Path gambar hasil scan.
  static const String colGambarScan = 'gambar_scan';
}
