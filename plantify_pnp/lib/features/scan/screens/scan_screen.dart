import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';

/// Halaman scan tanaman.
///
/// Menampilkan UI kamera dan tombol aksi (Kamera & Galeri).
///
/// Phase 9: tombol Kamera & Galeri akan diintegrasikan dengan image_picker,
/// kemudian gambar diproses oleh TfliteService (Phase 10).
///
/// Untuk Phase 2 (UI demo): tombol langsung navigasi ke ResultScreen.
///
/// Referensi: UI_GUIDELINE.md — Scan Screen
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Scan Tanaman'),
        automaticallyImplyLeading: false,
        // Jika dibuka via route /scan (bukan tab), back button muncul otomatis
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Instruction ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Text(
                'Arahkan kamera ke daun tanaman atau pilih foto dari galeri untuk mengidentifikasi jenis tanaman.',
                style: AppTypography.bodyText.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // ── Camera Viewfinder ──────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Stack(
                    children: [
                      // Placeholder camera area
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.center_focus_strong_rounded,
                              size: 64,
                              color: AppColors.border,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Area kamera akan aktif\nsaat tombol ditekan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Corner Brackets Decoration
                      ..._buildCornerBrackets(),
                    ],
                  ),
                ),
              ),
            ),

            // ── Action Buttons ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Row(
                children: [
                  // Gallery Button
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.photo_library_rounded,
                      label: 'Galeri',
                      onTap: () => _onPickImage(context),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Capture Button
                  _CaptureButton(onTap: () => _onPickImage(context)),

                  const SizedBox(width: 16),

                  // Placeholder right side (balance layout)
                  const Expanded(
                    child: SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Phase 2: simulasi navigasi ke ResultScreen dengan dummy data.
  /// Phase 9: ganti dengan image_picker + TfliteService.
  void _onPickImage(BuildContext context) {
    Navigator.pushNamed(context, RouteConstants.result);
  }

  /// Corner bracket decorations untuk tampilan viewfinder.
  List<Widget> _buildCornerBrackets() {
    const double size = 24;
    const double thickness = 3;
    const color = AppColors.primary;
    const radius = 4.0;

    Widget bracket({
      required AlignmentGeometry alignment,
      required bool borderLeft,
      required bool borderRight,
      required bool borderTop,
      required bool borderBottom,
    }) {
      return Positioned.fill(
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _CornerBracketPainter(
                  color: color,
                  thickness: thickness,
                  radius: radius,
                  showLeft: borderLeft,
                  showRight: borderRight,
                  showTop: borderTop,
                  showBottom: borderBottom,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return [
      bracket(alignment: Alignment.topLeft, borderLeft: true, borderTop: true, borderRight: false, borderBottom: false),
      bracket(alignment: Alignment.topRight, borderLeft: false, borderTop: true, borderRight: true, borderBottom: false),
      bracket(alignment: Alignment.bottomLeft, borderLeft: true, borderTop: false, borderRight: false, borderBottom: true),
      bracket(alignment: Alignment.bottomRight, borderLeft: false, borderTop: false, borderRight: true, borderBottom: true),
    ];
  }
}

/// Tombol aksi (Galeri / flash) berbentuk rounded container.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.caption.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

/// Tombol capture utama berbentuk lingkaran besar.
class _CaptureButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CaptureButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter untuk sudut viewfinder.
class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double radius;
  final bool showLeft, showRight, showTop, showBottom;

  const _CornerBracketPainter({
    required this.color,
    required this.thickness,
    required this.radius,
    required this.showLeft,
    required this.showRight,
    required this.showTop,
    required this.showBottom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (showTop && showLeft) {
      canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
      canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
    }
    if (showTop && showRight) {
      canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
    }
    if (showBottom && showLeft) {
      canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
    }
    if (showBottom && showRight) {
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
