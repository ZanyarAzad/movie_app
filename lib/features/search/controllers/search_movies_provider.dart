import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/movie_model.dart';

enum SearchState { initial, loading, loaded, empty, error }

class SearchMoviesProvider extends ChangeNotifier {
  final ApiService _apiService;
  Timer? _debounceTimer;

  SearchMoviesProvider({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  SearchState _state = SearchState.initial;
  SearchState get state => _state;

  List<MovieModel> _results = [];
  List<MovieModel> get results => List.unmodifiable(_results);

  String _currentQuery = '';
  String get currentQuery => _currentQuery;

  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _currentPage < _totalPages;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool get isInitial => _state == SearchState.initial;
  bool get isLoading => _state == SearchState.loading;
  bool get isLoaded => _state == SearchState.loaded;
  bool get isEmpty => _state == SearchState.empty;
  bool get isError => _state == SearchState.error;

  void onQueryChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      clearSearch();
      return;
    }

    _debounceTimer = Timer(AppConstants.searchDebounce, () {
      search(trimmed);
    });
  }

  Future<void> search(String query) async {
    _currentQuery = query;
    _currentPage = 1;
    _state = SearchState.loading;
    notifyListeners();

    try {
      final response = await _apiService.searchMovies(
        query,
        page: _currentPage,
      );

      _results = response.results;
      _totalPages = response.totalPages;

      if (_results.isEmpty) {
        _state = SearchState.empty;
      } else {
        _state = SearchState.loaded;
      }
      _errorMessage = '';
    } catch (e) {
      _state = SearchState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore || _currentQuery.isEmpty) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _apiService.searchMovies(
        _currentQuery,
        page: nextPage,
      );

      _results.addAll(response.results);
      _currentPage = nextPage;
      _totalPages = response.totalPages;
    } catch (_) {
      // Keep existing results on pagination error
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _currentQuery = '';
    _results = [];
    _state = SearchState.initial;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
