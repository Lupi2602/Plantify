import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';

/// Item list pengguna di halaman Kelola Pengguna (Admin).
///
/// Menampilkan: avatar initials, nama, email, role badge, dan tombol aksi.
/// Actions:
/// - Aktifkan → mengaktifkan akun user (is_active = 1)
/// - Nonaktifkan → menonaktifkan akun user (is_active = 0)
/// Admin TIDAK DAPAT menghapus user. Referensi: UI_GUIDELINE.md — Manage Users Screen
///
/// DATABASE_SPEC: kolom is_active pada tabel users (0 = nonaktif, 1 = aktif)
class UserListItem extends StatelessWidget {
  final String nama;
  final String email;
  final String role;
  final bool isActive;
  final VoidCallback? onToggleActive;

  const UserListItem({
    super.key,
    required this.nama,
    required this.email,
    required this.role,
    required this.isActive,
    this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'admin';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? AppColors.divider : AppColors.error.withAlpha(60),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // Avatar Initials
          CircleAvatar(
            radius: 22,
            backgroundColor: isAdmin
                ? AppColors.primary.withAlpha(25)
                : AppColors.primaryLight.withAlpha(40),
            child: Text(
              nama.isNotEmpty ? nama[0].toUpperCase() : '?',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        nama,
                        style: AppTypography.bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isAdmin
                            ? AppColors.primary.withAlpha(20)
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isAdmin
                              ? AppColors.primary.withAlpha(60)
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        role.toUpperCase(),
                        style: AppTypography.caption.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isAdmin
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: AppTypography.caption.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isActive) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Akun Nonaktif',
                    style: AppTypography.caption.copyWith(
                      fontSize: 10,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Toggle Action (hanya untuk role user, bukan admin)
          if (!isAdmin && onToggleActive != null)
            TextButton(
              onPressed: onToggleActive,
              style: TextButton.styleFrom(
                foregroundColor:
                    isActive ? AppColors.error : AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              child: Text(
                isActive ? 'Nonaktifkan' : 'Aktifkan',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: isActive ? AppColors.error : AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
