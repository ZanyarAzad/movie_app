import 'package:flutter/material.dart';
import '../../utilities/themes/app_colors.dart';
import '../../utilities/themes/app_radii.dart';
import '../../utilities/themes/app_spacing.dart';

class MovieShimmerList extends StatefulWidget {
  final int itemCount;
  final bool isHorizontal;

  const MovieShimmerList({
    super.key,
    this.itemCount = 6,
    this.isHorizontal = false,
  });

  @override
  State<MovieShimmerList> createState() => _MovieShimmerListState();
}

class _MovieShimmerListState extends State<MovieShimmerList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight;
    final highlightColor =
        isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return widget.isHorizontal
            ? _buildHorizontalList(baseColor, highlightColor)
            : _buildVerticalList(baseColor, highlightColor);
      },
    );
  }

  Widget _buildVerticalList(Color baseColor, Color highlightColor) {
    return ListView.builder(
      padding: AppSpacing.edgeInsetsScreen,
      itemCount: widget.itemCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: AppSpacing.edgeInsetsAllSm,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: AppRadii.radiusMd,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster skeleton
              _shimmerBox(
                width: 80,
                height: 120,
                borderRadius: AppRadii.radiusSm,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(width: AppSpacing.md),
              // Content skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xs),
                    _shimmerBox(
                      width: double.infinity,
                      height: 16,
                      borderRadius: AppRadii.radiusSm,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _shimmerBox(
                      width: 100,
                      height: 12,
                      borderRadius: AppRadii.radiusSm,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _shimmerBox(
                      width: double.infinity,
                      height: 10,
                      borderRadius: AppRadii.radiusSm,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _shimmerBox(
                      width: 160,
                      height: 10,
                      borderRadius: AppRadii.radiusSm,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHorizontalList(Color baseColor, Color highlightColor) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: widget.itemCount,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            width: 130,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(
                  width: 130,
                  height: 185,
                  borderRadius: AppRadii.radiusMd,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
                const SizedBox(height: AppSpacing.sm),
                _shimmerBox(
                  width: 100,
                  height: 14,
                  borderRadius: AppRadii.radiusSm,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
                const SizedBox(height: AppSpacing.xs),
                _shimmerBox(
                  width: 50,
                  height: 10,
                  borderRadius: AppRadii.radiusSm,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    required BorderRadius borderRadius,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor,
            highlightColor,
            baseColor,
          ],
          stops: [
            (_controller.value - 0.3).clamp(0.0, 1.0),
            _controller.value,
            (_controller.value + 0.3).clamp(0.0, 1.0),
          ],
        ),
      ),
    );
  }
}
