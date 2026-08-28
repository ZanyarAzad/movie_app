import 'package:flutter/material.dart';
import '../../../data/models/movie_detail_model.dart';
import '../../../data/models/movie_model.dart';
import '../../../utilities/themes/app_spacing.dart';
import '../../../utilities/themes/app_text_styles.dart';
import '../../../widgets/misc/genre_chip.dart';

class DetailOverviewSection extends StatelessWidget {
  final MovieDetailModel? detail;
  final MovieModel movie;

  const DetailOverviewSection({
    super.key,
    required this.detail,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tagline = detail?.tagline;
    final overview = detail?.overview.isNotEmpty == true
        ? detail!.overview
        : movie.overview;

    return Padding(
      padding: AppSpacing.edgeInsetsScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tagline != null && tagline.isNotEmpty) ...[
            Text(
              '"$tagline"',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          // Genres Chips
          if (detail != null && detail!.genres.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: detail!.genres
                  .map((g) => GenreChip(label: g.name))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const Text(
            'Storyline',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            overview.isNotEmpty ? overview : 'No overview available.',
            style: AppTextStyles.body.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
