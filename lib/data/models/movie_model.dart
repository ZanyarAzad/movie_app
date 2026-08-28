import '../../core/constants/api_constants.dart';

class MovieModel {
  final int id;
  final String title;
  final String? originalTitle;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final List<int> genreIds;
  final String? releaseDate;
  final double voteAverage;
  final int voteCount;
  final double? popularity;
  final bool adult;
  final bool video;
  final String? originalLanguage;

  const MovieModel({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview = '',
    this.posterPath,
    this.backdropPath,
    this.genreIds = const [],
    this.releaseDate,
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.popularity,
    this.adult = false,
    this.video = false,
    this.originalLanguage,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int? ?? 0,
      title:
          json['title'] as String? ?? json['original_title'] as String? ?? '',
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      genreIds:
          (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      popularity: (json['popularity'] as num?)?.toDouble(),
      adult: json['adult'] as bool? ?? false,
      video: json['video'] as bool? ?? false,
      originalLanguage: json['original_language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'popularity': popularity,
      'adult': adult,
      'video': video,
      'original_language': originalLanguage,
    };
  }

  // Helper Getters
  String get posterUrl => ApiConstants.getPosterUrl(posterPath);
  String get backdropUrl => ApiConstants.getBackdropUrl(backdropPath);
  String get formattedRating => voteAverage.toStringAsFixed(1);

  String get releaseYear {
    if (releaseDate != null && releaseDate!.length >= 4) {
      return releaseDate!.substring(0, 4);
    }
    return '';
  }

  MovieModel copyWith({
    int? id,
    String? title,
    String? originalTitle,
    String? overview,
    String? posterPath,
    String? backdropPath,
    List<int>? genreIds,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    double? popularity,
    bool? adult,
    bool? video,
    String? originalLanguage,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      genreIds: genreIds ?? this.genreIds,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      popularity: popularity ?? this.popularity,
      adult: adult ?? this.adult,
      video: video ?? this.video,
      originalLanguage: originalLanguage ?? this.originalLanguage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
