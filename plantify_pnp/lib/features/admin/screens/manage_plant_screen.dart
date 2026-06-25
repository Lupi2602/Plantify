import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/features/admin/widgets/plant_list_item.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/empty_state_widget.dart';
import 'package:plantify_pnp/shared/widgets/error_state_widget.dart';

/// Halaman kelola tanaman untuk Admin.
///
/// Menampilkan daftar tanaman dengan search bar dan FAB / tombol tambah.
/// Actions: Add, Edit, Delete.
///
/// Phase 6: data dari PlantProvider via PlantRepository.
/// Phase 2: dummy data.
///
/// Referensi: UI_GUIDELINE.md — Manage Plants Screen
class ManagePlantScreen extends StatefulWidget {
  const ManagePlantScreen({super.key});

  @override
  State<ManagePlantScreen> createState() => _ManagePlantScreenState();
}

class _ManagePlantScreenState extends State<ManagePlantScreen> {
  final _searchController = TextEditingController();

  // ─── Phase 2 Dummy Data ────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _plants = [
    {'id': 1, 'name': 'Sirih Hijau', 'desc': 'Tanaman obat tradisional dengan daun hijau mengkilap.', 'image': ''},
    {'id': 2, 'name': 'Talas', 'desc': 'Umbi dari keluarga Araceae yang banyak dimanfaatkan.', 'image': ''},
    {'id': 3, 'name': 'Nangka', 'desc': 'Pohon buah tropis besar dengan buah yang khas.', 'image': ''},
    {'id': 4, 'name': 'Markisa', 'desc': 'Tanaman merambat dengan buah asam manis yang menyegarkan.', 'image': ''},
  ];
  // ─────────────────────────────────────────────────────────────────────────────

  List<Map<String, dynamic>> get _filtered {
    final q = _searchController.text.toLowerCase();
    if (q.isEmpty) return _plants;
    return _plants.where((p) => (p['name'] as String).toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onDelete(Map<String, dynamic> plant) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tanaman'),
        content: Text('Yakin ingin menghapus "${plant['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        setState(() => _plants.removeWhere((p) => p['id'] == plant['id']));
        ErrorStateWidget.showSuccess(context, '${plant['name']} berhasil dihapus');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Kelola Tanaman')),
      body: Column(
        children: [
          // Search + Add Button Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Cari tanaman...',
                      prefixIcon: Icon(Icons.search_rounded, size: 20),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AppButton(
                  label: 'Tambah',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RouteConstants.addPlant,
                  ),
                  leadingIcon: Icons.add_rounded,
                  isFullWidth: false,
                  width: 110,
                ),
              ],
            ),
          ),

          // Plant List
          Expanded(
            child: filtered.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.eco_rounded,
                    title: 'Belum Ada Tanaman',
                    message: 'Tambahkan data tanaman untuk mulai mengelola.',
                    actionLabel: 'Tambah Tanaman',
                    onAction: () => Navigator.pushNamed(context, RouteConstants.addPlant),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final plant = filtered[index];
                      return PlantListItem(
                        plantName: plant['name'] as String,
                        description: plant['desc'] as String,
                        imagePath: plant['image'] as String,
                        onEdit: () => Navigator.pushNamed(
                          context,
                          RouteConstants.editPlant,
                          arguments: plant['id'],
                        ),
                        onDelete: () => _onDelete(plant),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
