import 'package:flutter/material.dart';

/// Varian tampilan AppButton.
enum AppButtonVariant {
  /// Tombol utama dengan background warna primary.
  primary,

  /// Tombol sekunder dengan border warna primary, background transparan.
  outlined,

  /// Tombol teks tanpa border dan background.
  text,
}

/// Reusable button widget untuk seluruh halaman Plantify.PNP.
///
/// Mendukung loading state, leading icon, dan tiga varian tampilan.
/// Minimum touch target: 48dp sesuai UI_GUIDELINE.md — Accessibility Rules.
///
/// Referensi: UI_GUIDELINE.md — Accessibility Rules (min touch target 48dp)
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = WidgetStateProperty.all<Size>(
      Size(isFullWidth ? double.infinity : (width ?? 0), height),
    );

    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom().copyWith(
            minimumSize: buttonSize,
          ),
          child: child,
        );

      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom().copyWith(
            minimumSize: buttonSize,
          ),
          child: child,
        );

      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
    }
  }
}
