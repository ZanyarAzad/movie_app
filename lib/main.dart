import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/connectivity_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/watchlist_provider.dart';
import 'core/router/app_router.dart';
import 'core/services/genre_service.dart';
import 'core/services/storage_service.dart';
import 'utilities/themes/theme.dart';
import 'widgets/misc/offline_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage & Services
  final sharedPreferences = await SharedPreferences.getInstance();
  final storageService = StorageService(sharedPreferences);

  // Initialize Genre Cache
  final genreService = GenreService();
  await genreService.init();

  // Initialize State Providers
  final themeProvider = ThemeProvider(storageService)..init();
  final watchlistProvider = WatchlistProvider(storageService)..loadWatchlist();
  final connectivityProvider = ConnectivityProvider()..init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: watchlistProvider),
        ChangeNotifierProvider.value(value: connectivityProvider),
      ],
      child: const MovieApp(),
    ),
  );
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'TMDB Movie App',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      builder: (context, child) => OfflineBanner(child: child!),
    );
  }
}
