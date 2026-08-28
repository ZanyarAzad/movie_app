class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';

  // Poster Image Sizes
  static const String posterW92 = 'w92';
  static const String posterW154 = 'w154';
  static const String posterW185 = 'w185';
  static const String posterW342 = 'w342';
  static const String posterW500 = 'w500';
  static const String posterW780 = 'w780';
  static const String posterOriginal = 'original';

  // Backdrop Image Sizes
  static const String backdropW300 = 'w300';
  static const String backdropW780 = 'w780';
  static const String backdropW1280 = 'w1280';
  static const String backdropOriginal = 'original';

  // Profile Image Sizes
  static const String profileW45 = 'w45';
  static const String profileW185 = 'w185';
  static const String profileH632 = 'h632';
  static const String profileOriginal = 'original';

  // Endpoints
  static const String trendingDay = '/trending/movie/day';
  static const String trendingWeek = '/trending/movie/week';
  static const String popularMovies = '/movie/popular';
  static const String searchMovie = '/search/movie';
  static const String movieDetails = '/movie';
  static const String genreList = '/genre/movie/list';
  static const String configuration = '/configuration';

  // TMDB API Token (Read Access Token)
  static const String apiToken = String.fromEnvironment(
    'TMDB_API_TOKEN',
    defaultValue:
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNTY1N2VjODBkYjA4MzVhNjVhOWI4YTJhZTdhMTBmMyIsIm5iZiI6MTc4NzkzOTg0MS45OTksInN1YiI6IjZhOTFjYzAxZWYyMmJiMjliMTc3MTRiNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9uUQ1GohQFGE8ur9usWKQVEY91rCptTebyMpEJioZGc',
  );

  // TMDB API Key (v3 fallback)
  static const String apiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: 'a5657ec80db0835a65a9b8a2ae7a10f3',
  );

  // Helper Methods for URL Construction
  static String getPosterUrl(String? path, {String size = posterW500}) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl$size$path';
  }

  static String getBackdropUrl(String? path, {String size = backdropW780}) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl$size$path';
  }

  static String getProfileUrl(String? path, {String size = profileW185}) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl$size$path';
  }
}
