import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/shared/widgets/plant_image_widget.dart';

/// Halaman detail lengkap sebuah tanaman.
///
/// Menampilkan: gambar besar, nama, deskripsi, manfaat (bullet list).
/// Data berasal dari tabel tanaman.
///
/// Phase 6: data diterima via argument (PlantModel) dari Navigator.
/// Phase 2: menampilkan data dummy.
///
/// Referensi: UI_GUIDELINE.md — Plant Detail Screen, DATABASE_SPEC.md — tanaman table
class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({super.key});

  // ─── Phase 2 Dummy Data ────────────────────────────────────────────────────
  static const _dummyName = 'Sirih Hijau';
  static const _dummyImagePath = '';
  static const _dummyDescription =
      'Sirih hijau (Piper betle) adalah tanaman merambat dari keluarga Piperaceae yang banyak '
      'ditemukan di Asia Tenggara, termasuk Indonesia. Tanaman ini memiliki daun berbentuk hati '
      'dengan warna hijau mengkilap dan aroma khas yang kuat.\n\n'
      'Di lingkungan kampus Politeknik Negeri Padang (PNP), sirih hijau dapat ditemukan tumbuh '
      'secara alami di area taman dan sisi gedung. Tanaman ini memiliki nilai budaya dan medis '
      'yang tinggi dalam tradisi Minangkabau.';
  static const _dummyManfaat = [
    'Bersifat antiseptik alami — efektif membunuh bakteri',
    'Membantu penyembuhan luka dan infeksi ringan',
    'Digunakan sebagai obat kumur tradisional untuk menjaga kesehatan gigi',
    'Kandungan antioksidan tinggi — melindungi sel dari kerusakan',
    'Digunakan dalam ritual budaya Minangkabau (sirih pinang)',
    'Memiliki sifat anti-inflamasi',
  ];
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Sliver App Bar (gambar besar dengan overlay) ──────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Plant Image
                  PlantImageWidget(
                    imagePath: _dummyImagePath,
                    fit: BoxFit.cover,
                  ),
                  // Gradient Overlay for readability
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant Name
                  Text(
                    _dummyName,
                    style: AppTypography.headingLarge.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 4),
                  // Label / Latin name placeholder
                  Text(
                    'Piper betle L.',
                    style: AppTypography.caption.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 20),

                  // ── Deskripsi ─────────────────────────────────────────
                  _SectionHeader(title: 'Deskripsi'),
                  const SizedBox(height: 8),
                  Text(
                    _dummyDescription,
                    style: AppTypography.bodyText.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Manfaat ───────────────────────────────────────────
                  _SectionHeader(title: 'Manfaat Tanaman'),
                  const SizedBox(height: 12),
                  ..._dummyManfaat.map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.headingMedium.copyWith(fontSize: 16),
        ),
      ],
    );
  }
}
