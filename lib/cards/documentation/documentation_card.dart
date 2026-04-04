import 'package:flutter/material.dart';

import '../../models/documentation.dart';
import '../../theme/app_theme.dart';

class DocumentationCard extends StatelessWidget {
  final Documentation documentation;
  const DocumentationCard({required this.documentation, super.key});

  List<String> _descriptionBullets(String description) {
    final normalized = description.replaceAll('\n', ' ').trim();
    if (normalized.isEmpty) return const [];

    return normalized
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final bullets = _descriptionBullets(documentation.docDescription);
    final showBullets =
        documentation.docDescription.contains(',') && bullets.isNotEmpty;

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
              color: kGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (!showBullets)
            Text(
              documentation.docDescription,
              style: kDescriptionTextStyle.copyWith(
                color: kBlack.withAlpha((0.85 * 255).toInt()),
                fontSize: 15,
                height: 1.35,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final bullet in bullets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '•  ',
                          style: kDescriptionTextStyle.copyWith(
                            color: kBlack.withAlpha((0.85 * 255).toInt()),
                            fontSize: 15,
                            height: 1.35,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            bullet,
                            style: kDescriptionTextStyle.copyWith(
                              color: kBlack.withAlpha((0.85 * 255).toInt()),
                              fontSize: 15,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
