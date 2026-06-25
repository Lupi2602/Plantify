import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/app_text_field.dart';
import 'package:plantify_pnp/shared/widgets/error_state_widget.dart';

/// Halaman tambah tanaman baru (Admin).
///
/// Fields sesuai tabel tanaman di DATABASE_SPEC:
/// - nama_tanaman (TEXT, required)
/// - deskripsi (TEXT, required)
/// - manfaat (TEXT, required)
/// - gambar (TEXT) — path gambar, dipilih via image_picker
/// - label_model (TEXT, required) — label CNN
///
/// Phase 6: data disimpan ke tabel tanaman via PlantRepository.
/// Phase 9: gambar disalin ke storage aplikasi.
/// Phase 2: dummy save + snackbar konfirmasi.
///
/// Referensi: UI_GUIDELINE.md — Add Plant Screen, DATABASE_SPEC.md — tanaman table
class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _manfaatController = TextEditingController();
  final _labelModelController = TextEditingController();
  bool _isLoading = false;
  String? _selectedImagePath; // Phase 9: isi dari image_picker

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _manfaatController.dispose();
    _labelModelController.dispose();
    super.dispose();
  }

  // Phase 9: ganti dengan image_picker + PlantStorageService
  void _onPickImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur upload gambar akan aktif pada Phase 9'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Phase 6: ganti dengan PlantRepository.insert()
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ErrorStateWidget.showSuccess(context, 'Tanaman berhasil ditambahkan');
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tambah Tanaman'),
        actions: [
          // Save via AppBar icon
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: _onSave,
            tooltip: 'Simpan',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image Upload Area ─────────────────────────────────────
              GestureDetector(
                onTap: _onPickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _selectedImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            _selectedImagePath!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_photo_alternate_rounded,
                              size: 48,
                              color: AppColors.textHint,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Upload Foto Tanaman',
                              style: AppTypography.caption,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ketuk untuk memilih gambar',
                              style: AppTypography.caption.copyWith(
                                fontSize: 11,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Nama Tanaman ──────────────────────────────────────────
              AppTextField(
                label: 'Nama Tanaman',
                hint: 'Contoh: Lidah Mertua',
                controller: _namaController,
                prefixIcon: Icons.eco_outlined,
                isRequired: true,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Nama tanaman tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // ── Deskripsi ─────────────────────────────────────────────
              _buildMultilineField(
                label: 'Deskripsi',
                hint: 'Jelaskan karakteristik tanaman ini...',
                controller: _deskripsiController,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // ── Manfaat ───────────────────────────────────────────────
              _buildMultilineField(
                label: 'Manfaat',
                hint: 'Apa kegunaan atau kelebihan tanaman ini?',
                controller: _manfaatController,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Manfaat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // ── Label Model ───────────────────────────────────────────
              // Label yang digunakan oleh model CNN untuk mengenali tanaman ini.
              // Referensi: DATABASE_SPEC.md — kolom label_model
              AppTextField(
                label: 'Label Model',
                hint: 'Contoh: sirih_hijau',
                controller: _labelModelController,
                prefixIcon: Icons.label_outlined,
                isRequired: true,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Label model tidak boleh kosong';
                  }
                  if (v.contains(' ')) {
                    return 'Label model tidak boleh mengandung spasi (gunakan _)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Label harus sama persis dengan nama kelas pada model CNN.\nContoh: sirih_hijau, talas, nangka',
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              AppButton(
                label: 'Simpan Tanaman',
                onPressed: _onSave,
                isLoading: _isLoading,
                leadingIcon: Icons.save_rounded,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultilineField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
            children: [
              TextSpan(text: label),
              const TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.error),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: 4,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
          style: AppTypography.bodyText,
        ),
      ],
    );
  }
}
