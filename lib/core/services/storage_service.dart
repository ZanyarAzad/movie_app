import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/movie_model.dart';
import '../constants/app_constants.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // ==========================================
  // Watchlist Persistence (Offline Support)
  // ==========================================

  List<MovieModel> getWatchlist() {
    final rawList = _prefs.getStringList(AppConstants.keyWatchlist) ?? [];
    return rawList
        .map((item) {
          try {
            return MovieModel.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            );
          } catch (_) {
            return null;
          }
        })
        .whereType<MovieModel>()
        .toList();
  }

  Future<bool> saveToWatchlist(MovieModel movie) async {
    final list = getWatchlist();
    if (!list.any((m) => m.id == movie.id)) {
      list.insert(0, movie);
      final stringList = list.map((m) => jsonEncode(m.toJson())).toList();
      return _prefs.setStringList(AppConstants.keyWatchlist, stringList);
    }
    return true;
  }

  Future<bool> removeFromWatchlist(int movieId) async {
    final list = getWatchlist();
    list.removeWhere((m) => m.id == movieId);
    final stringList = list.map((m) => jsonEncode(m.toJson())).toList();
    return _prefs.setStringList(AppConstants.keyWatchlist, stringList);
  }

  bool isInWatchlist(int movieId) {
    final list = getWatchlist();
    return list.any((m) => m.id == movieId);
  }

  // ==========================================
  // Theme Mode Persistence
  // ==========================================

  String getThemeMode() {
    return _prefs.getString(AppConstants.keyThemeMode) ?? 'system';
  }

  Future<bool> setThemeMode(String mode) {
    return _prefs.setString(AppConstants.keyThemeMode, mode);
  }
}
