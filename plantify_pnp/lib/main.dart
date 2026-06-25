import 'package:flutter/material.dart';
import 'package:plantify_pnp/app/app.dart';

/// Entry point aplikasi Plantify.PNP.
///
/// [WidgetsFlutterBinding.ensureInitialized] diperlukan untuk inisialisasi
/// async sebelum runApp, misalnya SharedPreferences dan SQLite.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PlantifyApp());
}
