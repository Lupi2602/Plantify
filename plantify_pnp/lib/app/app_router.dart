import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/features/admin/screens/add_plant_screen.dart';
import 'package:plantify_pnp/features/admin/screens/admin_dashboard_screen.dart';
import 'package:plantify_pnp/features/admin/screens/edit_plant_screen.dart';
import 'package:plantify_pnp/features/admin/screens/manage_plant_screen.dart';
import 'package:plantify_pnp/features/admin/screens/manage_user_screen.dart';
import 'package:plantify_pnp/features/auth/screens/login_screen.dart';
import 'package:plantify_pnp/features/auth/screens/register_screen.dart';
import 'package:plantify_pnp/features/auth/screens/splash_screen.dart';
import 'package:plantify_pnp/features/plant/models/plant_model.dart';
import 'package:plantify_pnp/features/plant/screens/plant_detail_screen.dart';
import 'package:plantify_pnp/features/profile/screens/edit_profile_screen.dart';
import 'package:plantify_pnp/features/scan/screens/result_screen.dart';
import 'package:plantify_pnp/shared/widgets/main_scaffold.dart';

/// Router terpusat untuk seluruh navigasi Plantify.PNP.
///
/// Menggunakan Named Routes dengan [onGenerateRoute] sehingga setiap
/// route dapat menerima argument via [RouteSettings.arguments].
///
/// Struktur navigasi:
/// - Auth flow: /splash → /login → /register
/// - User flow: /dashboard (MainScaffold) → /result → /plant-detail → /edit-profile
/// - Admin flow: /admin-dashboard → /manage-plants → /add-plant / /edit-plant → /manage-users
///
/// Referensi: FLUTTER_ARCHITECTURE.md — Routes, Navigation
class AppRouter {
  AppRouter._();

  /// Generate route berdasarkan [RouteSettings.name].
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      // ─── Auth ──────────────────────────────────────────────────────────────
      case RouteConstants.splash:
        return _buildRoute(settings, const SplashScreen());

      case RouteConstants.login:
        return _buildRoute(settings, const LoginScreen());

      case RouteConstants.register:
        return _buildRoute(settings, const RegisterScreen());

      // ─── User — Main Scaffold (Bottom Navigation) ──────────────────────────
      // /dashboard selalu masuk ke tab Home (index 0).
      case RouteConstants.dashboard:
        return _buildRoute(settings, const MainScaffold(initialIndex: 0));

      // /scan, /history, /profile sebagai route mandiri.
      // Phase 3: tambahkan kemampuan deep-link ke tab tertentu via MainScaffold.
      case RouteConstants.scan:
        return _buildRoute(settings, const MainScaffold(initialIndex: 1));

      case RouteConstants.history:
        return _buildRoute(settings, const MainScaffold(initialIndex: 2));

      case RouteConstants.profile:
        return _buildRoute(settings, const MainScaffold(initialIndex: 3));

      // ─── User — Pushed Screens ─────────────────────────────────────────────
      case RouteConstants.result:
        // arguments: int? historyId (Phase 8: load dari riwayat_scan)
        return _buildRoute(settings, const ResultScreen());

      case RouteConstants.plantDetail:
        // arguments: int? plantId (Phase 6: load dari tabel tanaman)
        return _buildRoute(settings, const PlantDetailScreen());

      case RouteConstants.editProfile:
        return _buildRoute(settings, const EditProfileScreen());

      // ─── Admin ─────────────────────────────────────────────────────────────
      case RouteConstants.adminDashboard:
        return _buildRoute(settings, const AdminDashboardScreen());

      case RouteConstants.managePlants:
        return _buildRoute(settings, const ManagePlantScreen());

      case RouteConstants.addPlant:
        return _buildRoute(settings, const AddPlantScreen());

      case RouteConstants.editPlant:
        final plant = settings.arguments as PlantModel?;
        if (plant == null) {
          return _buildRoute(
            settings,
            const _NotFoundScreen(
              routeName: '${RouteConstants.editPlant} (Argumen PlantModel kosong)',
            ),
          );
        }
        return _buildRoute(settings, EditPlantScreen(plant: plant));

      case RouteConstants.manageUsers:
        return _buildRoute(settings, const ManageUserScreen());

      // ─── Fallback ──────────────────────────────────────────────────────────
      default:
        return _buildRoute(
          settings,
          _NotFoundScreen(routeName: settings.name ?? 'unknown'),
        );
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => page,
    );
  }
}

/// Screen 404 untuk route yang tidak terdaftar.
class _NotFoundScreen extends StatelessWidget {
  final String routeName;

  const _NotFoundScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Halaman Tidak Ditemukan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Route "$routeName" tidak terdaftar.',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
