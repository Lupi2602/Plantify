import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/app_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';

/// Widget khusus untuk menampilkan gambar tanaman di seluruh halaman Plantify.PNP.
///
/// Mendukung dua tipe path yang disimpan di kolom `gambar` pada tabel tanaman:
///
/// 1. **Asset Path** — gambar bawaan aplikasi (seed data):
///    Contoh: `assets/images/plants/sirih_hijau.jpg`
///    → Menggunakan [Image.asset]
///
/// 2. **Local File Path** — gambar yang diupload admin saat runtime:
///    Contoh: `/data/user/0/com.plantify.pnp/files/plants/sirih_hijau.jpg`
///    → Menggunakan [Image.file]
///
/// 3. **Path kosong / placeholder** — ketika gambar belum tersedia:
///    Path: `''` (string kosong)
///    → Langsung tampilkan [_buildPlaceholder] tanpa mencoba memuat gambar.
///
/// Seluruh halaman yang menampilkan gambar tanaman WAJIB menggunakan widget ini.
/// Tidak boleh menduplikasi logika ini di setiap screen.
///
/// Referensi: DATABASE_SPEC.md — Image Rendering Rules, FLUTTER_ARCHITECTURE.md — PlantImageWidget
class PlantImageWidget extends StatelessWidget {
  /// Path gambar dari kolom `gambar` pada tabel tanaman.
  /// Bisa berupa asset path, local file path, atau string kosong (placeholder).
  final String imagePath;

  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const PlantImageWidget({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  /// Path valid jika tidak kosong dan bukan sekadar prefix 'assets/'.
  /// Path `'assets/'` tanpa nama file adalah path tidak valid yang akan
  /// menyebabkan HTTP 404 pada Flutter Web (URL menjadi /assets/assets/).
  bool get _isValidPath =>
      imagePath.isNotEmpty && imagePath != AppConstants.assetPathPrefix;

  /// Menentukan apakah path merupakan asset path atau local file path.
  /// Referensi: DATABASE_SPEC.md — Image Rendering Rules
  bool get _isAssetPath =>
      imagePath.startsWith(AppConstants.assetPathPrefix);

  @override
  Widget build(BuildContext context) {
    // Jika path tidak valid, langsung tampilkan placeholder
    if (!_isValidPath) {
      return _buildContainer(child: _buildPlaceholder());
    }

    if (_isAssetPath) {
      // Asset Path → gunakan Image.asset()
      return _buildContainer(
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, _, _) => _buildPlaceholder(),
        ),
      );
    } else {
      // Local File Path → hanya tersedia di mobile (bukan web)
      if (kIsWeb) {
        // Flutter Web tidak mendukung Image.file()
        return _buildContainer(child: _buildPlaceholder());
      }
      return _buildContainer(
        child: Image.file(
          File(imagePath),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, _, _) => _buildPlaceholder(),
        ),
      );
    }
  }

  /// Membungkus widget dengan Container yang memiliki dimensi dan border radius.
  Widget _buildContainer({required Widget child}) {
    final container = Container(
      width: width,
      height: height,
      color: AppColors.surfaceVariant,
      child: child,
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: container);
    }
    return container;
  }

  /// Placeholder adaptif yang ditampilkan ketika gambar tidak tersedia.
  ///
  /// Hanya menampilkan ikon jika tinggi kontainer <= 80px (thumbnail kecil)
  /// untuk menghindari RenderFlex overflow pada ukuran kecil.
  Widget _buildPlaceholder() {
    // Tentukan apakah ini tampilan kecil (thumbnail)
    final isSmall = height != null && height! <= 80;

    return Center(
      child: isSmall
          // Tampilan kecil: hanya ikon, tanpa teks
          ? Icon(
              Icons.eco_outlined,
              size: _placeholderIconSize,
              color: AppColors.primaryLight,
            )
          // Tampilan besar: ikon + teks
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.eco_outlined,
                  size: _placeholderIconSize,
                  color: AppColors.primaryLight,
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Gambar belum tersedia',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }

  /// Ukuran ikon placeholder, dibatasi agar tidak melebihi ukuran kontainer.
  double get _placeholderIconSize {
    if (height == null) return 40;
    // Maksimal 40% dari tinggi, min 16, max 40
    return (height! * 0.4).clamp(16, 40);
  }
}
