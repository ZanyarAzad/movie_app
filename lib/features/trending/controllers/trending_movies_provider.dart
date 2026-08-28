import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/movie_model.dart';

enum TrendingState { initial, loading, loaded, error }

class TrendingMoviesProvider extends ChangeNotifier {
  final ApiService _apiService;

  TrendingMoviesProvider({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  TrendingState _state = TrendingState.initial;
  TrendingState get state => _state;

  List<MovieModel> _trendingMovies = [];
  List<MovieModel> get trendingMovies => List.unmodifiable(_trendingMovies);

  MovieModel? get featuredMovie =>
      _trendingMovies.isNotEmpty ? _trendingMovies.first : null;

  List<MovieModel> get feedMovies =>
      _trendingMovies.length > 1 ? _trendingMovies.sublist(1) : [];

  String _timeWindow = 'day'; // 'day' or 'week'
  String get timeWindow => _timeWindow;

  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _currentPage < _totalPages;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == TrendingState.loading;
  bool get isLoaded => _state == TrendingState.loaded;
  bool get isError => _state == TrendingState.error;
  bool get isEmpty => _state == TrendingState.loaded && _trendingMovies.isEmpty;

  Future<void> fetchTrendingMovies({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
    } else {
      _state = TrendingState.loading;
      notifyListeners();
    }

    try {
      final response = await _apiService.getTrendingMovies(
        timeWindow: _timeWindow,
        page: _currentPage,
      );

      _trendingMovies = response.results;
      _totalPages = response.totalPages;
      _state = TrendingState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = TrendingState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _apiService.getTrendingMovies(
        timeWindow: _timeWindow,
        page: nextPage,
      );

      _trendingMovies.addAll(response.results);
      _currentPage = nextPage;
      _totalPages = response.totalPages;
    } catch (_) {
      // Keep existing list on pagination error
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void setTimeWindow(String window) {
    if (_timeWindow == window) return;
    _timeWindow = window;
    fetchTrendingMovies(isRefresh: true);
  }
}
