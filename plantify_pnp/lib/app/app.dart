import 'package:flutter/material.dart';
import 'package:plantify_pnp/app/app_router.dart';
import 'package:plantify_pnp/app/app_theme.dart';
import 'package:plantify_pnp/core/constants/app_constants.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';

/// Root widget aplikasi Plantify.PNP.
///
/// Mengkonfigurasi:
/// - Material 3 Theme (AppTheme.lightTheme)
/// - Named Routes (AppRouter.generateRoute)
///
/// State Management (Provider) akan ditambahkan bertahap mulai Phase 5.
/// MultiProvider TIDAK digunakan selama providers masih kosong karena
/// akan menyebabkan assertion error: children.isNotEmpty is not true.
///
/// Rencana penambahan provider per phase:
/// - Phase 5: AuthProvider
/// - Phase 6: PlantProvider (direuse oleh Admin Plant Management)
/// - Phase 7: AdminProvider
/// - Phase 8: HistoryProvider
/// - Phase 9: ScanProvider
///
/// Referensi: FLUTTER_ARCHITECTURE.md — App Layer, State Management
class PlantifyApp extends StatelessWidget {
  const PlantifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: RouteConstants.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
