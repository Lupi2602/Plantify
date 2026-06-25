import 'package:flutter/material.dart';

/// Sistem warna resmi Plantify.PNP.
///
/// Referensi: UI_GUIDELINE.md — Color System
class AppColors {
  AppColors._();

  // ─── Primary — Nature Green ───────────────────────────────────────────────────
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);

  // ─── Secondary — Light Green ──────────────────────────────────────────────────
  static const Color secondary = Color(0xFF81C784);
  static const Color secondaryLight = Color(0xFFB2FAB4);
  static const Color secondaryDark = Color(0xFF519657);

  // ─── Background & Surface ─────────────────────────────────────────────────────
  /// Background halaman utama. Referensi: UI_GUIDELINE.md
  static const Color background = Color(0xFFFFFFFF);

  /// Surface untuk card, input field, dsb. Referensi: UI_GUIDELINE.md
  static const Color surface = Color(0xFFF8F9FA);

  /// Surface varian untuk aksen ringan (icon container, chip, dsb).
  static const Color surfaceVariant = Color(0xFFE8F5E9);

  // ─── Text ─────────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Feedback Colors ──────────────────────────────────────────────────────────
  /// Warna error. Referensi: UI_GUIDELINE.md
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFFEBEE);

  /// Warna success. Referensi: UI_GUIDELINE.md
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);

  /// Warna warning. Referensi: UI_GUIDELINE.md
  static const Color warning = Color(0xFFFFA000);
  static const Color warningLight = Color(0xFFFFF8E1);

  /// Warna informasi (biru). Digunakan untuk aksen netral pada UI admin.
  static const Color info = Color(0xFF1565C0);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ─── Border & Divider ─────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFBDBDBD);

  // ─── Card ─────────────────────────────────────────────────────────────────────
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ─── Confidence Score Colors ──────────────────────────────────────────────────
  /// Digunakan untuk menampilkan warna confidence score pada Result Screen.
  static const Color confidenceHigh = Color(0xFF2E7D32);   // >= 80%
  static const Color confidenceMedium = Color(0xFFFFA000); // 70% - 79%
  // Confidence < 70% tidak ditampilkan (Tanaman Tidak Dikenali)

  /// Menentukan warna confidence score berdasarkan nilai (0.0 - 1.0).
  static Color getConfidenceColor(double confidence) {
    if (confidence >= 0.80) return confidenceHigh;
    if (confidence >= 0.70) return confidenceMedium;
    return error; // Tidak seharusnya ditampilkan karena di bawah threshold
  }
}
