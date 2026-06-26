import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantify_pnp/app/app_router.dart';
import 'package:plantify_pnp/app/app_theme.dart';
import 'package:plantify_pnp/core/constants/app_constants.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/features/auth/providers/auth_provider.dart';

/// Root widget aplikasi Plantify.PNP.
///
/// Mengkonfigurasi:
/// - Material 3 Theme (AppTheme.lightTheme)
/// - Named Routes (AppRouter.generateRoute)
/// - Global State Management (Provider)
///
/// Penambahan provider per phase:
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: RouteConstants.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
