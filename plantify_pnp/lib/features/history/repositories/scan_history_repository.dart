import 'package:plantify_pnp/core/database/database_helper.dart';
import 'package:plantify_pnp/features/history/models/scan_history_model.dart';

/// Repository untuk operasi database pada tabel [riwayat_scan].
///
/// Seluruh akses ke tabel [riwayat_scan] wajib melalui class ini.
///
/// Status per phase:
/// - Phase 4 : Stub — method signature tersedia, implementasi belum ada.
/// - Phase 8 : Implementasi view dan delete riwayat.
/// - Phase 9 : Implementasi insert riwayat setelah scan selesai.
///
/// Referensi: DATABASE_SPEC.md — TABLE: riwayat_scan, Auto History Rule
class ScanHistoryRepository {
  final DatabaseHelper _dbHelper;

  ScanHistoryRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  // ─── Read ──────────────────────────────────────────────────────────────────

  /// Mengambil seluruh riwayat scan milik user tertentu,
  /// diurutkan dari yang terbaru.
  /// Digunakan oleh History Screen.
  /// Phase 8: implementasi.
  Future<List<ScanHistoryModel>> getByUserId(int userId) {
    throw UnimplementedError('getByUserId — diimplementasikan di Phase 8');
  }

  // ─── Write ─────────────────────────────────────────────────────────────────

  /// Menyimpan hasil identifikasi ke tabel [riwayat_scan].
  ///
  /// Dipanggil secara otomatis setelah identifikasi berhasil (confidence ≥ threshold).
  /// User tidak perlu menekan tombol simpan secara manual.
  ///
  /// Phase 9: implementasi (dipanggil dari ScanProvider setelah prediksi selesai).
  Future<int> insert(ScanHistoryModel scan) {
    throw UnimplementedError('insert — diimplementasikan di Phase 9');
  }

  /// Menghapus satu riwayat scan berdasarkan id.
  /// Digunakan oleh History Screen — hapus item individual.
  /// Phase 8: implementasi.
  Future<int> delete(int id) {
    throw UnimplementedError('delete — diimplementasikan di Phase 8');
  }

  /// Menghapus seluruh riwayat scan milik user tertentu.
  /// Digunakan oleh History Screen — hapus semua riwayat.
  /// Phase 8: implementasi.
  Future<int> deleteAllByUserId(int userId) {
    throw UnimplementedError('deleteAllByUserId — diimplementasikan di Phase 8');
  }

  // ─── Internal Helper ───────────────────────────────────────────────────────

  // ignore: unused_field
  DatabaseHelper get dbHelper => _dbHelper;
}
