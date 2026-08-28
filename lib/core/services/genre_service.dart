import 'api_service.dart';

class GenreService {
  static final GenreService _instance = GenreService._internal();
  factory GenreService() => _instance;
  GenreService._internal();

  // Pre-populated default TMDB genres map for instant offline & zero-latency lookup
  final Map<int, String> _genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Sci-Fi',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final genres = await ApiService().getGenres();
      for (final genre in genres) {
        _genreMap[genre.id] = genre.name;
      }
      _initialized = true;
    } catch (_) {
      // Fallback to default in-memory map on network failure
    }
  }

  String getGenreName(int id) {
    return _genreMap[id] ?? 'Movie';
  }

  List<String> getGenreNames(List<int> ids) {
    if (ids.isEmpty) return const [];
    return ids.map((id) => getGenreName(id)).toList();
  }
}
