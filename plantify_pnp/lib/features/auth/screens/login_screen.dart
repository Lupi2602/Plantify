import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';
import 'package:plantify_pnp/shared/widgets/app_text_field.dart';

/// Halaman login untuk User dan Admin.
///
/// Field: Email, Password
/// Action: Login → (Phase 5) validasi ke SQLite, cek role, cek status akun
///
/// Referensi: UI_GUIDELINE.md — Login Screen, DATABASE_SPEC.md — users table
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Phase 3 Dummy Accounts (hapus di Phase 5) ───────────────────────────
  // Admin: admin@plantify.local
  // User : semua email selain akun admin di atas
  static const _dummyAdminEmail = 'admin@plantify.local';
  // ─────────────────────────────────────────────────────────────────────────

  // Phase 5: ganti seluruh method ini dengan AuthProvider.login()
  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Simulasi Phase 3: role-based redirect berdasarkan email dummy.
      // Phase 5: logika ini diganti dengan AuthProvider.login() + SQLite.
      final isAdmin = _emailController.text.trim() == _dummyAdminEmail;
      if (isAdmin) {
        Navigator.pushReplacementNamed(context, RouteConstants.adminDashboard);
      } else {
        Navigator.pushReplacementNamed(context, RouteConstants.dashboard);
      }
    });
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
