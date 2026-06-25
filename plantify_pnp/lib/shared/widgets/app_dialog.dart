import 'package:flutter/material.dart';
import 'package:plantify_pnp/shared/widgets/app_button.dart';

/// Reusable confirmation/alert dialog untuk seluruh halaman Plantify.PNP.
///
/// Mendukung:
/// - Dialog konfirmasi (dengan cancel button)
/// - Dialog informasi (tanpa cancel button)
/// - Dialog destruktif (isDangerous: true — untuk delete action)
///
/// Gunakan [AppDialog.show] sebagai static helper untuk kemudahan penggunaan.
///
/// Referensi: UI_GUIDELINE.md — Error State (Dialog)
class AppDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;

  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.confirmLabel = 'OK',
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
  });

  /// Menampilkan dialog dan mengembalikan [true] jika user mengkonfirmasi,
  /// [false] jika user membatalkan, atau [null] jika dialog ditutup.
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    String confirmLabel = 'OK',
    String? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDangerous: isDangerous,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content ?? (message != null ? Text(message!) : null),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        if (cancelLabel != null)
          AppButton(
            label: cancelLabel!,
            variant: AppButtonVariant.outlined,
            isFullWidth: false,
            width: 100,
            height: 40,
            onPressed: () {
              onCancel?.call();
              Navigator.of(context).pop(false);
            },
          ),
        const SizedBox(width: 8),
        AppButton(
          label: confirmLabel,
          variant: AppButtonVariant.primary,
          isFullWidth: false,
          width: 100,
          height: 40,
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
