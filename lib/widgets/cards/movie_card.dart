import 'package:flutter/material.dart';
import '../../core/services/genre_service.dart';
import '../../data/models/movie_model.dart';
import '../../utilities/themes/app_radii.dart';
import '../../utilities/themes/app_spacing.dart';
import '../../utilities/themes/app_text_styles.dart';
import '../buttons/watchlist_toggle_button.dart';
import '../media/cached_movie_poster.dart';
import '../misc/rating_badge.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.width = 140,
    this.height = 270,
  });

  @override
  Widget build(BuildContext context) {
    final genreNames = GenreService().getGenreNames(movie.genreIds);
    final primaryGenre = genreNames.isNotEmpty ? genreNames.first : null;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.radiusMd,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poster with Rating and Bookmark
            Stack(
              children: [
                CachedMoviePoster(
                  posterPath: movie.posterPath,
                  width: width,
                  height: width * 1.45,
                  borderRadius: AppRadii.radiusMd,
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: RatingBadge(rating: movie.voteAverage, isCompact: true),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: WatchlistToggleButton(movie: movie, iconSize: 18),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Title
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.movieTitleSmall,
            ),
            const SizedBox(height: 2),
            // Release Year & Genre
            Row(
              children: [
                if (movie.releaseYear.isNotEmpty)
                  Text(
                    movie.releaseYear,
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                if (movie.releaseYear.isNotEmpty && primaryGenre != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '•',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                if (primaryGenre != null)
                  Expanded(
                    child: Text(
                      primaryGenre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
