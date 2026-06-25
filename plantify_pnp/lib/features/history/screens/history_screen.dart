import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/features/history/widgets/history_item_card.dart';
import 'package:plantify_pnp/shared/widgets/empty_state_widget.dart';

/// Halaman riwayat identifikasi tanaman.
///
/// Menampilkan list riwayat dari tabel riwayat_scan.
/// Kolom: id, user_id, tanaman_id, nama_hasil, confidence, gambar_scan, created_at
///
/// Actions: tap item → detail, hapus item.
/// Phase 8: data dari HistoryProvider via HistoryRepository.
/// Phase 2: dummy data.
///
/// Referensi: UI_GUIDELINE.md — History Screen, Empty History State
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // ─── Phase 2 Dummy Data ────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _dummyHistory = [
    {
      'id': 1,
      'name': 'Sirih Hijau',
      'confidence': 0.953,
      'date': '24 Jun 2026, 14:20',
      'image': '',
    },
    {
      'id': 2,
      'name': 'Talas',
      'confidence': 0.821,
      'date': '23 Jun 2026, 09:15',
      'image': '',
    },
    {
      'id': 3,
      'name': 'Nangka',
      'confidence': 0.785,
      'date': '22 Jun 2026, 16:45',
      'image': '',
    },
  ];
  // ─────────────────────────────────────────────────────────────────────────────

  void _onDelete(int index) {
    // Phase 8: ganti dengan HistoryProvider.delete(id)
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Yakin ingin menghapus riwayat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        setState(() => _dummyHistory.removeAt(index));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Scan'),
        automaticallyImplyLeading: false,
      ),
      body: _dummyHistory.isEmpty
          ? EmptyStateWidget(
              icon: Icons.history_rounded,
              title: 'Belum Ada Riwayat',
              message: 'Riwayat scan Anda akan tersimpan otomatis setelah identifikasi berhasil.',
              actionLabel: 'Mulai Scan',
              onAction: () => Navigator.pushNamed(context, RouteConstants.scan),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _dummyHistory.length,
              itemBuilder: (context, index) {
                final item = _dummyHistory[index];
                return HistoryItemCard(
                  plantName: item['name'] as String,
                  imagePath: item['image'] as String,
                  confidence: item['confidence'] as double,
                  date: item['date'] as String,
                  onTap: () => Navigator.pushNamed(
                    context,
                    RouteConstants.result,
                    arguments: item['id'],
                  ),
                  onDelete: () => _onDelete(index),
                );
              },
            ),
    );
  }
}
