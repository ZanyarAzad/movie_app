import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../data/models/movie_detail_model.dart';
import '../../../data/models/video_model.dart';
import '../../../utilities/themes/app_colors.dart';
import '../../../utilities/themes/app_radii.dart';
import '../../../utilities/themes/app_spacing.dart';

class DetailVideosSection extends StatelessWidget {
  final MovieDetailModel detail;
  final ValueChanged<String> onPlayVideo;

  const DetailVideosSection({
    super.key,
    required this.detail,
    required this.onPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    final videos = detail.youtubeVideos;

    if (videos.isEmpty) return const SizedBox.shrink();

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
        onTap: () => onPlayVideo(video.youtubeUrl),
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
}
