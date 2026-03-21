import 'package:flutter/material.dart';
import '../../models/attendance.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class AttendanceCard extends StatelessWidget {
  final Attendance? attendance;
  const AttendanceCard({required this.attendance, super.key});

  @override
  Widget build(BuildContext context) {
    if (attendance == null) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kBrown.withAlpha((0.08 * 255).toInt()),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        color: kWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                colors: [kBrown, kBlack],
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
                  child: const Icon(Iconsax.tick_circle, color: kBrown, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Attendance Details',
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
                    Container(
                      decoration: BoxDecoration(
                        color: kWhiteGrey,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Iconsax.login, color: kBrown, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('Check-In:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Text(
                      attendance!.checkIn != null ? attendance!.checkIn!.toLocal().toString().substring(11, 16) : 'N/A',
                      style: TextStyle(color: kBrown, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kWhiteGrey,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Iconsax.logout, color: kBrown, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('Check-Out:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Text(
                      attendance!.checkOut != null ? attendance!.checkOut!.toLocal().toString().substring(11, 16) : 'N/A',
                      style: TextStyle(color: kBrown, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kWhiteGrey,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Iconsax.location, color: kBrown, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('Location:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        attendance!.location,
                        style: TextStyle(color: kBrown, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
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
