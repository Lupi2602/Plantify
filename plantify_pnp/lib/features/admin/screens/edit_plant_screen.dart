import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/app_text_field.dart';
import 'package:plantify_pnp/shared/widgets/error_state_widget.dart';

/// Halaman edit tanaman (Admin).
///
/// Struktur identik dengan AddPlantScreen, namun field sudah terisi
/// dengan data tanaman yang dipilih.
///
/// Phase 6: data di-load dari PlantRepository via argument (plantId).
/// Phase 2: dummy data pra-isi.
///
/// Referensi: UI_GUIDELINE.md — Edit Plant Screen, DATABASE_SPEC.md — tanaman table
class EditPlantScreen extends StatefulWidget {
  const EditPlantScreen({super.key});

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _deskripsiController;
  late final TextEditingController _manfaatController;
  late final TextEditingController _labelModelController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Phase 6: ganti dengan data dari PlantRepository.getById(plantId)
    _namaController = TextEditingController(text: 'Sirih Hijau');
    _deskripsiController = TextEditingController(
      text: 'Sirih hijau adalah tanaman merambat dari keluarga Piperaceae.',
    );
    _manfaatController = TextEditingController(
      text: 'Antiseptik alami, obat kumur tradisional, antioksidan tinggi.',
    );
    _labelModelController = TextEditingController(text: 'sirih_hijau');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _manfaatController.dispose();
    _labelModelController.dispose();
    super.dispose();
  }

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

    // Phase 6: ganti dengan PlantRepository.update()
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ErrorStateWidget.showSuccess(context, 'Tanaman berhasil diperbarui');
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Tanaman'),
        actions: [
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
              // ── Image Area ────────────────────────────────────────────
              GestureDetector(
                onTap: _onPickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 8),
                      Text('Ganti Foto Tanaman', style: AppTypography.caption),
                      const SizedBox(height: 4),
                      Text(
                        'Ketuk untuk memilih gambar baru',
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
                hint: 'Nama tanaman',
                controller: _namaController,
                prefixIcon: Icons.eco_outlined,
                isRequired: true,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 14),

              // ── Deskripsi ─────────────────────────────────────────────
              _buildMultilineField(
                label: 'Deskripsi',
                hint: 'Deskripsi tanaman...',
                controller: _deskripsiController,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Deskripsi tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 14),

              // ── Manfaat ───────────────────────────────────────────────
              _buildMultilineField(
                label: 'Manfaat',
                hint: 'Manfaat tanaman...',
                controller: _manfaatController,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Manfaat tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 14),

              // ── Label Model ───────────────────────────────────────────
              AppTextField(
                label: 'Label Model',
                hint: 'Contoh: sirih_hijau',
                controller: _labelModelController,
                prefixIcon: Icons.label_outlined,
                isRequired: true,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Label tidak boleh kosong';
                  if (v.contains(' ')) return 'Gunakan underscore, bukan spasi';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save Button
              AppButton(
                label: 'Simpan Perubahan',
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
