import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/app_text_field.dart';

/// Halaman registrasi akun baru.
///
/// Field: Nama Lengkap, Email, Password, Konfirmasi Password
/// Phase 5: data akan disimpan ke tabel users di SQLite dengan password ter-hash
///
/// Referensi: UI_GUIDELINE.md — Register Screen, DATABASE_SPEC.md — users table
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Phase 5: ganti dengan AuthProvider.register()
  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Simulasi Phase 2: kembali ke login setelah delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akun berhasil dibuat! Silakan masuk.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    });
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
