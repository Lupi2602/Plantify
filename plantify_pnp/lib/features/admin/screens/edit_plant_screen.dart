import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/features/plant/constants/plant_constants.dart';
import 'package:plantify_pnp/features/plant/models/plant_model.dart';
import 'package:plantify_pnp/features/plant/providers/plant_provider.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/app_text_field.dart';
import 'package:plantify_pnp/shared/widgets/plant_image_widget.dart';
import 'package:plantify_pnp/core/utils/timestamp_helper.dart';

/// Halaman edit tanaman (Admin).
///
/// Menerima [PlantModel] sebagai argumen initial data untuk render instant.
/// Terhubung ke [PlantProvider.updatePlant] dan [PlantStorageService] dengan atomic replace flow.
class EditPlantScreen extends StatefulWidget {
  final PlantModel plant;

  const EditPlantScreen({super.key, required this.plant});

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _deskripsiController;
  late final TextEditingController _manfaatController;
  late final TextEditingController _labelModelController;

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.plant.namaTanaman);
    _deskripsiController = TextEditingController(text: widget.plant.deskripsi);
    _manfaatController = TextEditingController(text: widget.plant.manfaat);
    _labelModelController = TextEditingController(text: widget.plant.labelModel);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _manfaatController.dispose();
    _labelModelController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isPermanentlyDenied) {
        if (!mounted) return;
        _showPermissionDialog();
        return;
      }
      if (!status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin kamera diperlukan untuk mengambil foto tanaman.'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: PlantConstants.imageMaxWidth,
        maxHeight: PlantConstants.imageMaxHeight,
        imageQuality: PlantConstants.imageQuality,
      );
      if (file != null && mounted) {
        setState(() {
          _pickedImage = File(file.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Izin Kamera Ditolak'),
        content: const Text(
          'Akses kamera telah ditolak secara permanen. Silakan aktifkan izin kamera di Pengaturan Aplikasi untuk mengambil foto tanaman.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  void _showPickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
              title: const Text('Ambil dari Kamera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<PlantProvider>();
    if (provider.isLoading) return; // Cegah double submit

    final updatedPlant = widget.plant.copyWith(
      namaTanaman: _namaController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
      manfaat: _manfaatController.text.trim(),
      labelModel: _labelModelController.text.trim(),
      updatedAt: TimestampHelper.currentTimestamp(),
    );

    final success = await provider.updatePlant(updatedPlant, newImageFile: _pickedImage);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(PlantConstants.updateSuccessMessage),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context);
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlantProvider>();
    final isLoading = provider.isLoading;

    return PopScope(
      canPop: !isLoading,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Edit Tanaman'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save_rounded),
              onPressed: isLoading ? null : _onSave,
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
                // ── Image Picker Area (Phase 6C) ──────────────────────────
                _buildImagePickerArea(),
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
                    if (v.trim().length < 3) {
                      return 'Nama tanaman minimal 3 karakter';
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
                AppTextField(
                  label: 'Label Model',
                  hint: 'Contoh: lidah_mertua',
                  controller: _labelModelController,
                  prefixIcon: Icons.label_outlined,
                  isRequired: true,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Label model tidak boleh kosong';
                    }
                    final snakeCaseRegex = RegExp(r'^[a-z0-9]+(_[a-z0-9]+)*$');
                    if (!snakeCaseRegex.hasMatch(v.trim())) {
                      return 'Label harus format snake_case huruf kecil (contoh: sirih_hijau)';
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
                  label: 'Simpan Perubahan',
                  onPressed: isLoading ? null : _onSave,
                  isLoading: isLoading,
                  leadingIcon: Icons.save_rounded,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
            children: const [
              TextSpan(text: 'Foto Tanaman'),
              TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _showPickerModal,
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _pickedImage != null
                      ? Image.file(_pickedImage!, fit: BoxFit.cover)
                      : PlantImageWidget(imagePath: widget.plant.gambar, fit: BoxFit.cover),
                  Container(color: Colors.black26),
                  const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_rounded, color: Colors.white, size: 32),
                        SizedBox(height: 4),
                        Text(
                          'Ganti Foto Tanaman',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
