import 'package:flutter/material.dart';
import '../../models/attendance.dart';
import '../../models/break_time.dart'; // import BreakTime model
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class AttendanceCard extends StatelessWidget {
  final Attendance? attendance;
  final List<BreakTime>? dailyBreaks; // add daily breaks argument
  const AttendanceCard({required this.attendance, this.dailyBreaks, super.key});

  String _capitalize(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return '${trimmed[0].toUpperCase()}${trimmed.substring(1)}';
  }

  ({String label, Color color, IconData icon}) _statusUi(Attendance a) {
    final raw = (a.status ?? '').trim();
    final normalized = raw.toLowerCase();

    switch (normalized) {
      case 'present':
        return (label: 'Present', color: kGreen, icon: Iconsax.verify);
      case 'absent':
        return (label: 'Absent', color: kerror, icon: Iconsax.close_circle);
      case 'rejected':
        return (label: 'Rejected', color: kerror, icon: Iconsax.close_circle);
      case 'approved':
        return (label: 'Approved', color: kGreen, icon: Iconsax.verify);
      case 'pending':
        return (label: 'Pending', color: kBrown, icon: Iconsax.info_circle);
      default:
        if (raw.isNotEmpty) {
          return (
            label: _capitalize(raw),
            color: kBrown,
            icon: Iconsax.info_circle,
          );
        }

        // Fallback for older/partial payloads.
        if (a.checkIn != null) {
          return (label: 'Present', color: kGreen, icon: Iconsax.verify);
        }
        return (label: 'Absent', color: kerror, icon: Iconsax.close_circle);
    }
  }

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

    final statusUi = _statusUi(attendance!);
    final bool hasCheckIn = attendance!.checkIn != null;

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
              child: Container(width: 6, color: statusUi.color),
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
                          color: statusUi.color.withAlpha(25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          statusUi.icon,
                          color: statusUi.color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statusUi.label,
                              style: kHeaderTextStyle.copyWith(
                                fontSize: 22,
                                color: kBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (hasCheckIn) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Checked in at ${_formatTime(attendance!.checkIn!)}',
                                style: kTaglineTextStyle.copyWith(
                                  fontSize: 14,
                                  color: kBrown.withAlpha(180),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (attendance!.checkOut != null)
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

                  // Break Timestamps
                  if (dailyBreaks != null && dailyBreaks!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(color: kWhiteGrey, thickness: 1.5, height: 1),
                    const SizedBox(height: 16),
                    ...dailyBreaks!.map(
                      (b) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTimeBox(
                                icon: Iconsax.cup,
                                color: kGreen,
                                title: 'Break Start',
                                time: b.breakInTime != null
                                    ? _formatTime(b.breakInTime!)
                                    : '--:--',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTimeBox(
                                icon: Iconsax.stop,
                                color: kerror,
                                title: 'Break End',
                                time: b.breakOutTime != null
                                    ? _formatTime(b.breakOutTime!)
                                    : '--:--',
                              ),
                            ),
                          ],
                        ),
                      ),
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
