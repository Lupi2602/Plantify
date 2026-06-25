import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/features/dashboard/screens/dashboard_screen.dart';
import 'package:plantify_pnp/features/history/screens/history_screen.dart';
import 'package:plantify_pnp/features/profile/screens/profile_screen.dart';
import 'package:plantify_pnp/features/scan/screens/scan_screen.dart';

/// Scaffold utama untuk alur pengguna (User).
///
/// Mengelola Bottom Navigation 4 tab (Home, Scan, History, Profil)
/// menggunakan [IndexedStack] agar state masing-masing tab tetap terjaga.
///
/// Admin TIDAK menggunakan widget ini. Admin memiliki portal terpisah.
/// Referensi: UI_GUIDELINE.md — User Bottom Navigation, PROJECT_CONTEXT.md
class MainScaffold extends StatefulWidget {
  /// Tab index awal. Default 0 (Dashboard).
  final int initialIndex;

  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Outer scaffold hanya menyediakan BottomNavigationBar.
      // Masing-masing screen di bawah memiliki AppBar-nya sendiri.
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DashboardScreen(),
          ScanScreen(),
          HistoryScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt_rounded),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
