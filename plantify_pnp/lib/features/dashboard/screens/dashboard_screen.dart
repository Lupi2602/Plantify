import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/features/auth/providers/auth_provider.dart';
import 'package:plantify_pnp/features/dashboard/widgets/plant_recommendation_card.dart';
import 'package:plantify_pnp/features/dashboard/widgets/quick_scan_card.dart';
import 'package:plantify_pnp/features/dashboard/widgets/recent_scan_card.dart';
import 'package:plantify_pnp/shared/widgets/empty_state_widget.dart';

/// Dashboard utama untuk User.
///
/// Sections:
/// 1. Welcome Section (greeting + nama user)
/// 2. Search Bar (pencarian tanaman by nama)
/// 3. Quick Scan Card
/// 4. Rekomendasi Tanaman (horizontal, acak dari tabel tanaman)
/// 5. Scan Terakhir (max 5, dari tabel riwayat_scan)
///
/// Phase 4+: data diganti dengan query SQLite via DashboardProvider.
/// Referensi: UI_GUIDELINE.md — User Dashboard
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();

  // ─── Phase 2 Dummy Data ─────────────────────────────────────────────────────
  // Akan diganti oleh DashboardProvider + PlantRepository di Phase 6 & 8

  final _dummyRecommendations = const [
    {'name': 'Sirih Hijau', 'desc': 'Tanaman obat tradisional', 'image': ''},
    {'name': 'Talas', 'desc': 'Umbi dari keluarga Araceae', 'image': ''},
    {'name': 'Nangka', 'desc': 'Pohon buah tropis besar', 'image': ''},
    {'name': 'Markisa', 'desc': 'Buah tanaman merambat', 'image': ''},
  ];

  final _dummyRecentScans = const [
    {
      'name': 'Sirih Hijau',
      'confidence': 0.953,
      'time': '2 jam lalu',
      'image': '',
    },
    {
      'name': 'Talas',
      'confidence': 0.821,
      'time': 'Kemarin',
      'image': '',
    },
  ];
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<AuthProvider>().currentUser?.nama ?? 'Pengguna';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──────────────────────────────────────────────────────
            SliverAppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              floating: true,
              pinned: false,
              automaticallyImplyLeading: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: AppTypography.caption.copyWith(fontSize: 12),
                  ),
                  Text(
                    '$userName 👋',
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, RouteConstants.profile),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.surfaceVariant,
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Search Bar ──────────────────────────────────────────
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari tanaman...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        // Phase 6: onChanged → PlantProvider.search(query)
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Quick Scan Card ─────────────────────────────────────
                    const QuickScanCard(),
                    const SizedBox(height: 24),

                    // ── Rekomendasi Tanaman ─────────────────────────────────
                    Text(
                      'Rekomendasi Tanaman',
                      style: AppTypography.headingMedium.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tanaman yang ada di kampus PNP',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 185,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _dummyRecommendations.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final plant = _dummyRecommendations[index];
                          return PlantRecommendationCard(
                            plantName: plant['name']!,
                            imagePath: plant['image']!,
                            description: plant['desc']!,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Scan Terakhir ───────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Scan Terakhir',
                          style: AppTypography.headingMedium.copyWith(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            RouteConstants.history,
                          ),
                          child: Text(
                            'Lihat Semua',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Recent Scan List
                    if (_dummyRecentScans.isEmpty)
                      EmptyStateWidget(
                        icon: Icons.history_rounded,
                        title: 'Belum Ada Scan',
                        message: 'Hasil scan terbaru Anda akan muncul di sini.',
                        actionLabel: 'Mulai Scan',
                        onAction: () {},
                      )
                    else
                      ...List.generate(_dummyRecentScans.length, (i) {
                        final scan = _dummyRecentScans[i];
                        return RecentScanCard(
                          plantName: scan['name'] as String,
                          imagePath: scan['image'] as String,
                          confidence: scan['confidence'] as double,
                          timeAgo: scan['time'] as String,
                        );
                      }),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
