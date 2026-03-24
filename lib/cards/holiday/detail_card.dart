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
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kPink.withAlpha((0.13 * 255).toInt()),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        color: kWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sleek header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              color: kGreen,
              boxShadow: [
                BoxShadow(
                  color: kPink.withAlpha((0.18 * 255).toInt()),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kPink.withAlpha((0.15 * 255).toInt()),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Iconsax.calendar, color: kPink, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    holiday!.title,
                    style: kHeaderTextStyle.copyWith(
                      color: kWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.info_circle, color: kPink, size: 20),
                    const SizedBox(width: 10),
                    Text('Remarks:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600, fontFamily: kFontFamily)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        holiday!.remarks ?? '-',
                        style: TextStyle(color: kBrown, fontWeight: FontWeight.w500, fontFamily: kFontFamily),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Iconsax.calendar, color: kPink, size: 20),
                    const SizedBox(width: 10),
                    Text('Date:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600, fontFamily: kFontFamily)),
                    const SizedBox(width: 8),
                    Text(
                      '${holiday!.date.day}/${holiday!.date.month}/${holiday!.date.year}',
                      style: TextStyle(color: kBrown, fontWeight: FontWeight.w500, fontFamily: kFontFamily),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
