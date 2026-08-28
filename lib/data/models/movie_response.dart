import 'movie_model.dart';

class MovieResponse {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  const MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as List<dynamic>? ?? [];
    final movies = rawResults
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return MovieResponse(
      page: json['page'] as int? ?? 1,
      results: movies,
      totalPages: json['total_pages'] as int? ?? 1,
      totalResults: json['total_results'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': results.map((e) => e.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }

  bool get hasMore => page < totalPages;
  bool get isEmpty => results.isEmpty;
}
