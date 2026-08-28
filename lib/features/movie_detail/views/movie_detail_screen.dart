import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/movie_detail_model.dart';
import '../../../data/models/movie_model.dart';
import '../../../data/models/video_model.dart';
import '../../../utilities/themes/app_colors.dart';
import '../../../utilities/themes/app_radii.dart';
import '../../../utilities/themes/app_spacing.dart';
import '../../../utilities/themes/app_text_styles.dart';
import '../../../utilities/util.dart';
import '../../../widgets/buttons/watchlist_toggle_button.dart';
import '../../../widgets/cards/cast_card.dart';
import '../../../widgets/media/cached_backdrop_image.dart';
import '../../../widgets/media/cached_movie_poster.dart';
import '../../../widgets/misc/genre_chip.dart';
import '../../../widgets/misc/rating_badge.dart';
import '../../../widgets/states/error_state_view.dart';
import '../../../widgets/states/loading_spinner_view.dart';
import '../controllers/movie_detail_provider.dart';

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
                      // Backdrop Header
                      _buildBackdropHeader(context, detail, movie),
                      // Movie Info & Poster Overlap
                      _buildMovieHeaderInfo(context, detail, movie),
                      // Tagline & Overview
                      _buildOverviewSection(context, detail, movie),
                      // Stats Row (Runtime, Budget, Revenue, Status)
                      if (detail != null) _buildStatsSection(context, detail),
                      // Trailers & Videos Section (Horizontal ListView.builder)
                      if (detail != null && detail.youtubeVideos.isNotEmpty)
                        _buildVideosSection(context, detail),
                      // Cast Carousel (Horizontal ListView.builder)
                      if (detail != null && detail.cast.isNotEmpty)
                        _buildCastSection(context, detail),
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

  Widget _buildBackdropHeader(
    BuildContext context,
    MovieDetailModel? detail,
    MovieModel movie,
  ) {
    final trailer = detail?.trailerVideo;

    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedBackdropImage(
            backdropPath: detail?.backdropPath ?? movie.backdropPath,
            height: 280,
            showGradient: true,
          ),
          // Play Trailer Button if trailer video exists
          if (trailer != null && trailer.key.isNotEmpty)
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _playVideo(trailer.youtubeUrl),
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                label: Text(
                  trailer.type.isNotEmpty
                      ? 'Play ${trailer.type}'
                      : 'Play Trailer',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm + 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.radiusRound,
                  ),
                  elevation: 4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMovieHeaderInfo(
    BuildContext context,
    MovieDetailModel? detail,
    MovieModel movie,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster Thumbnail (Hero Animation)
          Hero(
            tag: 'movie_poster_${movie.id}',
            child: CachedMoviePoster(
              posterPath: detail?.posterPath ?? movie.posterPath,
              width: 110,
              height: 165,
              borderRadius: AppRadii.radiusMd,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Title, Rating, and Action
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail?.title ?? movie.title,
                  style: AppTextStyles.heroTitle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    RatingBadge(
                      rating: detail?.voteAverage ?? movie.voteAverage,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (detail != null && detail.formattedRuntime.isNotEmpty)
                      Text(
                        detail.formattedRuntime,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                if (movie.releaseDate != null)
                  Text(
                    AppUtils.formatDate(movie.releaseDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                // Watchlist Toggle Action Button
                WatchlistToggleButton(movie: movie, isCircle: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(
    BuildContext context,
    MovieDetailModel? detail,
    MovieModel movie,
  ) {
    final theme = Theme.of(context);
    final tagline = detail?.tagline;
    final overview = detail?.overview.isNotEmpty == true
        ? detail!.overview
        : movie.overview;

    return Padding(
      padding: AppSpacing.edgeInsetsScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tagline != null && tagline.isNotEmpty) ...[
            Text(
              '"$tagline"',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          // Genres Chips
          if (detail != null && detail.genres.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: detail.genres
                  .map((g) => GenreChip(label: g.name))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const Text(
            'Storyline',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            overview.isNotEmpty ? overview : 'No overview available.',
            style: AppTextStyles.body.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, MovieDetailModel detail) {
    final theme = Theme.of(context);

    return Container(
      margin: AppSpacing.edgeInsetsScreen,
      padding: AppSpacing.edgeInsetsAllMd,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: theme.dividerColor, width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(context, 'Budget', AppUtils.formatCurrency(detail.budget)),
          _statItem(
            context,
            'Revenue',
            AppUtils.formatCurrency(detail.revenue),
          ),
          _statItem(context, 'Status', detail.status ?? 'Released'),
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildVideosSection(BuildContext context, MovieDetailModel detail) {
    final videos = detail.youtubeVideos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Text(
            'Trailers & Videos',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return _videoThumbnailCard(video);
            },
          ),
        ),
      ],
    );
  }

  Widget _videoThumbnailCard(VideoModel video) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: InkWell(
        onTap: () => _playVideo(video.youtubeUrl),
        borderRadius: AppRadii.radiusMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: AppRadii.radiusMd,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: video.youtubeThumbnailUrl,
                    width: 180,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 180,
                      height: 100,
                      color: Colors.black26,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 180,
                      height: 100,
                      color: Colors.black45,
                      child: const Icon(
                        Icons.videocam_off,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (video.type.isNotEmpty)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: AppRadii.radiusSm,
                        ),
                        child: Text(
                          video.type,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              video.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCastSection(BuildContext context, MovieDetailModel detail) {
    final castList = detail.cast;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Text(
            'Top Cast',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 135,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: castList.length,
            itemBuilder: (context, index) {
              return CastCard(cast: castList[index]);
            },
          ),
        ),
      ],
    );
  }
}
