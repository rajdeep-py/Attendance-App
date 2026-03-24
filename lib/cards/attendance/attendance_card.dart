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
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: kWhite,
          boxShadow: [
            BoxShadow(
              color: kerror.withAlpha((0.13 * 255).toInt()),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Iconsax.info_circle, color: kerror, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'No attendance check in and check out.',
                style: kHeaderTextStyle.copyWith(
                  color: kerror,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
    // Determine present/absent
    final bool isPresent = attendance!.checkIn != null;
    final Color statusColor = isPresent ? kGreen : kerror;

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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Icon(
                  isPresent ? Iconsax.tick_circle : Iconsax.close_circle,
                  color: statusColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  isPresent ? 'Present' : 'Absent',
                  style: kHeaderTextStyle.copyWith(
                    color: statusColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (attendance!.checkIn != null)
                  Text(
                    _formatTime(attendance!.checkIn!),
                    style: kHeaderTextStyle.copyWith(
                      color: kText,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: kGrey.withAlpha(2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.location, color: kPrimary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        attendance!.location.isNotEmpty ? attendance!.location : 'No location',
                        style: kBodyTextStyle.copyWith(fontSize: 15, color: kText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Iconsax.login, color: kGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Check-in: ',
                      style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      attendance!.checkIn != null ? _formatDateTime(attendance!.checkIn!) : 'N/A',
                      style: kBodyTextStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Iconsax.logout, color: kerror, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Check-out: ',
                      style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      attendance!.checkOut != null ? _formatDateTime(attendance!.checkOut!) : 'N/A',
                      style: kBodyTextStyle,
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

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
