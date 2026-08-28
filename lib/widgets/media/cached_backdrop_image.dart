import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import '../../utilities/themes/app_colors.dart';

class CachedBackdropImage extends StatelessWidget {
  final String? backdropPath;
  final double height;
  final double width;
  final bool showGradient;
  final Widget? child;

  const CachedBackdropImage({
    super.key,
    required this.backdropPath,
    this.height = 240,
    this.width = double.infinity,
    this.showGradient = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final url = ApiConstants.getBackdropUrl(backdropPath);

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (url.isNotEmpty)
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                child: const Center(
                  child: Icon(Icons.image_not_supported_outlined, size: 40),
                ),
              ),
            )
          else
            Container(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              child: const Center(child: Icon(Icons.movie_outlined, size: 48)),
            ),
          if (showGradient)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      (isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground)
                          .withValues(alpha: 0.95),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
