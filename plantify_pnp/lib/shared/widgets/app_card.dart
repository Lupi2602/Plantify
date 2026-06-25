import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';

/// Reusable card widget berbasis Material 3 Card untuk seluruh halaman Plantify.PNP.
///
/// Mendukung onTap untuk membuat card interaktif dengan InkWell ripple effect.
///
/// Referensi: UI_GUIDELINE.md — Border Radius Card: 20, Elevation: subtle
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? elevation;
  final Color? backgroundColor;

  /// Border radius card. Default: 20 sesuai UI_GUIDELINE.md.
  final double borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevation,
    this.backgroundColor,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return Card(
      elevation: elevation ?? 2,
      color: backgroundColor ?? AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
