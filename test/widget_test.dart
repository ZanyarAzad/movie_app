import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/providers/connectivity_provider.dart';
import 'package:movie_app/core/providers/theme_provider.dart';
import 'package:movie_app/core/providers/watchlist_provider.dart';
import 'package:movie_app/core/services/storage_service.dart';
import 'package:movie_app/features/search/controllers/search_movies_provider.dart';
import 'package:movie_app/features/trending/controllers/trending_movies_provider.dart';
import 'package:movie_app/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('MovieApp launches and renders shell tabs', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);
    final themeProvider = ThemeProvider(storage)..init();
    final watchlistProvider = WatchlistProvider(storage)..loadWatchlist();
    final connectivityProvider = ConnectivityProvider();
    final trendingProvider = TrendingMoviesProvider();
    final searchProvider = SearchMoviesProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: themeProvider),
          ChangeNotifierProvider.value(value: watchlistProvider),
          ChangeNotifierProvider.value(value: connectivityProvider),
          ChangeNotifierProvider.value(value: trendingProvider),
          ChangeNotifierProvider.value(value: searchProvider),
        ],
        child: const MovieApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify bottom navigation destinations
    expect(find.text('Trending'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Watchlist'), findsOneWidget);
  });
}
