import '../../core/constants/api_constants.dart';
import 'cast_model.dart';
import 'genre_model.dart';
import 'movie_model.dart';
import 'video_model.dart';

class MovieDetailModel {
  final int id;
  final String title;
  final String? originalTitle;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;
  final int voteCount;
  final double? popularity;
  final bool adult;
  final List<GenreModel> genres;
  final int? runtime;
  final String? tagline;
  final int budget;
  final int revenue;
  final String? status;
  final String? homepage;
  final String? imdbId;
  final List<CastModel> cast;
  final List<CrewModel> crew;
  final List<VideoModel> videos;

  const MovieDetailModel({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview = '',
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.popularity,
    this.adult = false,
    this.genres = const [],
    this.runtime,
    this.tagline,
    this.budget = 0,
    this.revenue = 0,
    this.status,
    this.homepage,
    this.imdbId,
    this.cast = const [],
    this.crew = const [],
    this.videos = const [],
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    // Parse genres
    final genreList =
        (json['genres'] as List<dynamic>?)
            ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    // Parse credits if present (from append_to_response=credits,videos)
    List<CastModel> castList = const [];
    List<CrewModel> crewList = const [];
    if (json['credits'] != null && json['credits'] is Map<String, dynamic>) {
      final creditsMap = json['credits'] as Map<String, dynamic>;
      castList =
          (creditsMap['cast'] as List<dynamic>?)
              ?.map((e) => CastModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [];
      crewList =
          (creditsMap['crew'] as List<dynamic>?)
              ?.map((e) => CrewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [];
    }

    // Parse videos if present (from append_to_response=credits,videos)
    List<VideoModel> videoList = const [];
    if (json['videos'] != null && json['videos'] is Map<String, dynamic>) {
      final videosMap = json['videos'] as Map<String, dynamic>;
      videoList =
          (videosMap['results'] as List<dynamic>?)
              ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [];
    }

    return MovieDetailModel(
      id: json['id'] as int? ?? 0,
      title:
          json['title'] as String? ?? json['original_title'] as String? ?? '',
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      popularity: (json['popularity'] as num?)?.toDouble(),
      adult: json['adult'] as bool? ?? false,
      genres: genreList,
      runtime: json['runtime'] as int?,
      tagline: json['tagline'] as String?,
      budget: json['budget'] as int? ?? 0,
      revenue: json['revenue'] as int? ?? 0,
      status: json['status'] as String?,
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
      cast: castList,
      crew: crewList,
      videos: videoList,
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
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'popularity': popularity,
      'adult': adult,
      'genres': genres.map((e) => e.toJson()).toList(),
      'runtime': runtime,
      'tagline': tagline,
      'budget': budget,
      'revenue': revenue,
      'status': status,
      'homepage': homepage,
      'imdb_id': imdbId,
      'credits': {
        'cast': cast.map((e) => e.toJson()).toList(),
        'crew': crew.map((e) => e.toJson()).toList(),
      },
      'videos': {'results': videos.map((e) => e.toJson()).toList()},
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

  String get formattedRuntime {
    if (runtime == null || runtime! <= 0) return '';
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  List<VideoModel> get youtubeVideos =>
      videos.where((v) => v.isYouTube && v.key.isNotEmpty).toList();

  VideoModel? get trailerVideo {
    final list = youtubeVideos;
    if (list.isEmpty) return null;

    for (final v in list) {
      if (v.isTrailer && v.official) return v;
    }
    for (final v in list) {
      if (v.isTrailer) return v;
    }
    for (final v in list) {
      final type = v.type.toLowerCase();
      if (type == 'teaser' || type == 'clip' || type == 'featurette') {
        return v;
      }
    }
    return list.first;
  }

  MovieModel toMovieModel() {
    return MovieModel(
      id: id,
      title: title,
      originalTitle: originalTitle,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      genreIds: genres.map((g) => g.id).toList(),
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
      popularity: popularity,
      adult: adult,
    );
  }
}
