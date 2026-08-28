import 'package:flutter/material.dart';
import '../../core/services/genre_service.dart';
import '../../data/models/movie_model.dart';
import '../../utilities/themes/app_radii.dart';
import '../../utilities/themes/app_spacing.dart';
import '../../utilities/themes/app_text_styles.dart';
import '../buttons/watchlist_toggle_button.dart';
import '../media/cached_backdrop_image.dart';
import '../media/cached_movie_poster.dart';
import '../misc/genre_chip.dart';
import '../misc/rating_badge.dart';

class TrendingBannerCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onTap;

  const TrendingBannerCard({
    super.key,
    required this.movie,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final genreNames = GenreService().getGenreNames(movie.genreIds);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      height: 220,
      child: ClipRRect(
        borderRadius: AppRadii.radiusLg,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Backdrop with Gradient
            CachedBackdropImage(
              backdropPath: movie.backdropPath,
              height: 220,
              showGradient: true,
            ),
            // Material Ink Response
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: AppSpacing.edgeInsetsAllMd,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Poster thumbnail
                      CachedMoviePoster(
                        posterPath: movie.posterPath,
                        width: 90,
                        height: 135,
                        borderRadius: AppRadii.radiusMd,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Movie info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: AppRadii.radiusSm,
                              ),
                              child: const Text(
                                'FEATURED TRENDING',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.movieTitle.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                RatingBadge(rating: movie.voteAverage, isCompact: true),
                                const SizedBox(width: 8),
                                if (movie.releaseYear.isNotEmpty)
                                  Text(
                                    movie.releaseYear,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            if (genreNames.isNotEmpty)
                              Wrap(
                                spacing: 4,
                                children: genreNames.take(2).map((genre) {
                                  return GenreChip(label: genre);
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                      // Bookmark toggle button
                      WatchlistToggleButton(movie: movie, isCircle: true),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
