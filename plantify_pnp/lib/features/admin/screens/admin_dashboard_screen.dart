import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/features/admin/widgets/admin_menu_card.dart';
import 'package:plantify_pnp/features/admin/widgets/admin_summary_card.dart';

/// Dashboard utama untuk Admin.
///
/// Admin TIDAK menggunakan Bottom Navigation.
/// Admin navigasi menggunakan AppBar dan menu cards.
///
/// Summary Cards: Total Tanaman, Total User, Total Scan.
/// (Tidak termasuk "Scan Hari Ini" / "Tanaman Baru" — tidak ada di DATABASE_SPEC)
///
/// Phase 7: data dari AdminProvider via query SQLite.
/// Phase 2: dummy data.
///
/// Referensi: UI_GUIDELINE.md — Admin Dashboard, DATABASE_SPEC.md
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  // ─── Phase 2 Dummy Data ────────────────────────────────────────────────────
  static const _dummyAdminName = 'Admin';
  static const _dummyTotalPlants = '24';
  static const _dummyTotalUsers = '152';
  static const _dummyTotalScans = '1.240';
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        automaticallyImplyLeading: false,
        actions: [
          // Logout shortcut
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _onLogout(context),
            tooltip: 'Keluar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome Banner ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang, $_dummyAdminName',
                    style: AppTypography.headingMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kelola data tanaman dan pengguna aplikasi Plantify.PNP.',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Summary Cards ────────────────────────────────────────────
            Text(
              'Ringkasan',
              style: AppTypography.headingMedium.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AdminSummaryCard(
                    icon: Icons.eco_rounded,
                    label: 'Total Tanaman',
                    value: _dummyTotalPlants,
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AdminSummaryCard(
                    icon: Icons.group_rounded,
                    label: 'Total User',
                    value: _dummyTotalUsers,
                    iconColor: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AdminSummaryCard(
              icon: Icons.qr_code_scanner_rounded,
              label: 'Total Scan',
              value: _dummyTotalScans,
              iconColor: AppColors.info,
            ),
            const SizedBox(height: 24),

            // ── Menu Kelola ───────────────────────────────────────────────
            Text(
              'Menu Kelola',
              style: AppTypography.headingMedium.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),
            AdminMenuCard(
              icon: Icons.eco_rounded,
              title: 'Kelola Tanaman',
              subtitle: 'Tambah, edit, dan hapus data tanaman',
              onTap: () => Navigator.pushNamed(
                context,
                RouteConstants.managePlants,
              ),
            ),
            const SizedBox(height: 10),
            AdminMenuCard(
              icon: Icons.manage_accounts_rounded,
              title: 'Kelola Pengguna',
              subtitle: 'Aktivasi dan monitoring akun pengguna',
              onTap: () => Navigator.pushNamed(
                context,
                RouteConstants.manageUsers,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _onLogout(BuildContext context) {
    // Phase 5: ganti dengan AuthProvider.logout()
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteConstants.login,
      (_) => false,
    );
  }
}
