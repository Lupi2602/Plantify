import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';

/// Halaman profil pengguna.
///
/// Menampilkan: avatar placeholder, nama, email, role.
/// Actions: Edit Profil → EditProfileScreen, Logout → LoginScreen.
///
/// Yang TIDAK diimplementasikan (tidak ada di use case/DATABASE_SPEC):
/// - Foto avatar real (tidak ada kolom foto di tabel users)
/// - Total Scan / Favorit / Bergabung (tidak ada di DATABASE_SPEC)
/// - Menu Pengaturan, Bantuan, Tentang Aplikasi
///
/// Phase 5: data dari AuthProvider via SharedPreferences + SQLite query.
/// Phase 2: dummy data.
///
/// Referensi: UI_GUIDELINE.md — Profile Screen, DATABASE_SPEC.md — users table
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ─── Phase 2 Dummy Data ────────────────────────────────────────────────────
  static const _dummyName = 'Budi Santoso';
  static const _dummyEmail = 'budi@example.com';
  static const _dummyRole = 'user'; // 'user' atau 'admin'
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Header ───────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primaryLight.withAlpha(40),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 44,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    _dummyName,
                    style: AppTypography.headingMedium.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),

                  // Email
                  Text(
                    _dummyEmail,
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 12),

                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.primary.withAlpha(60)),
                    ),
                    child: Text(
                      _dummyRole == 'admin' ? 'Admin' : 'Pengguna',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Menu Items ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Edit Profil
                  _ProfileMenuItem(
                    icon: Icons.edit_outlined,
                    label: 'Edit Profil',
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteConstants.editProfile,
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.divider),

                  const SizedBox(height: 32),

                  // Logout Button
                  AppButton(
                    label: 'Keluar',
                    onPressed: () => _onLogout(context),
                    variant: AppButtonVariant.outlined,
                    leadingIcon: Icons.logout_rounded,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLogout(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        // Phase 5: ganti dengan AuthProvider.logout() + clear SharedPreferences
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteConstants.login,
          (_) => false,
        );
      }
    });
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(label, style: AppTypography.bodyText),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textHint,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}
