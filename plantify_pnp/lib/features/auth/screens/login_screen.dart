import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/features/auth/providers/auth_provider.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/app_text_field.dart';

/// Halaman login untuk User dan Admin.
///
/// Field: Email, Password
/// Action: Login → validasi ke SQLite melalui [AuthProvider], simpan sesi, cek role
///
/// Referensi: UI_GUIDELINE.md — Login Screen, DATABASE_SPEC.md — users table
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      final role = authProvider.currentUser?.role;
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, RouteConstants.adminDashboard);
      } else {
        Navigator.pushReplacementNamed(context, RouteConstants.dashboard);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Gagal masuk'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Banner ─────────────────────────────────────────────
              Container(
                width: double.infinity,
                height: 220,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.eco_rounded,
                    size: 80,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),

              // ── Form Area ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text('Selamat Datang', style: AppTypography.headingLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Masuk untuk mengidentifikasi tanaman',
                        style: AppTypography.caption,
                      ),
                      const SizedBox(height: 32),

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
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _onLogin(),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
                          if (v.length < 6) return 'Password minimal 6 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Login Button
                      AppButton(
                        label: 'Masuk',
                        onPressed: _onLogin,
                        isLoading: _isLoading,
                        leadingIcon: Icons.login_rounded,
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.divider)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('atau', style: AppTypography.caption),
                          ),
                          const Expanded(child: Divider(color: AppColors.divider)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Register Link
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            RouteConstants.register,
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: AppTypography.bodyText,
                              children: [
                                const TextSpan(
                                  text: 'Belum punya akun? ',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                                TextSpan(
                                  text: 'Daftar',
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
