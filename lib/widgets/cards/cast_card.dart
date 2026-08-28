import 'package:flutter/material.dart';
import '../../data/models/cast_model.dart';
import '../../utilities/themes/app_spacing.dart';
import '../media/cast_avatar.dart';

class CastCard extends StatelessWidget {
  final CastModel cast;

  const CastCard({
    super.key,
    required this.cast,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CastAvatar(
            profilePath: cast.profilePath,
            name: cast.name,
            radius: 36,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
          if (cast.character != null && cast.character!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              cast.character!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
