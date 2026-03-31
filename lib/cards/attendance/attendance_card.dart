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
            Icon(Iconsax.user_octagon, color: kBrown.withAlpha(80), size: 48),
            const SizedBox(height: 12),
            Text(
              'No Record Found',
              style: kHeaderTextStyle.copyWith(
                fontSize: 18,
                color: kBrown.withAlpha(150),
              ),
            ),
          ],
        ),
      );
    }

    final bool isPresent = attendance!.checkIn != null;
    final Color statusColor = isPresent ? kGreen : kerror;
    final IconData statusIcon = isPresent
        ? Iconsax.verify
        : Iconsax.close_circle;

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
            // Colored Status Line on Left
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 6, color: statusColor),
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
                          color: statusColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(statusIcon, color: statusColor, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPresent ? 'Present' : 'Absent',
                              style: kHeaderTextStyle.copyWith(
                                fontSize: 22,
                                color: kBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (isPresent) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Logged for ${_formatTime(attendance!.checkIn!)}',
                                style: kTaglineTextStyle.copyWith(
                                  fontSize: 14,
                                  color: kBrown.withAlpha(180),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isPresent && attendance!.checkOut != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: kWhiteGrey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Completed',
                            style: kCaptionTextStyle.copyWith(
                              color: kBrown,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: kWhiteGrey, thickness: 1.5, height: 1),
                  const SizedBox(height: 16),

                  // Timestamps
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeBox(
                          icon: Iconsax.login,
                          color: kGreen,
                          title: 'Check In',
                          time: attendance!.checkIn != null
                              ? _formatDateTime(attendance!.checkIn!)
                              : '--:--',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimeBox(
                          icon: Iconsax.logout,
                          color: kerror,
                          title: 'Check Out',
                          time: attendance!.checkOut != null
                              ? _formatDateTime(attendance!.checkOut!)
                              : '--:--',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox({
    required IconData icon,
    required Color color,
    required String title,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhiteGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: kCaptionTextStyle.copyWith(
                  color: kBrown.withAlpha(150),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: kBodyTextStyle.copyWith(
              color: kBlack,
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
