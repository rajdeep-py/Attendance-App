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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kDarkGrey.withAlpha((0.08 * 255).toInt()),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        color: kWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                colors: [Colors.redAccent, kDarkGrey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kWhiteGrey,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Iconsax.calendar, color: Colors.redAccent, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  holiday!.name,
                  style: TextStyle(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 0.5,
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
                    const Icon(Iconsax.info_circle, color: kDarkGrey, size: 20),
                    const SizedBox(width: 10),
                    Text('Occasion:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        holiday!.occasion,
                        style: TextStyle(color: kGrey, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Iconsax.calendar, color: kDarkGrey, size: 20),
                    const SizedBox(width: 10),
                    Text('Date:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Text(
                      '${holiday!.date.day}/${holiday!.date.month}/${holiday!.date.year}',
                      style: TextStyle(color: kDarkGrey, fontWeight: FontWeight.w500),
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
