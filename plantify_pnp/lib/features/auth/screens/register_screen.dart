import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/features/auth/providers/auth_provider.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/app_text_field.dart';

/// Halaman registrasi akun baru.
///
/// Field: Nama Lengkap, Email, Password, Konfirmasi Password
/// Data disimpan ke tabel users di SQLite via [AuthProvider].
///
/// Referensi: UI_GUIDELINE.md — Register Screen, DATABASE_SPEC.md — users table
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      _namaController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akun berhasil dibuat! Silakan masuk.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Gagal mendaftar'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Title
                  Text('Buat Akun Baru', style: AppTypography.headingLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Daftar untuk mulai mengidentifikasi tanaman',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 32),

                  // Nama Field
                  AppTextField(
                    label: 'Nama Lengkap',
                    hint: 'Contoh: Budi Santoso',
                    controller: _namaController,
                    prefixIcon: Icons.person_outlined,
                    isRequired: true,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      if (v.trim().length < 3) return 'Nama minimal 3 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  AppTextField(
                    label: 'Email',
                    hint: 'contoh@email.com',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    isRequired: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
                      if (!v.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  AppTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outlined,
                    isPassword: true,
                    isRequired: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
                      if (v.length < 6) return 'Password minimal 6 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  AppTextField(
                    label: 'Konfirmasi Password',
                    hint: '••••••••',
                    controller: _confirmPasswordController,
                    prefixIcon: Icons.shield_outlined,
                    isPassword: true,
                    isRequired: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onRegister(),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Konfirmasi password tidak boleh kosong';
                      }
                      if (v != _passwordController.text) {
                        return 'Password tidak cocok';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Register Button
                  AppButton(
                    label: 'Daftar',
                    onPressed: _onRegister,
                    isLoading: _isLoading,
                    leadingIcon: Icons.person_add_rounded,
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          style: AppTypography.bodyText,
                          children: [
                            const TextSpan(
                              text: 'Sudah punya akun? ',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            TextSpan(
                              text: 'Masuk',
                              style: AppTypography.bodyText.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
