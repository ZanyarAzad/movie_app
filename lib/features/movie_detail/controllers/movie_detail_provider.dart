import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/movie_detail_model.dart';

enum MovieDetailState { initial, loading, loaded, error }

class MovieDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  MovieDetailProvider({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  MovieDetailState _state = MovieDetailState.initial;
  MovieDetailState get state => _state;

  MovieDetailModel? _movieDetail;
  MovieDetailModel? get movieDetail => _movieDetail;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == MovieDetailState.loading;
  bool get isLoaded => _state == MovieDetailState.loaded;
  bool get isError => _state == MovieDetailState.error;

  Future<void> fetchMovieDetails(int movieId) async {
    _state = MovieDetailState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final detail = await _apiService.getMovieDetails(movieId);
      _movieDetail = detail;
      _state = MovieDetailState.loaded;
    } catch (e) {
      _state = MovieDetailState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    _movieDetail = null;
    _state = MovieDetailState.initial;
    _errorMessage = '';
  }
}
