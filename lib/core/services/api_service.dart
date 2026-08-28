import 'package:dio/dio.dart';
import '../../data/models/genre_model.dart';
import '../../data/models/movie_detail_model.dart';
import '../../data/models/movie_response.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../errors/api_exception.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Authorization': 'Bearer ${ApiConstants.apiToken}',
          'accept': 'application/json',
        },
      ),
    );
  }

  // Internal Error Handler
  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      int? tmdbCode;
      String message = 'An unexpected error occurred. Please try again.';

      if (error.response?.data is Map<String, dynamic>) {
        final data = error.response!.data as Map<String, dynamic>;
        if (data.containsKey('status_message')) {
          message = data['status_message'] as String;
        }
        if (data.containsKey('status_code')) {
          tmdbCode = data['status_code'] as int?;
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const ApiException(
            message: 'Connection timed out. Please check your internet connection.',
            statusCode: 408,
          );
        case DioExceptionType.connectionError:
          return const ApiException(
            message: 'No internet connection. Please check your network.',
          );
        case DioExceptionType.badResponse:
          if (statusCode == 401) {
            return ApiException(
              message: message.isNotEmpty ? message : 'Invalid API key or unauthorized access.',
              statusCode: 401,
              tmdbStatusCode: tmdbCode,
            );
          } else if (statusCode == 404) {
            return ApiException(
              message: message.isNotEmpty ? message : 'The requested resource was not found.',
              statusCode: 404,
              tmdbStatusCode: tmdbCode,
            );
          } else if (statusCode == 429) {
            return ApiException(
              message: 'Too many requests. Please wait a moment and retry.',
              statusCode: 429,
              tmdbStatusCode: tmdbCode,
            );
          }
          return ApiException(
            message: message,
            statusCode: statusCode,
            tmdbStatusCode: tmdbCode,
          );
        case DioExceptionType.cancel:
          return const ApiException(message: 'Request was cancelled.');
        default:
          return ApiException(
            message: error.message ?? 'Network error occurred.',
            statusCode: statusCode,
          );
      }
    }
    return ApiException(message: error.toString());
  }

  /// Fetch trending movies (day or week)
  Future<MovieResponse> getTrendingMovies({
    String timeWindow = 'day',
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        '/trending/movie/$timeWindow',
        queryParameters: {
          'language': 'en-US',
          'page': page,
        },
      );
      return MovieResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetch popular movies
  Future<MovieResponse> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConstants.popularMovies,
        queryParameters: {
          'language': 'en-US',
          'page': page,
        },
      );
      return MovieResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Search movies by title
  Future<MovieResponse> searchMovies(
    String query, {
    int page = 1,
    bool includeAdult = false,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.searchMovie,
        queryParameters: {
          'query': query,
          'include_adult': includeAdult,
          'language': 'en-US',
          'page': page,
        },
      );
      return MovieResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetch movie details with credits and videos appended in 1 single call
  Future<MovieDetailModel> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.movieDetails}/$movieId',
        queryParameters: {
          'language': 'en-US',
          'append_to_response': 'credits,videos',
        },
      );
      return MovieDetailModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetch genre list for movie classification
  Future<List<GenreModel>> getGenres() async {
    try {
      final response = await _dio.get(
        ApiConstants.genreList,
        queryParameters: {
          'language': 'en',
        },
      );
      final rawGenres = response.data['genres'] as List<dynamic>? ?? [];
      return rawGenres
          .map((g) => GenreModel.fromJson(g as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }
}
