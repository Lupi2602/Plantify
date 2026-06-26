import 'package:plantify_pnp/core/constants/database_constants.dart';
import 'package:plantify_pnp/core/database/database_helper.dart';
import 'package:plantify_pnp/features/auth/models/user_model.dart';

/// Repository untuk operasi database pada tabel [users].
///
/// Seluruh akses ke tabel [users] wajib melalui class ini.
/// Screen tidak boleh mengakses database secara langsung.
///
/// Status per phase:
/// - Phase 4 : Stub — method signature tersedia, implementasi belum ada.
/// - Phase 5 : Implementasi login, register, session validation, edit nama.
/// - Phase 7 : Implementasi updateStatus untuk fitur kelola user (Admin).
///
/// Referensi: DATABASE_SPEC.md — TABLE: users, FLUTTER_ARCHITECTURE.md — Repository Pattern
class UserRepository {
  final DatabaseHelper _dbHelper;

  UserRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  // ─── Read ──────────────────────────────────────────────────────────────────

  /// Mencari user berdasarkan email (case-insensitive).
  /// Digunakan oleh login dan session validation.
  /// Phase 5: implementasi.
  Future<UserModel?> findByEmail(String email) async {
    final db = await _dbHelper.database;
    final cleanEmail = email.trim().toLowerCase();
    final maps = await db.query(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.colEmail} = ?',
      whereArgs: [cleanEmail],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  /// Mencari user berdasarkan id.
  /// Digunakan oleh session validation saat startup.
  /// Phase 5: implementasi.
  Future<UserModel?> findById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  /// Mengambil seluruh user.
  /// Digunakan oleh Admin User Management.
  /// Phase 7: implementasi.
  Future<List<UserModel>> getAll() {
    throw UnimplementedError('getAll — diimplementasikan di Phase 7');
  }

  // ─── Write ─────────────────────────────────────────────────────────────────

  /// Menyisipkan user baru ke tabel [users].
  /// Digunakan oleh register.
  /// Phase 5: implementasi.
  Future<int> insert(UserModel user) async {
    final db = await _dbHelper.database;
    return db.insert(DatabaseConstants.tableUsers, user.toMap());
  }

  /// Memperbarui nama pengguna.
  /// Digunakan oleh Edit Profile.
  /// Phase 5: implementasi.
  Future<int> updateNama(int id, String nama) async {
    final db = await _dbHelper.database;
    return db.update(
      DatabaseConstants.tableUsers,
      {
        DatabaseConstants.colNama: nama,
        DatabaseConstants.colUpdatedAt: DatabaseHelper.currentTimestamp(),
      },
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// Memperbarui status akun (1 = aktif, 0 = nonaktif).
  /// Digunakan oleh Admin User Management.
  /// Phase 7: implementasi.
  Future<int> updateStatus(int id, int status) {
    throw UnimplementedError('updateStatus — diimplementasikan di Phase 7');
  }

  // ─── Internal Helper ───────────────────────────────────────────────────────

  /// Referensi ke DatabaseHelper untuk digunakan saat implementasi.
  DatabaseHelper get dbHelper => _dbHelper;
}
