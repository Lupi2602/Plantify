import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantify_pnp/core/constants/app_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/features/admin/providers/admin_provider.dart';
import 'package:plantify_pnp/features/admin/widgets/user_list_item.dart';
import 'package:plantify_pnp/features/auth/models/user_model.dart';
import 'package:plantify_pnp/features/auth/providers/auth_provider.dart';
import 'package:plantify_pnp/shared/widgets/empty_state_widget.dart';
import 'package:plantify_pnp/shared/widgets/error_state_widget.dart';

/// Halaman kelola pengguna untuk Admin.
///
/// Menampilkan daftar seluruh user dengan status dan role dari SQLite.
/// Actions:
/// - Aktifkan: set status = 1 di tabel users
/// - Nonaktifkan: set status = 0 di tabel users
///
/// Admin TIDAK DAPAT menghapus user. (UI_GUIDELINE.md — Admin tidak dapat menghapus user)
/// Menerapkan Self Lock Protection (admin tidak bisa me-nonaktifkan diri sendiri)
/// dan Admin Shield (akun role admin tidak dapat dinonaktifkan).
///
/// Referensi: UI_GUIDELINE.md — Manage Users Screen, DATABASE_SPEC.md — users table
class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AdminProvider>().loadAllUsers();
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {}); // Rebuild agar tombol clear (icon X) muncul/hilang
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: AppConstants.searchDebounceMs),
      () {
        if (mounted) {
          context.read<AdminProvider>().searchUsers(value);
        }
      },
    );
  }

  void _onToggleActive(UserModel user) {
    final currentAdminId = context.read<AuthProvider>().currentUser?.id ?? -1;

    // 1. UI Level Self Lock Protection
    if (user.id == currentAdminId) {
      ErrorStateWidget.showWarning(context, 'Anda tidak dapat menonaktifkan akun Anda sendiri.');
      return;
    }

    // 2. UI Level Admin Shield
    if (user.isAdmin) {
      ErrorStateWidget.showWarning(context, 'Akun Administrator tidak dapat dinonaktifkan.');
      return;
    }

    final isCurrentlyActive = user.isActive;
    final action = isCurrentlyActive ? 'nonaktifkan' : 'aktifkan';
    final actionLabel = isCurrentlyActive ? 'Nonaktifkan' : 'Aktifkan';

    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$actionLabel Pengguna'),
        content: Text(
          'Yakin ingin $action akun "${user.nama}"?\n\n'
          '${isCurrentlyActive ? 'Pengguna tidak akan dapat login sampai diaktifkan kembali.' : 'Pengguna akan dapat login kembali.'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              actionLabel,
              style: TextStyle(
                color: isCurrentlyActive ? AppColors.error : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true && mounted) {
        final provider = context.read<AdminProvider>();
        final success = await provider.toggleUserStatus(user.id!, currentAdminId);
        if (mounted) {
          if (success) {
            final successMsg = isCurrentlyActive
                ? '${user.nama} berhasil dinonaktifkan'
                : '${user.nama} berhasil diaktifkan';
            ErrorStateWidget.showSuccess(context, successMsg);
          } else if (provider.errorMessage != null) {
            ErrorStateWidget.showError(context, provider.errorMessage!);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProvider>();
    final filtered = provider.displayUsers;
    final currentAdminId = context.select<AuthProvider, int?>((auth) => auth.currentUser?.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Kelola Pengguna')),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari nama atau email...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),

          // ── User Count ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                Text(
                  '${filtered.length} pengguna',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textHint,
                      ),
                ),
              ],
            ),
          ),

          // ── User List ───────────────────────────────────────────────────
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage != null && provider.users.isEmpty
                    ? ErrorStateWidget(
                        message: provider.errorMessage!,
                        onRetry: () => provider.loadAllUsers(),
                      )
                    : filtered.isEmpty
                        ? provider.searchQuery.isNotEmpty
                            ? EmptyStateWidget(
                                icon: Icons.search_off_rounded,
                                title: 'Pengguna Tidak Ditemukan',
                                message:
                                    'Tidak ada pengguna yang cocok dengan kata kunci "${provider.searchQuery}".',
                                actionLabel: 'Reset Pencarian',
                                onAction: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : const EmptyStateWidget(
                                icon: Icons.group_outlined,
                                title: 'Belum Ada Pengguna',
                                message: 'Belum ada pengguna terdaftar di dalam sistem.',
                              )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final user = filtered[index];
                              final isSelf = user.id == currentAdminId;
                              final canToggle = !user.isAdmin && !isSelf;
                              return UserListItem(
                                nama: user.nama,
                                email: user.email,
                                role: user.role,
                                isActive: user.isActive,
                                onToggleActive: canToggle
                                    ? () => _onToggleActive(user)
                                    : null,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
