import 'package:flutter/material.dart';

import '../../../data/models/movie_detail_model.dart';
import '../../../utilities/themes/app_spacing.dart';
import '../../../widgets/cards/cast_card.dart';

class DetailCastSection extends StatelessWidget {
  const DetailCastSection({super.key, required this.detail});
  final MovieDetailModel detail;
  @override
  Widget build(BuildContext context) {
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
