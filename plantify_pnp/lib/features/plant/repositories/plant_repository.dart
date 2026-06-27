import 'package:plantify_pnp/core/constants/database_constants.dart';
import 'package:plantify_pnp/core/database/database_helper.dart';
import 'package:plantify_pnp/features/plant/constants/plant_constants.dart';
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

  /// Mengambil seluruh tanaman dari database diurutkan abjad nama.
  Future<List<PlantModel>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseConstants.tableTanaman,
      orderBy: '${DatabaseConstants.colNamaTanaman} ASC',
    );
    return maps.map((map) => PlantModel.fromMap(map)).toList();
  }

  /// Mencari tanaman berdasarkan id.
  Future<PlantModel?> getById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseConstants.tableTanaman,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return PlantModel.fromMap(maps.first);
  }

  /// Mencari tanaman berdasarkan [label_model].
  /// Digunakan oleh TFLite result mapping (Phase 10).
  Future<PlantModel?> findByLabelModel(String labelModel) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseConstants.tableTanaman,
      where: '${DatabaseConstants.colLabelModel} = ?',
      whereArgs: [labelModel],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return PlantModel.fromMap(maps.first);
  }

  /// Mencari tanaman berdasarkan nama (partial match, case-insensitive).
  /// Menggunakan kombinasi LOWER untuk jaminan kompatibilitas di seluruh OS Android.
  Future<List<PlantModel>> search(String query) async {
    final db = await _dbHelper.database;
    final trimmedQuery = query.trim().toLowerCase();
    final maps = await db.rawQuery(
      '''
      SELECT * FROM ${DatabaseConstants.tableTanaman}
      WHERE LOWER(${DatabaseConstants.colNamaTanaman}) LIKE ?
      ORDER BY ${DatabaseConstants.colNamaTanaman} ASC
      ''',
      ['%$trimmedQuery%'],
    );
    return maps.map((map) => PlantModel.fromMap(map)).toList();
  }

  /// Mengambil rekomendasi tanaman acak dari tabel SQLite.
  /// Batas default menggunakan [PlantConstants.recommendationLimit].
  Future<List<PlantModel>> getRecommendations({int? limit}) async {
    final db = await _dbHelper.database;
    final actualLimit = limit ?? PlantConstants.recommendationLimit;
    final maps = await db.query(
      DatabaseConstants.tableTanaman,
      orderBy: 'RANDOM()',
      limit: actualLimit,
    );
    return maps.map((map) => PlantModel.fromMap(map)).toList();
  }

  // ─── Write ─────────────────────────────────────────────────────────────────

  /// Menyisipkan tanaman baru ke database.
  Future<int> insert(PlantModel plant) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseConstants.tableTanaman,
      plant.toMap(),
    );
  }

  /// Memperbarui data tanaman.
  Future<int> update(PlantModel plant) async {
    if (plant.id == null) {
      throw ArgumentError('Tidak dapat memperbarui tanaman dengan ID null');
    }
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseConstants.tableTanaman,
      plant.toMap(),
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [plant.id],
    );
  }

  /// Menghapus tanaman berdasarkan id.
  /// Riwayat scan yang mereferensikan tanaman ini akan otomatis di-set NULL (ON DELETE SET NULL).
  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableTanaman,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  // ─── Internal Helper ───────────────────────────────────────────────────────

  DatabaseHelper get dbHelper => _dbHelper;
}
