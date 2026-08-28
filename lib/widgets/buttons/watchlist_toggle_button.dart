import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/watchlist_provider.dart';
import '../../data/models/movie_model.dart';
import '../../utilities/themes/app_colors.dart';
import '../../utilities/themes/app_radii.dart';

class WatchlistToggleButton extends StatelessWidget {
  final MovieModel movie;
  final bool isCircle;
  final double iconSize;

  const WatchlistToggleButton({
    super.key,
    required this.movie,
    this.isCircle = true,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final watchlistProvider = context.watch<WatchlistProvider>();
    final isSaved = watchlistProvider.isInWatchlist(movie.id);

    if (isCircle) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.65),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          iconSize: iconSize,
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(),
          icon: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
            color: isSaved ? AppColors.accentGold : Colors.white,
          ),
          onPressed: () => _handleToggle(context, watchlistProvider, isSaved),
          tooltip: isSaved ? 'Remove from Watchlist' : 'Add to Watchlist',
        ),
      );
    }

    return FilledButton.icon(
      onPressed: () => _handleToggle(context, watchlistProvider, isSaved),
      icon: Icon(
        isSaved ? Icons.bookmark_rounded : Icons.bookmark_add_outlined,
        color: isSaved ? AppColors.accentGold : Colors.white,
        size: iconSize,
      ),
      label: Text(
        isSaved ? 'In Watchlist' : 'Add to Watchlist',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: isSaved
            ? (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkCard
                  : AppColors.lightCard)
            : AppColors.primary,
        foregroundColor: isSaved
            ? Theme.of(context).colorScheme.onSurface
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.radiusMd,
          side: isSaved
              ? BorderSide(color: Theme.of(context).dividerColor, width: 1)
              : BorderSide.none,
        ),
      ),
    );
  }

  void _handleToggle(
    BuildContext context,
    WatchlistProvider provider,
    bool currentlySaved,
  ) {
    provider.toggleWatchlist(movie);

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          currentlySaved
              ? 'Removed "${movie.title}" from Watchlist'
              : 'Added "${movie.title}" to Watchlist',
        ),
        action: currentlySaved
            ? SnackBarAction(
                label: 'Undo',
                textColor: AppColors.accentGold,
                onPressed: () => provider.addToWatchlist(movie),
              )
            : null,
      ),
    );
  }
}
