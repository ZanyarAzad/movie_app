import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/movie_model.dart';
import '../../features/movie_detail/views/movie_detail_screen.dart';
import '../../features/search/views/search_screen.dart';
import '../../features/shell/views/main_shell_screen.dart';
import '../../features/trending/views/trending_screen.dart';
import '../../features/watchlist/views/watchlist_screen.dart';

class AppRoutes {
  static const String trending = '/';
  static const String search = '/search';
  static const String watchlist = '/watchlist';
  static const String movieDetail = '/movie/:id';

  static String movieDetailPath(int id) => '/movie/$id';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.trending,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShellScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.trending,
              name: 'trending',
              builder: (context, state) => const TrendingScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              name: 'search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.watchlist,
              name: 'watchlist',
              builder: (context, state) => const WatchlistScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.movieDetail,
      name: 'movieDetail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final idStr = state.pathParameters['id'] ?? '0';
        final movieId = int.tryParse(idStr) ?? 0;
        final extraMovie = state.extra as MovieModel?;
        return MovieDetailScreen(movieId: movieId, initialMovie: extraMovie);
      },
    ),
  ],
);
