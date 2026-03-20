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
    return Card(
      color: kWhite,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Iconsax.login, color: kDarkGrey, size: 20),
                const SizedBox(width: 8),
                Text('Check-In:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Text(
                  attendance!.checkIn != null ? attendance!.checkIn!.toLocal().toString().substring(11, 16) : 'N/A',
                  style: TextStyle(color: kDarkGrey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Iconsax.logout, color: kDarkGrey, size: 20),
                const SizedBox(width: 8),
                Text('Check-Out:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Text(
                  attendance!.checkOut != null ? attendance!.checkOut!.toLocal().toString().substring(11, 16) : 'N/A',
                  style: TextStyle(color: kDarkGrey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Iconsax.location, color: kDarkGrey, size: 20),
                const SizedBox(width: 8),
                Text('Location:', style: TextStyle(color: kBlack, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    attendance!.location,
                    style: TextStyle(color: kGrey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
