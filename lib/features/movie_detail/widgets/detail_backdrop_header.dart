import 'package:flutter/material.dart';
import '../../../data/models/movie_detail_model.dart';
import '../../../data/models/movie_model.dart';
import '../../../utilities/themes/app_colors.dart';
import '../../../utilities/themes/app_radii.dart';
import '../../../utilities/themes/app_spacing.dart';
import '../../../widgets/media/cached_backdrop_image.dart';

class DetailBackdropHeader extends StatelessWidget {
  final MovieDetailModel? detail;
  final MovieModel movie;
  final ValueChanged<String> onPlayVideo;

  const DetailBackdropHeader({
    super.key,
    required this.detail,
    required this.movie,
    required this.onPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    final trailer = detail?.trailerVideo;

    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedBackdropImage(
            backdropPath: detail?.backdropPath ?? movie.backdropPath,
            height: 280,
            showGradient: true,
          ),
          if (trailer != null && trailer.key.isNotEmpty)
            Center(
              child: ElevatedButton.icon(
                onPressed: () => onPlayVideo(trailer.youtubeUrl),
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                label: Text(
                  trailer.type.isNotEmpty
                      ? 'Play ${trailer.type}'
                      : 'Play Trailer',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm + 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.radiusRound,
                  ),
                  elevation: 4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
