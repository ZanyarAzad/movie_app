import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import '../../utilities/themes/app_colors.dart';

class CastAvatar extends StatelessWidget {
  final String? profilePath;
  final String name;
  final double radius;

  const CastAvatar({
    super.key,
    required this.profilePath,
    required this.name,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final url = ApiConstants.getProfileUrl(profilePath);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (url.isEmpty) {
      return _buildFallback(isDark);
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: isDark
                ? AppColors.shimmerBaseDark
                : AppColors.shimmerBaseLight,
          ),
          errorWidget: (context, url, error) => _buildFallback(isDark),
        ),
      ),
    );
  }

  Widget _buildFallback(bool isDark) {
    final initials = name.isNotEmpty
        ? name
              .trim()
              .split(' ')
              .take(2)
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .join()
        : '?';

    return CircleAvatar(
      radius: radius,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightBorder,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.7,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }
}
