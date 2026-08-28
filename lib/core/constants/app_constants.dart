class AppConstants {
  // Storage Keys
  static const String keyWatchlist = 'movie_app_watchlist_items';
  static const String keyThemeMode = 'movie_app_theme_mode';
  static const String keyGenresCache = 'movie_app_genres_cache';

  // Network & Debounce Delays
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration searchDebounce = Duration(milliseconds: 500);

  // App Strings
  static const String appName = 'TMDB Movie App';
  static const String trendingTitle = 'Trending Movies';
  static const String searchTitle = 'Search Movies';
  static const String watchlistTitle = 'My Watchlist';
  static const String movieDetailTitle = 'Movie Details';
}
