import 'package:plantify_pnp/core/database/database_helper.dart';
import 'package:plantify_pnp/features/plant/models/plant_model.dart';

/// Repository untuk operasi database pada tabel [tanaman].
///
/// Digunakan bersama oleh:
/// - User flow : Plant Detail, Recommendation, Search (Phase 6)
/// - Admin flow: Plant Management — Tambah, Edit, Hapus (Phase 6)
///
/// Sesuai MASTER_PROMPT.md dan FLUTTER_ARCHITECTURE.md, tidak ada
/// AdminPlantRepository terpisah. Repository ini adalah satu-satunya
/// akses ke tabel [tanaman].
///
/// Status per phase:
/// - Phase 4 : Stub — method signature tersedia, implementasi belum ada.
/// - Phase 6 : Implementasi seluruh operasi CRUD + search + label lookup.
///
/// Referensi: DATABASE_SPEC.md — TABLE: tanaman, MASTER_PROMPT.md — Shared Plant Domain
class PlantRepository {
  final DatabaseHelper _dbHelper;

  PlantRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  // ─── Read ──────────────────────────────────────────────────────────────────

  /// Mengambil seluruh tanaman dari database.
  /// Digunakan oleh daftar tanaman User dan Admin.
  /// Phase 6: implementasi.
  Future<List<PlantModel>> getAll() {
    throw UnimplementedError('getAll — diimplementasikan di Phase 6');
  }

  /// Mencari tanaman berdasarkan id.
  /// Digunakan oleh Plant Detail Screen.
  /// Phase 6: implementasi.
  Future<PlantModel?> getById(int id) {
    throw UnimplementedError('getById — diimplementasikan di Phase 6');
  }

  /// Mencari tanaman berdasarkan [label_model].
  /// Digunakan oleh TFLite result mapping (Phase 10).
  /// Phase 6: implementasi (API disiapkan lebih awal).
  Future<PlantModel?> findByLabelModel(String labelModel) {
    throw UnimplementedError('findByLabelModel — diimplementasikan di Phase 6');
  }

  /// Mencari tanaman berdasarkan nama (partial match, case-insensitive).
  /// Digunakan oleh Search Bar di Dashboard.
  /// Phase 6: implementasi.
  Future<List<PlantModel>> search(String query) {
    throw UnimplementedError('search — diimplementasikan di Phase 6');
  }

  // ─── Write ─────────────────────────────────────────────────────────────────

  /// Menyisipkan tanaman baru ke database.
  /// Digunakan oleh Admin Add Plant.
  /// Phase 6: implementasi.
  Future<int> insert(PlantModel plant) {
    throw UnimplementedError('insert — diimplementasikan di Phase 6');
  }

  /// Memperbarui data tanaman.
  /// Digunakan oleh Admin Edit Plant.
  /// Phase 6: implementasi.
  Future<int> update(PlantModel plant) {
    throw UnimplementedError('update — diimplementasikan di Phase 6');
  }

  /// Menghapus tanaman berdasarkan id.
  /// Riwayat scan yang mereferensikan tanaman ini akan di-set NULL (ON DELETE SET NULL).
  /// Digunakan oleh Admin Delete Plant.
  /// Phase 6: implementasi.
  Future<int> delete(int id) {
    throw UnimplementedError('delete — diimplementasikan di Phase 6');
  }

  // ─── Internal Helper ───────────────────────────────────────────────────────

  // ignore: unused_field
  DatabaseHelper get dbHelper => _dbHelper;
}
