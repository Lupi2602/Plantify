/// Konstanta khusus untuk domain Tanaman (Plant).
///
/// Memisahkan konstanta domain dari [AppConstants] agar mematuhi
/// prinsip Feature-First Architecture dan Separation of Concerns.
class PlantConstants {
  PlantConstants._();

  /// Batas jumlah tanaman acak yang direkomendasikan pada User Dashboard.
  /// Referensi: UI_GUIDELINE.md — Plant Recommendation Section
  static const int recommendationLimit = 4;

  /// Durasi debounce pencarian dalam milidetik.
  static const int searchDebounceMs = 300;

  /// Pesan sukses standar untuk Admin Plant Management.
  static const String addSuccessMessage = 'Tanaman berhasil ditambahkan.';
  static const String updateSuccessMessage = 'Data tanaman berhasil diperbarui.';
  static const String deleteSuccessMessage = 'Tanaman berhasil dihapus dari sistem.';

  // ── Konfigurasi Manajemen Gambar (Phase 6C) ───────────────────────────────
  static const int imageQuality = 85;
  static const double imageMaxWidth = 1080.0;
  static const double imageMaxHeight = 1080.0;
  static const String plantImagesFolder = 'images/plants';
  static const List<String> supportedImageExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
}
