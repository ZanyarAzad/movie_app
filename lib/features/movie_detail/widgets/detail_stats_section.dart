import 'package:flutter/material.dart';
import '../../../data/models/movie_detail_model.dart';
import '../../../utilities/themes/app_radii.dart';
import '../../../utilities/themes/app_spacing.dart';
import '../../../utilities/util.dart';

class DetailStatsSection extends StatelessWidget {
  final MovieDetailModel detail;

  const DetailStatsSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
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
}
