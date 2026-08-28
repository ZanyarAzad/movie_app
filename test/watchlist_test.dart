import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/providers/watchlist_provider.dart';
import 'package:movie_app/core/services/storage_service.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Offline Watchlist Tests', () {
    late StorageService storageService;
    late WatchlistProvider watchlistProvider;

    const testMovie = MovieModel(
      id: 27205,
      title: 'Inception',
      overview: 'A mind-bending thriller',
      posterPath: '/xlaY2zyzMfkhk0HSC5VUwzoZPU1.jpg',
      voteAverage: 8.4,
      releaseDate: '2010-07-15',
    );

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = StorageService(prefs);
      watchlistProvider = WatchlistProvider(storageService);
      watchlistProvider.loadWatchlist();
    });

    test('Initially watchlist is empty', () {
      expect(watchlistProvider.isEmpty, isTrue);
      expect(watchlistProvider.count, equals(0));
    });

    test('Adding a movie to watchlist saves it locally', () async {
      await watchlistProvider.addToWatchlist(testMovie);

      expect(watchlistProvider.count, equals(1));
      expect(watchlistProvider.isInWatchlist(27205), isTrue);

      // Verify persistence in storage service
      final storedList = storageService.getWatchlist();
      expect(storedList.length, equals(1));
      expect(storedList.first.title, equals('Inception'));
    });

    test('Removing a movie from watchlist updates state and storage', () async {
      await watchlistProvider.addToWatchlist(testMovie);
      expect(watchlistProvider.isInWatchlist(27205), isTrue);

      await watchlistProvider.removeFromWatchlist(27205);
      expect(watchlistProvider.isInWatchlist(27205), isFalse);
      expect(watchlistProvider.isEmpty, isTrue);

      // Verify removed from storage
      expect(storageService.getWatchlist().isEmpty, isTrue);
    });

    test('Toggling movie adds if missing and removes if present', () async {
      await watchlistProvider.toggleWatchlist(testMovie);
      expect(watchlistProvider.isInWatchlist(27205), isTrue);

      await watchlistProvider.toggleWatchlist(testMovie);
      expect(watchlistProvider.isInWatchlist(27205), isFalse);
    });
  });
}
