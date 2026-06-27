import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/features/admin/widgets/plant_list_item.dart';
import 'package:plantify_pnp/features/plant/constants/plant_constants.dart';
import 'package:plantify_pnp/features/plant/models/plant_model.dart';
import 'package:plantify_pnp/features/plant/providers/plant_provider.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/empty_state_widget.dart';
import 'package:plantify_pnp/shared/widgets/error_state_widget.dart';

/// Halaman kelola tanaman untuk Admin.
///
/// Menampilkan daftar tanaman dengan search bar reaktif (debounce 300ms) dan tombol tambah.
/// Actions: Add, Edit, Delete (terhubung ke PlantProvider).
///
/// Referensi: UI_GUIDELINE.md — Manage Plants Screen
class ManagePlantScreen extends StatefulWidget {
  const ManagePlantScreen({super.key});

  @override
  State<ManagePlantScreen> createState() => _ManagePlantScreenState();
}

class _ManagePlantScreenState extends State<ManagePlantScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      context.read<PlantProvider>().clearSearch();
      return;
    }
    _debounceTimer = Timer(
      const Duration(milliseconds: PlantConstants.searchDebounceMs),
      () {
        if (!mounted) return;
        context.read<PlantProvider>().searchPlants(query);
      },
    );
  }

  void _onClearSearch() {
    _debounceTimer?.cancel();
    _searchController.clear();
    context.read<PlantProvider>().clearSearch();
  }

  void _onDelete(PlantModel plant) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tanaman'),
        content: Text('Yakin ingin menghapus "${plant.namaTanaman}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true && mounted) {
        final plantId = plant.id;
        if (plantId == null) return;

        final provider = context.read<PlantProvider>();
        final success = await provider.deletePlant(plantId);
        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(PlantConstants.deleteSuccessMessage),
              backgroundColor: AppColors.primary,
            ),
          );
        } else if (provider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlantProvider>();
    final displayList = provider.displayPlants;

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
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Cari tanaman...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: _onClearSearch,
                            )
                          : null,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

          // Plant List & States
          Expanded(
            child: _buildBodyContent(provider, displayList),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(PlantProvider provider, List<PlantModel> displayList) {
    if (provider.isLoading && displayList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && displayList.isEmpty) {
      return ErrorStateWidget(
        message: provider.errorMessage!,
        onRetry: () => provider.loadAllPlants(),
      );
    }

    // Dual Empty States
    if (displayList.isEmpty) {
      if (provider.searchQuery.isNotEmpty) {
        // Kondisi 2: Hasil pencarian kosong
        return EmptyStateWidget(
          icon: Icons.search_off_rounded,
          title: 'Tanaman Tidak Ditemukan',
          message: "Tidak ada tanaman yang cocok dengan kata kunci '${provider.searchQuery}'.",
          actionLabel: 'Reset Pencarian',
          onAction: _onClearSearch,
        );
      } else {
        // Kondisi 1: Database kosong mutlak
        return EmptyStateWidget(
          icon: Icons.eco_rounded,
          title: 'Belum Ada Data Tanaman',
          message: 'Daftar tanaman masih kosong. Mulai tambahkan data tanaman pertama Anda.',
          actionLabel: '+ Tambah Tanaman',
          onAction: () => Navigator.pushNamed(context, RouteConstants.addPlant),
        );
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final plant = displayList[index];
        return PlantListItem(
          plantName: plant.namaTanaman,
          description: plant.deskripsi,
          imagePath: plant.gambar,
          onEdit: () => Navigator.pushNamed(
            context,
            RouteConstants.editPlant,
            arguments: plant,
          ),
          onDelete: () => _onDelete(plant),
        );
      },
    );
  }
}
