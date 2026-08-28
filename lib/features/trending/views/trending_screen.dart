import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../utilities/themes/app_colors.dart';
import '../../../utilities/themes/app_radii.dart';
import '../../../utilities/themes/app_spacing.dart';
import '../../../widgets/cards/movie_list_tile.dart';
import '../../../widgets/cards/trending_banner_card.dart';
import '../../../widgets/layout/custom_app_bar.dart';
import '../../../widgets/states/empty_state_view.dart';
import '../../../widgets/states/error_state_view.dart';
import '../../../widgets/states/movie_shimmer_list.dart';
import '../controllers/trending_movies_provider.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TrendingMoviesProvider>();
      if (provider.state == TrendingState.initial) {
        provider.fetchTrendingMovies();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<TrendingMoviesProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Trending Movies',
        showThemeToggle: true,
      ),
      body: Consumer<TrendingMoviesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const MovieShimmerList();
          }

          if (provider.isError) {
            return ErrorStateView(
              message: provider.errorMessage,
              onRetry: () => provider.fetchTrendingMovies(),
            );
          }

          if (provider.isEmpty) {
            return EmptyStateView(
              title: 'No Trending Movies',
              message: 'Unable to find trending movies at this moment.',
              actionLabel: 'Refresh',
              onAction: () => provider.fetchTrendingMovies(isRefresh: true),
            );
          }

          final movies = provider.trendingMovies;
          final featured = provider.featuredMovie;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => provider.fetchTrendingMovies(isRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              padding: AppSpacing.edgeInsetsScreen,
              physics: const AlwaysScrollableScrollPhysics(),
              // +1 for header / time filter + banner, +1 if loading more indicator
              itemCount: movies.length + (provider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time Window Switcher (Today / This Week)
                      _buildTimeWindowSelector(context, provider),
                      const SizedBox(height: AppSpacing.md),
                      if (featured != null)
                        TrendingBannerCard(
                          movie: featured,
                          onTap: () => context.push(
                            AppRoutes.movieDetailPath(featured.id),
                            extra: featured,
                          ),
                        ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text(
                          'Popular Right Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      // First feed item
                      if (movies.isNotEmpty)
                        MovieListTile(
                          movie: movies[0],
                          onTap: () => context.push(
                            AppRoutes.movieDetailPath(movies[0].id),
                            extra: movies[0],
                          ),
                        ),
                    ],
                  );
                }

                // Loading more spinner at bottom
                if (index >= movies.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }

                final movie = movies[index];
                return MovieListTile(
                  movie: movie,
                  onTap: () => context.push(
                    AppRoutes.movieDetailPath(movie.id),
                    extra: movie,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeWindowSelector(
    BuildContext context,
    TrendingMoviesProvider provider,
  ) {
    final isDay = provider.timeWindow == 'day';
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: theme.dividerColor, width: 0.8),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Expanded(
            child: _windowButton(
              title: 'Today',
              isSelected: isDay,
              onTap: () => provider.setTimeWindow('day'),
            ),
          ),
          Expanded(
            child: _windowButton(
              title: 'This Week',
              isSelected: !isDay,
              onTap: () => provider.setTimeWindow('week'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _windowButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadii.radiusSm,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
