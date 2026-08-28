import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/movie_model.dart';
import '../../../utilities/themes/app_spacing.dart';
import '../../../utilities/util.dart';
import '../../../widgets/states/error_state_view.dart';
import '../../../widgets/states/loading_spinner_view.dart';
import '../controllers/movie_detail_provider.dart';
import '../widgets/detail_backdrop_header.dart';
import '../widgets/detail_cast_section.dart';
import '../widgets/detail_header_info.dart';
import '../widgets/detail_overview_section.dart';
import '../widgets/detail_stats_section.dart';
import '../widgets/detail_videos_section.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  final MovieModel? initialMovie;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    this.initialMovie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final ScrollController _scrollController;
  late final MovieDetailProvider _detailProvider;

  @override
  void initState() {
    super.initState();
    // Requirement 3: Properly initialize controllers
    _scrollController = ScrollController();
    _detailProvider = MovieDetailProvider();

    // Fetch movie details after frame build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detailProvider.fetchMovieDetails(widget.movieId);
    });
  }

  @override
  void dispose() {
    // Requirement 3: Properly dispose controllers and providers
    _scrollController.dispose();
    _detailProvider.dispose();
    super.dispose();
  }

  Future<void> _playVideo(String videoUrl) async {
    final success = await AppUtils.launchUrlStringSafe(videoUrl);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text('Could not open video: $videoUrl'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return ChangeNotifierProvider.value(
      value: _detailProvider,
      child: Scaffold(
        body: Stack(
          children: [
            // Detail Content
            Consumer<MovieDetailProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && widget.initialMovie == null) {
                  return const LoadingSpinnerView(
                    message: 'Loading movie details...',
                  );
                }

                if (provider.isError && widget.initialMovie == null) {
                  return ErrorStateView(
                    message: provider.errorMessage,
                    onRetry: () => provider.fetchMovieDetails(widget.movieId),
                  );
                }

                final detail = provider.movieDetail;
                final movie = detail?.toMovieModel() ?? widget.initialMovie;

                if (movie == null) {
                  return const Center(child: Text('Movie not found'));
                }

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Backdrop Header with Play Trailer Button
                      DetailBackdropHeader(
                        detail: detail,
                        movie: movie,
                        onPlayVideo: _playVideo,
                      ),
                      // Movie Header Info (Poster, Title, Rating, Watchlist Toggle)
                      DetailHeaderInfo(detail: detail, movie: movie),
                      // Storyline & Tagline & Genres
                      DetailOverviewSection(detail: detail, movie: movie),
                      // Box Office Stats (Budget, Revenue, Status)
                      if (detail != null) DetailStatsSection(detail: detail),
                      // Trailers & Videos Carousel
                      if (detail != null && detail.youtubeVideos.isNotEmpty)
                        DetailVideosSection(
                          detail: detail,
                          onPlayVideo: _playVideo,
                        ),
                      // Cast Carousel (Horizontal ListView.builder)
                      if (detail != null && detail.cast.isNotEmpty)
                        DetailCastSection(detail: detail),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                );
              },
            ),

            // Requirement 4: Graceful notch-safe Back Button
            Positioned(
              top: topPadding + 8,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
