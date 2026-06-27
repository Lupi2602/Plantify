/// Utilitasi terpusat untuk menghasilkan format timestamp standar aplikasi.
///
/// Menjamin konsistensi format waktu ('YYYY-MM-DD HH:mm:ss') di seluruh
/// operasi CRUD, seed data, dan sesi pengguna.
class TimestampHelper {
  TimestampHelper._();

  /// Mengembalikan waktu saat ini dalam format string 'YYYY-MM-DD HH:mm:ss'.
  static String currentTimestamp() {
    final now = DateTime.now();
    return now.toIso8601String().substring(0, 19).replaceAll('T', ' ');
  }
}
