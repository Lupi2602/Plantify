import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/app_constants.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/plant_image_widget.dart';

/// Halaman hasil identifikasi tanaman setelah scan.
///
/// Menampilkan:
/// - Gambar scan
/// - Nama tanaman + confidence score
/// - Deskripsi tanaman
/// - Manfaat tanaman
/// - Tombol: "Scan Lagi" + "Lihat Detail"
///
/// State khusus: jika confidence < threshold → tampilkan "Tanaman Tidak Dikenali"
///
/// Phase 9: data hasil diterima dari TfliteService via ScanProvider.
/// Phase 2: menampilkan data dummy.
///
/// Referensi: UI_GUIDELINE.md — Result Screen, Unknown Result State
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  // ─── Phase 2 Dummy Data ────────────────────────────────────────────────────
  static const _dummyPlantName = 'Sirih Hijau';
  static const _dummyConfidence = 0.953;
  static const _dummyImagePath = '';
  static const _dummyDescription =
      'Sirih hijau (Piper betle) adalah tanaman merambat yang tumbuh subur di daerah tropis. '
      'Dikenal luas sebagai tanaman obat tradisional, sirih memiliki daun berbentuk hati yang '
      'berwarna hijau mengkilap. Tanaman ini banyak ditemukan di lingkungan kampus PNP.';
  static const _dummyManfaat = [
    'Memiliki sifat antiseptik alami',
    'Membantu penyembuhan luka ringan',
    'Digunakan sebagai obat kumur tradisional',
    'Memiliki kandungan antioksidan tinggi',
  ];
  // ─────────────────────────────────────────────────────────────────────────────

  bool get _isUnknown => _dummyConfidence < AppConstants.confidenceThreshold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hasil Identifikasi'),
        actions: [
          // Share — tidak ada di use case, hanya ikon info saja
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {},
            tooltip: 'Informasi',
          ),
        ],
      ),
      body: _isUnknown
          ? _buildUnknownState(context)
          : _buildResultContent(context),
    );
  }

  Widget _buildResultContent(BuildContext context) {
    final confidencePercent = (_dummyConfidence * 100).toStringAsFixed(2);
    final confidenceColor = AppColors.getConfidenceColor(_dummyConfidence);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Scan Image ───────────────────────────────────────────────────
          PlantImageWidget(
            imagePath: _dummyImagePath,
            width: double.infinity,
            height: 260,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Plant Name + Confidence ──────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _dummyPlantName,
                              style: AppTypography.headingLarge.copyWith(
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hasil identifikasi model AI',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Confidence Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: confidenceColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: confidenceColor.withAlpha(100)),
                        ),
                        child: Text(
                          '$confidencePercent%',
                          style: AppTypography.bodyText.copyWith(
                            color: confidenceColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Deskripsi ─────────────────────────────────────────────
                Text(
                  'Deskripsi',
                  style: AppTypography.headingMedium.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  _dummyDescription,
                  style: AppTypography.bodyText.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Manfaat ───────────────────────────────────────────────
                Text(
                  'Manfaat',
                  style: AppTypography.headingMedium.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                ..._dummyManfaat.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            m,
                            style: AppTypography.bodyText.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Action Buttons ───────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Scan Lagi',
                        onPressed: () => Navigator.pop(context),
                        variant: AppButtonVariant.outlined,
                        leadingIcon: Icons.camera_alt_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: 'Lihat Detail',
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RouteConstants.plantDetail,
                        ),
                        leadingIcon: Icons.info_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tampilan ketika confidence di bawah threshold.
  /// Referensi: UI_GUIDELINE.md — Unknown Result State
  Widget _buildUnknownState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.warningLight.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.help_outline_rounded,
                size: 64,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tanaman Tidak Dikenali',
              style: AppTypography.headingLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Model tidak dapat mengidentifikasi tanaman dengan keyakinan yang cukup. '
              'Coba ambil foto daun yang lebih jelas dan fokus.',
              style: AppTypography.bodyText.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Scan Ulang',
              onPressed: () => Navigator.pop(context),
              leadingIcon: Icons.camera_alt_rounded,
              isFullWidth: false,
              width: 180,
            ),
          ],
        ),
      ),
    );
  }
}
