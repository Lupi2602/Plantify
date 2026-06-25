import 'package:plantify_pnp/core/constants/database_constants.dart';

/// Model immutable yang merepresentasikan satu baris pada tabel [users].
///
/// Seluruh field bersifat final (immutable).
/// Gunakan [copyWith] untuk membuat salinan dengan field yang diubah.
///
/// Referensi: DATABASE_SPEC.md — TABLE: users
class UserModel {
  final int?   id;
  final String nama;
  final String email;
  final String password;
  final String role;
  final int    status;
  final String createdAt;
  final String updatedAt;

  const UserModel({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── Serialization ─────────────────────────────────────────────────────────

  /// Membuat [UserModel] dari [Map] hasil query sqflite.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id:        map[DatabaseConstants.colId]        as int?,
      nama:      map[DatabaseConstants.colNama]      as String,
      email:     map[DatabaseConstants.colEmail]     as String,
      password:  map[DatabaseConstants.colPassword]  as String,
      role:      map[DatabaseConstants.colRole]      as String,
      status:    map[DatabaseConstants.colStatus]    as int,
      createdAt: map[DatabaseConstants.colCreatedAt] as String,
      updatedAt: map[DatabaseConstants.colUpdatedAt] as String,
    );
  }

  /// Mengubah [UserModel] menjadi [Map] untuk disimpan ke sqflite.
  ///
  /// Kolom [id] dikecualikan apabila bernilai null (INSERT — id di-generate DB).
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      DatabaseConstants.colNama:      nama,
      DatabaseConstants.colEmail:     email,
      DatabaseConstants.colPassword:  password,
      DatabaseConstants.colRole:      role,
      DatabaseConstants.colStatus:    status,
      DatabaseConstants.colCreatedAt: createdAt,
      DatabaseConstants.colUpdatedAt: updatedAt,
    };
    if (id != null) map[DatabaseConstants.colId] = id;
    return map;
  }

  // ─── copyWith ──────────────────────────────────────────────────────────────

  /// Membuat salinan [UserModel] dengan field yang ditentukan diubah.
  UserModel copyWith({
    int?    id,
    String? nama,
    String? email,
    String? password,
    String? role,
    int?    status,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id:        id        ?? this.id,
      nama:      nama      ?? this.nama,
      email:     email     ?? this.email,
      password:  password  ?? this.password,
      role:      role      ?? this.role,
      status:    status    ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Mengembalikan true apabila role user adalah 'admin'.
  bool get isAdmin => role == 'admin';

  /// Mengembalikan true apabila akun sedang aktif.
  bool get isActive => status == 1;

  @override
  String toString() =>
      'UserModel(id: $id, nama: $nama, email: $email, role: $role, status: $status)';
}
