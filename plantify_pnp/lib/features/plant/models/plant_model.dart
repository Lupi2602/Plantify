import 'package:plantify_pnp/core/constants/database_constants.dart';

/// Model immutable yang merepresentasikan satu baris pada tabel [tanaman].
///
/// Digunakan bersama oleh fitur User (Plant Detail, Recommendation)
/// maupun Admin (Plant Management). Tidak ada AdminPlantModel terpisah.
///
/// Field [gambar] mendukung dua format path:
/// - Asset path  : dimulai dengan 'assets/' → gunakan Image.asset()
/// - Local path  : path absolut perangkat   → gunakan Image.file()
///
/// Referensi: DATABASE_SPEC.md — TABLE: tanaman, MASTER_PROMPT.md — Shared Plant Domain
class PlantModel {
  final int?   id;
  final String namaTanaman;
  final String deskripsi;
  final String manfaat;
  final String gambar;
  final String labelModel;
  final String createdAt;
  final String updatedAt;

  const PlantModel({
    this.id,
    required this.namaTanaman,
    required this.deskripsi,
    required this.manfaat,
    required this.gambar,
    required this.labelModel,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── Serialization ─────────────────────────────────────────────────────────

  /// Membuat [PlantModel] dari [Map] hasil query sqflite.
  factory PlantModel.fromMap(Map<String, dynamic> map) {
    return PlantModel(
      id:          map[DatabaseConstants.colId]          as int?,
      namaTanaman: map[DatabaseConstants.colNamaTanaman] as String,
      deskripsi:   map[DatabaseConstants.colDeskripsi]   as String,
      manfaat:     map[DatabaseConstants.colManfaat]      as String,
      gambar:      map[DatabaseConstants.colGambar]       as String,
      labelModel:  map[DatabaseConstants.colLabelModel]   as String,
      createdAt:   map[DatabaseConstants.colCreatedAt]    as String,
      updatedAt:   map[DatabaseConstants.colUpdatedAt]    as String,
    );
  }

  /// Mengubah [PlantModel] menjadi [Map] untuk disimpan ke sqflite.
  ///
  /// Kolom [id] dikecualikan apabila bernilai null (INSERT — id di-generate DB).
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      DatabaseConstants.colNamaTanaman: namaTanaman,
      DatabaseConstants.colDeskripsi:   deskripsi,
      DatabaseConstants.colManfaat:     manfaat,
      DatabaseConstants.colGambar:      gambar,
      DatabaseConstants.colLabelModel:  labelModel,
      DatabaseConstants.colCreatedAt:   createdAt,
      DatabaseConstants.colUpdatedAt:   updatedAt,
    };
    if (id != null) map[DatabaseConstants.colId] = id;
    return map;
  }

  // ─── copyWith ──────────────────────────────────────────────────────────────

  /// Membuat salinan [PlantModel] dengan field yang ditentukan diubah.
  PlantModel copyWith({
    int?    id,
    String? namaTanaman,
    String? deskripsi,
    String? manfaat,
    String? gambar,
    String? labelModel,
    String? createdAt,
    String? updatedAt,
  }) {
    return PlantModel(
      id:          id          ?? this.id,
      namaTanaman: namaTanaman ?? this.namaTanaman,
      deskripsi:   deskripsi   ?? this.deskripsi,
      manfaat:     manfaat     ?? this.manfaat,
      gambar:      gambar      ?? this.gambar,
      labelModel:  labelModel  ?? this.labelModel,
      createdAt:   createdAt   ?? this.createdAt,
      updatedAt:   updatedAt   ?? this.updatedAt,
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Mengembalikan true apabila gambar adalah asset bawaan aplikasi.
  bool get isAssetImage => gambar.startsWith('assets/');

  @override
  String toString() =>
      'PlantModel(id: $id, namaTanaman: $namaTanaman, labelModel: $labelModel)';
}
