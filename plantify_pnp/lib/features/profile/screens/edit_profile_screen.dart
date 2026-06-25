import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/app_text_field.dart';
import 'package:plantify_pnp/shared/widgets/error_state_widget.dart';

/// Halaman edit profil pengguna.
///
/// Scope: User hanya dapat mengubah Nama Lengkap.
/// Email dan Password tidak dapat diubah di fase awal ini.
///
/// Phase 5: data disimpan ke tabel users via AuthProvider.
/// Phase 2: dummy update + snackbar konfirmasi.
///
/// Referensi: UI_GUIDELINE.md — Edit Profile Scope, DATABASE_SPEC.md — users table
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  bool _isLoading = false;

  // Phase 5: inisialisasi dari AuthProvider (data session user)
  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: 'Budi Santoso');
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Phase 5: ganti dengan AuthProvider.updateName()
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ErrorStateWidget.showSuccess(context, 'Profil berhasil diperbarui');
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Avatar (read-only di fase ini)
              CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.primaryLight.withAlpha(40),
                child: const Icon(
                  Icons.person_rounded,
                  size: 44,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),

              // ── Nama Field (Editable) ─────────────────────────────────
              AppTextField(
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap',
                controller: _namaController,
                prefixIcon: Icons.person_outlined,
                isRequired: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSave(),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  if (v.trim().length < 3) return 'Nama minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Email (Read-only) ─────────────────────────────────────
              AppTextField(
                label: 'Email',
                hint: 'budi@example.com',
                controller: TextEditingController(text: 'budi@example.com'),
                prefixIcon: Icons.email_outlined,
                readOnly: true,
              ),
              const SizedBox(height: 8),
              Text(
                'Email tidak dapat diubah',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textHint,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 40),

              // Save Button
              AppButton(
                label: 'Simpan Perubahan',
                onPressed: _onSave,
                isLoading: _isLoading,
                leadingIcon: Icons.save_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
