import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantify_pnp/core/constants/app_constants.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/features/auth/providers/auth_provider.dart';

/// Halaman pertama yang ditampilkan saat aplikasi dibuka.
///
/// Menampilkan logo, nama, dan tagline aplikasi selama [AppConstants.splashDurationSeconds]
/// kemudian menavigasi ke screen tujuan berdasarkan sesi aktif di SQLite & SharedPreferences.
///
/// Referensi: UI_GUIDELINE.md — Splash Screen, FLUTTER_ARCHITECTURE.md — Session Validation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();

    _initSplash();
  }

  void _initSplash() async {
    final authProvider = context.read<AuthProvider>();
    final results = await Future.wait([
      authProvider.checkSession(),
      Future.delayed(Duration(seconds: AppConstants.splashDurationSeconds)),
    ]);

    if (!mounted) return;

    final isLoggedIn = results[0] as bool;
    if (!isLoggedIn) {
      if (authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
      Navigator.pushReplacementNamed(context, RouteConstants.login);
    } else {
      final role = authProvider.currentUser?.role;
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, RouteConstants.adminDashboard);
      } else {
        Navigator.pushReplacementNamed(context, RouteConstants.dashboard);
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
            const Spacer(flex: 3),

            // Logo & Branding
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo Container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primaryLight.withAlpha(80),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        size: 52,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // App Name
                    Text(
                      AppConstants.appName,
                      style: AppTypography.headingLarge.copyWith(
                        color: AppColors.primary,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      AppConstants.appTagline,
                      style: AppTypography.caption.copyWith(
                        fontSize: 13,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Version
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'v${AppConstants.appVersion}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textHint,
                    fontSize: 11,
                  ),
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
