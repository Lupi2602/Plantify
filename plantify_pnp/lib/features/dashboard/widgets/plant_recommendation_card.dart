import 'package:flutter/material.dart';
import 'package:plantify_pnp/core/constants/route_constants.dart';
import 'package:plantify_pnp/core/theme/app_colors.dart';
import 'package:plantify_pnp/core/theme/app_typography.dart';
import 'package:plantify_pnp/shared/widgets/plant_image_widget.dart';

/// Card untuk satu item tanaman pada section Rekomendasi Tanaman di Dashboard.
///
/// Digunakan dalam horizontal ListView.
/// Action: tap → navigasi ke PlantDetailScreen.
///
/// Data berasal dari tabel tanaman (random/acak).
/// Bukan AI Recommendation. Referensi: UI_GUIDELINE.md — Plant Recommendation
class PlantRecommendationCard extends StatelessWidget {
  final String plantName;
  final String imagePath;
  final String description;
  final int? plantId;

  const PlantRecommendationCard({
    super.key,
    required this.plantName,
    required this.imagePath,
    required this.description,
    this.plantId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        RouteConstants.plantDetail,
        arguments: plantId,
      ),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: PlantImageWidget(
                imagePath: imagePath,
                height: 110,
                width: 140,
                fit: BoxFit.cover,
              ),
            ),

            // Plant Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantName,
                    style: AppTypography.bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTypography.caption.copyWith(fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
