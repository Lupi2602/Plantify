import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/features/auth/providers/auth_provider.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/app_text_field.dart';
import 'package:plantify_pnp/shared/widgets/error_state_widget.dart';

/// Halaman edit profil pengguna.
///
/// Scope: User hanya dapat mengubah Nama Lengkap.
/// Data disimpan ke tabel users via [AuthProvider].
///
/// Referensi: UI_GUIDELINE.md — Edit Profile Scope, DATABASE_SPEC.md — users table
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _namaController = TextEditingController(text: user?.nama ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.updateName(_namaController.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ErrorStateWidget.showSuccess(context, 'Profil berhasil diperbarui');
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Gagal memperbarui profil'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
                hint: _emailController.text,
                controller: _emailController,
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
