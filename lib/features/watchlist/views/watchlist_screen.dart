import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/watchlist_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../utilities/themes/app_colors.dart';
import '../../../utilities/themes/app_spacing.dart';
import '../../../widgets/cards/movie_list_tile.dart';
import '../../../widgets/layout/custom_app_bar.dart';
import '../../../widgets/states/empty_state_view.dart';
import '../../../widgets/states/loading_spinner_view.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'My Watchlist', showThemeToggle: true),
      body: Consumer<WatchlistProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingSpinnerView(
              message: 'Loading your saved movies...',
            );
          }

          if (provider.isEmpty) {
            return EmptyStateView(
              icon: Icons.bookmark_border_rounded,
              title: 'Your Watchlist is Empty',
              message:
                  'Save movies you want to watch later! Saved titles remain accessible offline.',
              actionLabel: 'Explore Trending',
              onAction: () => context.go(AppRoutes.trending),
            );
          }

          final watchlist = provider.watchlist;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    Text(
                      '${watchlist.length} Saved ${watchlist.length == 1 ? 'Movie' : 'Movies'}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const Spacer(),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.offline_pin_rounded,
                          size: 14,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Available Offline',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: AppSpacing.edgeInsetsScreen,
                  itemCount: watchlist.length,
                  itemBuilder: (context, index) {
                    final movie = watchlist[index];

                    return Dismissible(
                      key: Key('watchlist_${movie.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (_) {
                        provider.removeFromWatchlist(movie.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 3),
                            content: Text(
                              'Removed "${movie.title}" from Watchlist',
                            ),
                            action: SnackBarAction(
                              label: 'Undo',
                              textColor: AppColors.accentGold,
                              onPressed: () => provider.addToWatchlist(movie),
                            ),
                          ),
                        );
                      },
                      child: MovieListTile(
                        movie: movie,
                        onTap: () => context.push(
                          AppRoutes.movieDetailPath(movie.id),
                          extra: movie,
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.error,
                            size: 20,
                          ),
                          tooltip: 'Remove from Watchlist',
                          onPressed: () {
                            provider.removeFromWatchlist(movie.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 3),
                                content: Text(
                                  'Removed "${movie.title}" from Watchlist',
                                ),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  textColor: AppColors.accentGold,
                                  onPressed: () =>
                                      provider.addToWatchlist(movie),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
