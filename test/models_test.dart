import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/data/models/movie_detail_model.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_response.dart';

void main() {
  group('TMDB Model Parsing Tests', () {
    test('MovieModel parses JSON correctly', () {
      final json = {
        'id': 860508,
        'title': 'The Whisper Man',
        'overview': 'A widower enlists help...',
        'poster_path': '/6UqflU8Qqkz7Dq4swJPqs0ZJjY4.jpg',
        'backdrop_path': '/uauoVKKCkNA9iWjgJCL8TdSfLf5.jpg',
        'vote_average': 5.944,
        'vote_count': 9,
        'release_date': '2026-08-27',
        'genre_ids': [53, 80, 18],
      };

      final movie = MovieModel.fromJson(json);
      expect(movie.id, equals(860508));
      expect(movie.title, equals('The Whisper Man'));
      expect(movie.releaseYear, equals('2026'));
      expect(movie.formattedRating, equals('5.9'));
      expect(movie.posterUrl, contains('w500/6UqflU8Qqkz7Dq4swJPqs0ZJjY4.jpg'));
    });

    test('MovieResponse parses paginated JSON correctly', () {
      final json = {
        'page': 1,
        'results': [
          {
            'id': 27205,
            'title': 'Inception',
            'overview': 'Cobb, a skilled thief...',
            'poster_path': '/xlaY2zyzMfkhk0HSC5VUwzoZPU1.jpg',
            'vote_average': 8.372,
            'vote_count': 40008,
            'release_date': '2010-07-15',
            'genre_ids': [28, 878, 12],
          },
        ],
        'total_pages': 500,
        'total_results': 10000,
      };

      final response = MovieResponse.fromJson(json);
      expect(response.page, equals(1));
      expect(response.totalPages, equals(500));
      expect(response.results.length, equals(1));
      expect(response.hasMore, isTrue);
      expect(response.results.first.title, equals('Inception'));
    });

    test('MovieDetailModel parses credits and videos correctly', () {
      final json = {
        'id': 27205,
        'title': 'Inception',
        'overview': 'Cobb, a skilled thief...',
        'runtime': 148,
        'budget': 160000000,
        'revenue': 839030630,
        'tagline': 'Your mind is the scene of the crime.',
        'genres': [
          {'id': 28, 'name': 'Action'},
          {'id': 878, 'name': 'Science Fiction'},
        ],
        'credits': {
          'cast': [
            {
              'id': 6193,
              'name': 'Leonardo DiCaprio',
              'character': 'Dom Cobb',
              'profile_path': '/wo2hJpn04vbtmh0B9utCFdsQhxM.jpg',
            },
          ],
          'crew': [],
        },
        'videos': {
          'results': [
            {
              'id': '622d5cc322931a00454e588c',
              'key': 'mpj9dL7swwk',
              'name': 'The Dream Sequence',
              'site': 'YouTube',
              'type': 'Trailer',
              'official': true,
            },
          ],
        },
      };

      final detail = MovieDetailModel.fromJson(json);
      expect(detail.id, equals(27205));
      expect(detail.formattedRuntime, equals('2h 28m'));
      expect(detail.cast.length, equals(1));
      expect(detail.cast.first.name, equals('Leonardo DiCaprio'));
      expect(detail.trailerVideo?.key, equals('mpj9dL7swwk'));
      expect(
        detail.trailerVideo?.youtubeUrl,
        equals('https://www.youtube.com/watch?v=mpj9dL7swwk'),
      );
    });
  });
}
