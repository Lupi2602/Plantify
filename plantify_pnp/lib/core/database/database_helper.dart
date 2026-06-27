import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:plantify_pnp/core/constants/database_constants.dart';
import 'package:plantify_pnp/core/utils/timestamp_helper.dart';

/// Singleton helper untuk membuka dan mengelola database SQLite Plantify.PNP.
///
/// Tanggung jawab:
/// - Membuka / membuat file database [DatabaseConstants.dbName]
/// - Mengaktifkan Foreign Key (PRAGMA foreign_keys = ON)
/// - Membuat tabel pada [_onCreate] (DDL)
/// - Menginisialisasi seed data default pada [_seedData]
/// - Mendukung migrasi pada [_onUpgrade]
///
/// Penggunaan:
/// ```dart
/// final db = await DatabaseHelper.instance.database;
/// ```
///
/// Referensi: DATABASE_SPEC.md — SQLite Rules, FLUTTER_ARCHITECTURE.md — Database Layer
class DatabaseHelper {
  DatabaseHelper._();

  /// Singleton instance.
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  /// Mengembalikan instance [Database] yang sudah terbuka.
  /// Inisialisasi dilakukan secara lazy pada pemanggilan pertama.
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // ─── Initialization ────────────────────────────────────────────────────────

  Future<Database> _initDatabase() async {
    final dir  = await getApplicationDocumentsDirectory();
    final path = join(dir.path, DatabaseConstants.dbName);

    return openDatabase(
      path,
      version:   DatabaseConstants.dbVersion,
      onCreate:  _onCreate,
      onUpgrade: _onUpgrade,
      onOpen:    _onOpen,
    );
  }

  /// Dipanggil setiap kali database dibuka — mengaktifkan Foreign Key support.
  Future<void> _onOpen(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Dipanggil pertama kali saat database dibuat — membuat tabel dan seed data.
  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
    await _seedData(db);
  }

  /// Dipanggil saat versi database meningkat — untuk migrasi schema.
  /// Phase 4: belum diperlukan. Akan diisi pada versi database berikutnya.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Contoh migrasi masa depan:
    // if (oldVersion < 2) { await db.execute('ALTER TABLE ...'); }
  }

  // ─── DDL: Create Tables ────────────────────────────────────────────────────

  Future<void> _createTables(Database db) async {
    // Tabel: users
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableUsers} (
        ${DatabaseConstants.colId}        INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colNama}      TEXT    NOT NULL,
        ${DatabaseConstants.colEmail}     TEXT    NOT NULL UNIQUE COLLATE NOCASE,
        ${DatabaseConstants.colPassword}  TEXT    NOT NULL,
        ${DatabaseConstants.colRole}      TEXT    NOT NULL DEFAULT 'user'
                          CHECK(${DatabaseConstants.colRole} IN ('admin','user')),
        ${DatabaseConstants.colStatus}    INTEGER NOT NULL DEFAULT 1
                          CHECK(${DatabaseConstants.colStatus} IN (0,1)),
        ${DatabaseConstants.colCreatedAt} TEXT    NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT    NOT NULL
      )
    ''');

    // Tabel: tanaman
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableTanaman} (
        ${DatabaseConstants.colId}           INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colNamaTanaman}  TEXT    NOT NULL UNIQUE,
        ${DatabaseConstants.colDeskripsi}    TEXT    NOT NULL,
        ${DatabaseConstants.colManfaat}      TEXT    NOT NULL,
        ${DatabaseConstants.colGambar}       TEXT    NOT NULL,
        ${DatabaseConstants.colLabelModel}   TEXT    NOT NULL UNIQUE,
        ${DatabaseConstants.colCreatedAt}    TEXT    NOT NULL,
        ${DatabaseConstants.colUpdatedAt}    TEXT    NOT NULL
      )
    ''');

    // Tabel: riwayat_scan
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableRiwayatScan} (
        ${DatabaseConstants.colId}         INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colUserId}     INTEGER NOT NULL,
        ${DatabaseConstants.colTanamanId}  INTEGER,
        ${DatabaseConstants.colNamaHasil}  TEXT    NOT NULL,
        ${DatabaseConstants.colConfidence} REAL    NOT NULL,
        ${DatabaseConstants.colGambarScan} TEXT    NOT NULL,
        ${DatabaseConstants.colCreatedAt}  TEXT    NOT NULL,
        FOREIGN KEY (${DatabaseConstants.colUserId})
          REFERENCES ${DatabaseConstants.tableUsers}(${DatabaseConstants.colId}),
        FOREIGN KEY (${DatabaseConstants.colTanamanId})
          REFERENCES ${DatabaseConstants.tableTanaman}(${DatabaseConstants.colId})
          ON DELETE SET NULL
      )
    ''');
  }

  // ─── Seed Data ─────────────────────────────────────────────────────────────

  /// Menyisipkan akun default dan data tanaman awal saat database pertama kali dibuat.
  ///
  /// Menggunakan [ConflictAlgorithm.ignore] agar aman jika dipanggil ulang.
  ///
  /// Akun default (sesuai DATABASE_SPEC.md):
  /// - Admin : admin@plantify.com / admin123
  /// - User  : user@plantify.com  / user123
  ///
  /// Seed Data Tanaman:
  /// Mengikuti daftar tanaman resmi aplikasi dengan data lengkap (nama, deskripsi,
  /// manfaat, gambar asset, dan label_model) sesuai Revisi 2 Phase 6A.
  Future<void> _seedData(Database db) async {
    final now = _currentTimestamp();

    // 1. Seed Users
    await db.insert(
      DatabaseConstants.tableUsers,
      {
        DatabaseConstants.colNama:      'Administrator',
        DatabaseConstants.colEmail:     'admin@plantify.com',
        DatabaseConstants.colPassword:  _hashPassword('admin123'),
        DatabaseConstants.colRole:      'admin',
        DatabaseConstants.colStatus:    1,
        DatabaseConstants.colCreatedAt: now,
        DatabaseConstants.colUpdatedAt: now,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    await db.insert(
      DatabaseConstants.tableUsers,
      {
        DatabaseConstants.colNama:      'User Demo',
        DatabaseConstants.colEmail:     'user@plantify.com',
        DatabaseConstants.colPassword:  _hashPassword('user123'),
        DatabaseConstants.colRole:      'user',
        DatabaseConstants.colStatus:    1,
        DatabaseConstants.colCreatedAt: now,
        DatabaseConstants.colUpdatedAt: now,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    // 2. Seed Tanaman (Lengkap & Autentik, Tanpa Placeholder)
    final initialPlants = [
      {
        DatabaseConstants.colNamaTanaman: 'Sirih Hijau',
        DatabaseConstants.colDeskripsi:
            'Sirih hijau (Piper betle) adalah tanaman merambat asli Asia Tenggara dari keluarga Piperaceae. Daunnya berbentuk hati dengan warna hijau mengkilap dan memiliki aroma khas yang kuat. Tanaman ini banyak dibudidayakan sebagai tanaman pekarangan dan tanaman obat tradisional yang bernilai tinggi.',
        DatabaseConstants.colManfaat:
            '• Bersifat antiseptik alami yang efektif melawan bakteri\n• Membantu mempercepat penyembuhan luka ringan\n• Digunakan sebagai obat kumur tradisional untuk kesehatan rongga mulut\n• Mengandung antioksidan alami untuk melindungi sel tubuh',
        DatabaseConstants.colGambar: 'assets/images/plants/sirih_hijau.png',
        DatabaseConstants.colLabelModel: 'sirih_hijau',
      },
      {
        DatabaseConstants.colNamaTanaman: 'Talas',
        DatabaseConstants.colDeskripsi:
            'Talas (Colocasia esculenta) adalah tanaman umbi-umbian dari keluarga Araceae yang populer di wilayah tropis. Daunnya berukuran besar berbentuk perisai dengan permukaan kedap air. Umbi dan daun mudanya kaya akan nutrisi serat dan karbohidrat kompleks.',
        DatabaseConstants.colManfaat:
            '• Sumber karbohidrat kompleks dan serat pangan yang tinggi\n• Membantu menjaga kesehatan pencernaan dan mengontrol gula darah\n• Daun muda dapat diolah menjadi hidangan kuliner bergizi tinggi\n• Mengandung kalium dan magnesium untuk kesehatan jantung',
        DatabaseConstants.colGambar: 'assets/images/plants/talas.png',
        DatabaseConstants.colLabelModel: 'talas',
      },
      {
        DatabaseConstants.colNamaTanaman: 'Nangka',
        DatabaseConstants.colDeskripsi:
            'Nangka (Artocarpus heterophyllus) adalah pohon buah tropis berukuran besar dari keluarga Moraceae. Daunnya tunggal, lonjong, tebal, dan berwarna hijau tua mengkilap. Buahnya merupakan salah satu buah berukuran paling besar di dunia dengan daging buah yang manis dan harum.',
        DatabaseConstants.colManfaat:
            '• Buah matang kaya akan vitamin A, vitamin C, dan antioksidan\n• Buah muda kaya serat dan populer sebagai bahan pangan nabati\n• Daun tua secara tradisional digunakan dalam ramuan herbal\n• Kayunya memiliki kualitas tinggi dan tahan serangan rayap',
        DatabaseConstants.colGambar: 'assets/images/plants/nangka.png',
        DatabaseConstants.colLabelModel: 'nangka',
      },
      {
        DatabaseConstants.colNamaTanaman: 'Markisa',
        DatabaseConstants.colDeskripsi:
            'Markisa (Passiflora edulis) adalah tanaman buah merambat dari keluarga Passifloraceae asli daerah tropis dan subtropis. Tanaman ini tumbuh menjalar dengan sulur pembelit dan menghasilkan buah berdaging manis asam yang kaya nutrisi serta menyegarkan.',
        DatabaseConstants.colManfaat:
            '• Kaya akan kandungan vitamin C sebagai pendukung sistem imun tubuh\n• Mengandung serat larut alami yang baik untuk kesehatan usus\n• Ekstrak daun dan buahnya diketahui memiliki efek menenangkan (relaksan alami)\n• Kaya akan senyawa antioksidan polifenol',
        DatabaseConstants.colGambar: 'assets/images/plants/markisa.png',
        DatabaseConstants.colLabelModel: 'markisa',
      },
    ];

    for (final plant in initialPlants) {
      await db.insert(
        DatabaseConstants.tableTanaman,
        {
          ...plant,
          DatabaseConstants.colCreatedAt: now,
          DatabaseConstants.colUpdatedAt: now,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // ─── Utilities ─────────────────────────────────────────────────────────────

  /// Menghasilkan hash SHA-256 dari [plainText].
  ///
  /// Digunakan untuk seed data. Phase 5 akan menggunakan method yang sama
  /// melalui repository untuk hashing password saat register dan login.
  static String hashPassword(String plainText) => _hashPassword(plainText);

  static String _hashPassword(String plainText) {
    final bytes  = utf8.encode(plainText);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Mengembalikan timestamp saat ini dalam format 'YYYY-MM-DD HH:mm:ss'.
  static String currentTimestamp() => _currentTimestamp();

  static String _currentTimestamp() => TimestampHelper.currentTimestamp();
}
