import 'package:flutter/material.dart';
import 'package:plantify_pnp/app/app.dart';
import 'package:plantify_pnp/core/database/database_helper.dart';

/// Entry point aplikasi Plantify.PNP.
///
/// [WidgetsFlutterBinding.ensureInitialized] diperlukan untuk inisialisasi
/// async sebelum runApp, misalnya SharedPreferences dan SQLite.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const PlantifyApp());
}
