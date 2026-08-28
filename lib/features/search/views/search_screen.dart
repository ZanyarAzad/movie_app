import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../utilities/themes/app_colors.dart';
import '../../../utilities/themes/app_spacing.dart';
import '../../../widgets/cards/movie_list_tile.dart';
import '../../../widgets/inputs/app_search_bar.dart';
import '../../../widgets/layout/custom_app_bar.dart';
import '../../../widgets/states/empty_state_view.dart';
import '../../../widgets/states/error_state_view.dart';
import '../../../widgets/states/movie_shimmer_list.dart';
import '../controllers/search_movies_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<SearchMoviesProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onClear() {
    _searchController.clear();
    context.read<SearchMoviesProvider>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Search Movies', showThemeToggle: true),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: AppSpacing.edgeInsetsScreen,
            child: AppSearchBar(
              controller: _searchController,
              onChanged: (query) =>
                  context.read<SearchMoviesProvider>().onQueryChanged(query),
              onClear: _onClear,
              onSubmitted: (query) =>
                  context.read<SearchMoviesProvider>().search(query),
            ),
          ),
          // Search Results & States
          Expanded(
            child: Consumer<SearchMoviesProvider>(
              builder: (context, provider, _) {
                if (provider.isInitial) {
                  return const EmptyStateView(
                    icon: Icons.search_rounded,
                    title: 'Discover Movies',
                    message:
                        'Type in movie titles like "Inception", "Interstellar", or "Avengers" to start searching.',
                  );
                }

                if (provider.isLoading) {
                  return const MovieShimmerList();
                }

                if (provider.isError) {
                  return ErrorStateView(
                    message: provider.errorMessage,
                    onRetry: () => provider.search(_searchController.text),
                  );
                }

                if (provider.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.search_off_rounded,
                    title: 'No Movies Found',
                    message:
                        'We couldn\'t find any movies matching "${provider.currentQuery}". Try another keyword.',
                  );
                }

                final results = provider.results;

                return ListView.builder(
                  controller: _scrollController,
                  padding: AppSpacing.edgeInsetsScreen,
                  itemCount: results.length + (provider.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= results.length) {
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

                    final movie = results[index];
                    return MovieListTile(
                      movie: movie,
                      onTap: () => context.push(
                        AppRoutes.movieDetailPath(movie.id),
                        extra: movie,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
