import 'package:flutter/material.dart';
import '../../models/holiday_request.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class MyHolidayCard extends StatelessWidget {
  final HolidayRequest request;
  const MyHolidayCard({required this.request, super.key});

  String get _statusLabel {
    final raw = (request.status ?? '').trim();
    if (raw.isEmpty) return 'Pending';

    final normalized = raw.toLowerCase();
    switch (normalized) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending';
      default:
        return raw;
    }
  }

  Color get _statusColor {
    switch (_statusLabel.toLowerCase()) {
      case 'approved':
        return kGreen;
      case 'rejected':
        return kerror;
      default:
        return kBrown;
    }
  }

  String get _secondaryMessage {
    final message = request.message.trim();
    final reason = request.reason.trim();
    if (message.isEmpty || message.toLowerCase() == reason.toLowerCase()) {
      return '';
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kGreen.withAlpha((0.08 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: kBlack, shape: BoxShape.circle),
            padding: const EdgeInsets.all(10),
            child: const Icon(Iconsax.calendar, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _formatDate(request.date),
                      style: kHeaderTextStyle.copyWith(
                        fontSize: 16,
                        color: kBrown,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withAlpha((0.15 * 255).toInt()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          color: _statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: kFontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Iconsax.info_circle, color: kPink, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      request.reason,
                      style: TextStyle(
                        color: kBrown,
                        fontWeight: FontWeight.w600,
                        fontFamily: kFontFamily,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_secondaryMessage.isNotEmpty)
                  Text(
                    _secondaryMessage,
                    style: kDescriptionTextStyle.copyWith(
                      color: kBlack.withAlpha((0.85 * 255).toInt()),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} '
        '${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
