import 'package:plantify_pnp/core/constants/database_constants.dart';

/// Model immutable yang merepresentasikan satu baris pada tabel [riwayat_scan].
///
/// Field [tanamanId] bersifat nullable karena tanaman yang pernah di-scan
/// mungkin sudah dihapus oleh admin (ON DELETE SET NULL).
/// Field [namaHasil] adalah snapshot nama tanaman pada saat scan dilakukan
/// sehingga riwayat tetap terbaca meski tanaman sudah dihapus.
///
/// Referensi: DATABASE_SPEC.md — TABLE: riwayat_scan
class ScanHistoryModel {
  final int?   id;
  final int    userId;
  final int?   tanamanId;
  final String namaHasil;
  final double confidence;
  final String gambarScan;
  final String createdAt;

  const ScanHistoryModel({
    this.id,
    required this.userId,
    this.tanamanId,
    required this.namaHasil,
    required this.confidence,
    required this.gambarScan,
    required this.createdAt,
  });

  // ─── Serialization ─────────────────────────────────────────────────────────

  /// Membuat [ScanHistoryModel] dari [Map] hasil query sqflite.
  factory ScanHistoryModel.fromMap(Map<String, dynamic> map) {
    return ScanHistoryModel(
      id:         map[DatabaseConstants.colId]         as int?,
      userId:     map[DatabaseConstants.colUserId]     as int,
      tanamanId:  map[DatabaseConstants.colTanamanId]  as int?,
      namaHasil:  map[DatabaseConstants.colNamaHasil]  as String,
      confidence: (map[DatabaseConstants.colConfidence] as num).toDouble(),
      gambarScan: map[DatabaseConstants.colGambarScan] as String,
      createdAt:  map[DatabaseConstants.colCreatedAt]  as String,
    );
  }

  /// Mengubah [ScanHistoryModel] menjadi [Map] untuk disimpan ke sqflite.
  ///
  /// Kolom [id] dikecualikan apabila bernilai null (INSERT — id di-generate DB).
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      DatabaseConstants.colUserId:     userId,
      DatabaseConstants.colTanamanId:  tanamanId,
      DatabaseConstants.colNamaHasil:  namaHasil,
      DatabaseConstants.colConfidence: confidence,
      DatabaseConstants.colGambarScan: gambarScan,
      DatabaseConstants.colCreatedAt:  createdAt,
    };
    if (id != null) map[DatabaseConstants.colId] = id;
    return map;
  }

  // ─── copyWith ──────────────────────────────────────────────────────────────

  /// Membuat salinan [ScanHistoryModel] dengan field yang ditentukan diubah.
  ScanHistoryModel copyWith({
    int?    id,
    int?    userId,
    int?    tanamanId,
    String? namaHasil,
    double? confidence,
    String? gambarScan,
    String? createdAt,
  }) {
    return ScanHistoryModel(
      id:         id         ?? this.id,
      userId:     userId     ?? this.userId,
      tanamanId:  tanamanId  ?? this.tanamanId,
      namaHasil:  namaHasil  ?? this.namaHasil,
      confidence: confidence ?? this.confidence,
      gambarScan: gambarScan ?? this.gambarScan,
      createdAt:  createdAt  ?? this.createdAt,
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Mengembalikan confidence dalam format persentase (misal: '87.45%').
  String get confidenceFormatted => '${confidence.toStringAsFixed(2)}%';

  @override
  String toString() =>
      'ScanHistoryModel(id: $id, userId: $userId, namaHasil: $namaHasil, '
      'confidence: $confidence)';
}
