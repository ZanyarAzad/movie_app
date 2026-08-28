import 'package:flutter/material.dart';
import '../../../data/models/movie_detail_model.dart';
import '../../../data/models/movie_model.dart';
import '../../../utilities/themes/app_radii.dart';
import '../../../utilities/themes/app_spacing.dart';
import '../../../utilities/themes/app_text_styles.dart';
import '../../../utilities/util.dart';
import '../../../widgets/buttons/watchlist_toggle_button.dart';
import '../../../widgets/media/cached_movie_poster.dart';
import '../../../widgets/misc/rating_badge.dart';

class DetailHeaderInfo extends StatelessWidget {
  final MovieDetailModel? detail;
  final MovieModel movie;

  const DetailHeaderInfo({
    super.key,
    required this.detail,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster Thumbnail (Hero Animation)
          Hero(
            tag: 'movie_poster_${movie.id}',
            child: CachedMoviePoster(
              posterPath: detail?.posterPath ?? movie.posterPath,
              width: 110,
              height: 165,
              borderRadius: AppRadii.radiusMd,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Title, Rating, and Action
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail?.title ?? movie.title,
                  style: AppTextStyles.heroTitle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    RatingBadge(
                      rating: detail?.voteAverage ?? movie.voteAverage,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (detail != null && detail!.formattedRuntime.isNotEmpty)
                      Text(
                        detail!.formattedRuntime,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                if (movie.releaseDate != null)
                  Text(
                    AppUtils.formatDate(movie.releaseDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                // Watchlist Toggle Action Button
                WatchlistToggleButton(movie: movie, isCircle: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
