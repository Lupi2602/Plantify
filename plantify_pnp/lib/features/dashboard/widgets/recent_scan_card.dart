import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/shared/widgets/plant_image_widget.dart';

/// Card untuk satu item pada section Scan Terakhir di Dashboard.
///
/// Menampilkan: thumbnail, nama tanaman, confidence, waktu scan.
/// Action: tap → navigasi ke ResultScreen (detail riwayat).
/// Max item: 5. Referensi: UI_GUIDELINE.md — Recent Scan
class RecentScanCard extends StatelessWidget {
  final String plantName;
  final String imagePath;
  final double confidence;
  final String timeAgo;
  final int? historyId;

  const RecentScanCard({
    super.key,
    required this.plantName,
    required this.imagePath,
    required this.confidence,
    required this.timeAgo,
    this.historyId,
  });

  @override
  Widget build(BuildContext context) {
    final confidencePercent = (confidence * 100).toStringAsFixed(1);
    final confidenceColor = AppColors.getConfidenceColor(confidence);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        RouteConstants.result,
        arguments: historyId,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider, width: 0.8),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: PlantImageWidget(
                imagePath: imagePath,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantName,
                    style: AppTypography.bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeAgo,
                    style: AppTypography.caption.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),

            // Confidence Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: confidenceColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: confidenceColor.withAlpha(80)),
              ),
              child: Text(
                '$confidencePercent%',
                style: AppTypography.caption.copyWith(
                  color: confidenceColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
