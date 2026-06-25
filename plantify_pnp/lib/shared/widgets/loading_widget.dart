import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';

/// Widget loading state yang digunakan di seluruh halaman Plantify.PNP.
///
/// Mendukung dua mode:
/// - Inline: ditampilkan di tengah container parent (default)
/// - Full screen: menampilkan loading overlay di atas Scaffold
///
/// Referensi: UI_GUIDELINE.md — Loading State (CircularProgressIndicator)
class LoadingWidget extends StatelessWidget {
  final String? message;

  /// Jika true, widget mengambil seluruh layar dengan Scaffold.
  final bool fullScreen;

  const LoadingWidget({
    super.key,
    this.message,
    this.fullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          strokeWidth: 3,
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (fullScreen) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: content),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: content,
      ),
    );
  }
}
