import 'package:flutter/material.dart';
import '../../core/services/genre_service.dart';
import '../../data/models/movie_model.dart';
import '../../utilities/themes/app_radii.dart';
import '../../utilities/themes/app_spacing.dart';
import '../../utilities/themes/app_text_styles.dart';
import '../buttons/watchlist_toggle_button.dart';
import '../media/cached_movie_poster.dart';
import '../misc/genre_chip.dart';
import '../misc/rating_badge.dart';

class MovieListTile extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MovieListTile({
    super.key,
    required this.movie,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final genreNames = GenreService().getGenreNames(movie.genreIds);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: theme.dividerColor, width: 0.6),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.radiusMd,
        child: Padding(
          padding: AppSpacing.edgeInsetsAllSm,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster with rating badge
              Stack(
                children: [
                  CachedMoviePoster(
                    posterPath: movie.posterPath,
                    width: 85,
                    height: 125,
                    borderRadius: AppRadii.radiusSm,
                  ),
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: RatingBadge(
                      rating: movie.voteAverage,
                      isCompact: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              // Movie Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.movieTitle,
                          ),
                        ),
                        if (trailing != null)
                          trailing!
                        else
                          WatchlistToggleButton(movie: movie, iconSize: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (movie.releaseYear.isNotEmpty)
                      Text(
                        movie.releaseYear,
                        style: AppTextStyles.caption.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xs),
                    if (genreNames.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: genreNames.take(2).map((genre) {
                          return GenreChip(label: genre);
                        }).toList(),
                      ),
                    const SizedBox(height: AppSpacing.xs),
                    if (movie.overview.isNotEmpty)
                      Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
