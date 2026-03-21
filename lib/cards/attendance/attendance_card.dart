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
    // Determine present/absent
    final bool isPresent = attendance!.checkIn != null;
    final bool _ = attendance!.checkIn == null;
    final Color statusColor = isPresent ? kGreen : kerror;
    final String statusText = isPresent ? 'Present' : 'Absent';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: statusColor.withAlpha((0.13 * 255).toInt()),
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
              color: statusColor,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withAlpha((0.18 * 255).toInt()),
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
                        color: statusColor.withAlpha((0.15 * 255).toInt()),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isPresent ? Iconsax.tick_circle : Iconsax.close_circle,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Attendance Details',
                  style: kHeaderTextStyle.copyWith(
                    color: kWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: kFontFamily,
                      fontSize: 14,
                    ),
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
                      child: Icon(Iconsax.login, color: isPresent ? kGreen : kerror, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('Check-In:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600, fontFamily: kFontFamily)),
                    const SizedBox(width: 8),
                    Text(
                      attendance!.checkIn != null ? attendance!.checkIn!.toLocal().toString().substring(11, 16) : 'N/A',
                      style: TextStyle(color: isPresent ? kGreen : kerror, fontWeight: FontWeight.w500, fontFamily: kFontFamily),
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
                      child: Icon(Iconsax.logout, color: isPresent ? kGreen : kerror, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('Check-Out:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600, fontFamily: kFontFamily)),
                    const SizedBox(width: 8),
                    Text(
                      attendance!.checkOut != null ? attendance!.checkOut!.toLocal().toString().substring(11, 16) : 'N/A',
                      style: TextStyle(color: isPresent ? kGreen : kerror, fontWeight: FontWeight.w500, fontFamily: kFontFamily),
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
                      child: Icon(Iconsax.location, color: kBrown, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('Location:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600, fontFamily: kFontFamily)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        attendance!.location,
                        style: TextStyle(color: kBrown, fontWeight: FontWeight.w500, fontFamily: kFontFamily),
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
