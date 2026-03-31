import 'package:flutter/material.dart';
import '../../models/holiday.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class HolidayDetailCard extends StatelessWidget {
  final Holiday? holiday;
  const HolidayDetailCard({required this.holiday, super.key});

  @override
  Widget build(BuildContext context) {
    if (holiday == null) {
      // Return a sleek empty state placeholder when no holiday is selected
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kBrown.withAlpha(15), width: 1),
          boxShadow: [
            BoxShadow(
              color: kBlack.withAlpha(10),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Iconsax.calendar_remove,
              color: kBrown.withAlpha(80),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'No Holiday Selected',
              style: kHeaderTextStyle.copyWith(
                fontSize: 18,
                color: kBrown.withAlpha(150),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBrown.withAlpha(15), width: 1),
        boxShadow: [
          BoxShadow(
            color: kBlack.withAlpha(15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Left decorative border line
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 6, color: kGreen),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kGreen.withAlpha(25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Iconsax.calendar_tick,
                          color: kGreen,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              holiday!.title,
                              style: kHeaderTextStyle.copyWith(
                                fontSize: 22,
                                color: kBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${holiday!.date.day}/${holiday!.date.month}/${holiday!.date.year}',
                              style: kTaglineTextStyle.copyWith(
                                fontSize: 14,
                                color: kBrown.withAlpha(180),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (holiday!.remarks != null &&
                      holiday!.remarks!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Divider(color: kWhiteGrey, thickness: 1.5, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Iconsax.info_circle,
                          color: kBrown,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            holiday!.remarks!,
                            style: kBodyTextStyle.copyWith(
                              color: kBlack.withAlpha(200),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
