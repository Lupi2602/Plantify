import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/features/admin/widgets/user_list_item.dart';
import 'package:plantify_pnp/shared/widgets/empty_state_widget.dart';
import 'package:plantify_pnp/shared/widgets/error_state_widget.dart';

/// Halaman kelola pengguna untuk Admin.
///
/// Menampilkan daftar seluruh user dengan status dan role.
/// Actions:
/// - Aktifkan: set is_active = 1 di tabel users
/// - Nonaktifkan: set is_active = 0 di tabel users
///
/// Admin TIDAK DAPAT menghapus user. (UI_GUIDELINE.md — Admin tidak dapat menghapus user)
///
/// Phase 7: data dari AdminProvider via UserRepository.
/// Phase 2: dummy data.
///
/// Referensi: UI_GUIDELINE.md — Manage Users Screen, DATABASE_SPEC.md — users table
class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  final _searchController = TextEditingController();

  // ─── Phase 2 Dummy Data ────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'nama': 'Admin Plantify',
      'email': 'admin@plantify.pnp',
      'role': 'admin',
      'isActive': true,
    },
    {
      'id': 2,
      'nama': 'Budi Santoso',
      'email': 'budi@example.com',
      'role': 'user',
      'isActive': true,
    },
    {
      'id': 3,
      'nama': 'Lestari Putri',
      'email': 'lestari@gmail.com',
      'role': 'user',
      'isActive': true,
    },
    {
      'id': 4,
      'nama': 'Andi Wijaya',
      'email': 'andi@outlook.com',
      'role': 'user',
      'isActive': false,
    },
    {
      'id': 5,
      'nama': 'Siti Aminah',
      'email': 'siti@company.id',
      'role': 'user',
      'isActive': true,
    },
  ];
  // ─────────────────────────────────────────────────────────────────────────────

  List<Map<String, dynamic>> get _filtered {
    final q = _searchController.text.toLowerCase();
    if (q.isEmpty) return _users;
    return _users.where((u) {
      final nama = (u['nama'] as String).toLowerCase();
      final email = (u['email'] as String).toLowerCase();
      return nama.contains(q) || email.contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onToggleActive(int index, Map<String, dynamic> user) {
    final isCurrentlyActive = user['isActive'] as bool;
    final action = isCurrentlyActive ? 'nonaktifkan' : 'aktifkan';
    final actionLabel = isCurrentlyActive ? 'Nonaktifkan' : 'Aktifkan';

    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$actionLabel Pengguna'),
        content: Text(
          'Yakin ingin $action akun "${user['nama']}"?\n\n'
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
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        // Phase 7: ganti dengan UserRepository.setActiveStatus(id, !isActive)
        setState(() {
          _users[_users.indexWhere((u) => u['id'] == user['id'])]['isActive'] =
              !isCurrentlyActive;
        });
        final successMsg = isCurrentlyActive
            ? '${user['nama']} berhasil dinonaktifkan'
            : '${user['nama']} berhasil diaktifkan';
        ErrorStateWidget.showSuccess(context, successMsg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

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
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Cari nama atau email...',
                prefixIcon: Icon(Icons.search_rounded, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            child: filtered.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.group_outlined,
                    title: 'Tidak Ada Pengguna',
                    message: 'Tidak ditemukan pengguna yang sesuai pencarian.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final user = filtered[index];
                      // Cari index asli di _users untuk toggle
                      final originalIndex =
                          _users.indexWhere((u) => u['id'] == user['id']);
                      return UserListItem(
                        nama: user['nama'] as String,
                        email: user['email'] as String,
                        role: user['role'] as String,
                        isActive: user['isActive'] as bool,
                        onToggleActive: () =>
                            _onToggleActive(originalIndex, user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
