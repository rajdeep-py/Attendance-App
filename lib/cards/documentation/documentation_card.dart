import 'package:flutter/material.dart';

import '../../models/documentation.dart';
import '../../theme/app_theme.dart';

class DocumentationCard extends StatelessWidget {
  final Documentation documentation;
  const DocumentationCard({required this.documentation, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kPink.withAlpha((0.07 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: kWhiteGrey.withAlpha((0.9 * 255).toInt()),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            documentation.docHeader,
            style: kHeaderTextStyle.copyWith(
              fontSize: 17,
              color: kBrown,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            documentation.docDescription,
            style: kDescriptionTextStyle.copyWith(
              color: kBlack.withAlpha((0.85 * 255).toInt()),
              fontSize: 15,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
