import 'package:flutter/material.dart';
import '../../utilities/themes/app_colors.dart';
import '../../utilities/themes/app_radii.dart';
import '../../utilities/themes/app_text_styles.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  final bool isCompact;

  const RatingBadge({super.key, required this.rating, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final formatted = rating.toStringAsFixed(1);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.5),
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 14),
          const SizedBox(width: 3),
          Text(
            formatted,
            style: AppTextStyles.rating.copyWith(
              color: Colors.white,
              fontSize: isCompact ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
