import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import '../services/storage_service.dart';

class WatchlistProvider extends ChangeNotifier {
  final StorageService _storageService;

  List<MovieModel> _watchlist = [];
  bool _isLoading = false;

  WatchlistProvider(this._storageService);

  List<MovieModel> get watchlist => List.unmodifiable(_watchlist);
  bool get isLoading => _isLoading;
  bool get isEmpty => _watchlist.isEmpty;
  int get count => _watchlist.length;

  void loadWatchlist() {
    _isLoading = true;
    notifyListeners();

    _watchlist = _storageService.getWatchlist();
    _isLoading = false;
    notifyListeners();
  }

  bool isInWatchlist(int movieId) {
    return _watchlist.any((movie) => movie.id == movieId);
  }

  Future<void> toggleWatchlist(MovieModel movie) async {
    if (isInWatchlist(movie.id)) {
      await removeFromWatchlist(movie.id);
    } else {
      await addToWatchlist(movie);
    }
  }

  Future<void> addToWatchlist(MovieModel movie) async {
    if (!isInWatchlist(movie.id)) {
      _watchlist.insert(0, movie);
      notifyListeners();
      await _storageService.saveToWatchlist(movie);
    }
  }

  Future<void> removeFromWatchlist(int movieId) async {
    if (isInWatchlist(movieId)) {
      _watchlist.removeWhere((movie) => movie.id == movieId);
      notifyListeners();
      await _storageService.removeFromWatchlist(movieId);
    }
  }
}
