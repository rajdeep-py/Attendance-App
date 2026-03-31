import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/attendance_provider.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class CalendarCard extends ConsumerWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Future<void> Function()? onRefresh;

  const CalendarCard({
    required this.selectedDate,
    required this.onDateSelected,
    this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceMap = ref.watch(attendanceProvider);

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          focusedDay: selectedDate,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          selectedDayPredicate: (day) => isSameDay(day, selectedDate),
          onDaySelected: (selected, _) => onDateSelected(selected),
          daysOfWeekHeight: 40,
          rowHeight: 52,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: kCaptionTextStyle.copyWith(
              color: kBrown,
              fontWeight: FontWeight.bold,
            ),
            weekendStyle: kCaptionTextStyle.copyWith(
              color: kBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: kGreen.withAlpha(25),
              shape: BoxShape.circle,
            ),
            todayTextStyle: kBodyTextStyle.copyWith(
              color: kGreen,
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: const BoxDecoration(
              color: kBlack,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: kBodyTextStyle.copyWith(
              color: kWhite,
              fontWeight: FontWeight.bold,
            ),
            defaultTextStyle: kBodyTextStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
            weekendTextStyle: kBodyTextStyle.copyWith(
              color: kBrown,
              fontWeight: FontWeight.w600,
            ),
            cellMargin: const EdgeInsets.all(6),
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: kHeaderTextStyle.copyWith(
              fontSize: 20,
              color: kBlack,
            ),
            formatButtonVisible: false,
            leftChevronIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kWhiteGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Iconsax.arrow_left_2, color: kBlack, size: 18),
            ),
            rightChevronIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kWhiteGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Iconsax.arrow_right_3, color: kBlack, size: 18),
            ),
            headerPadding: const EdgeInsets.only(bottom: 16),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              final normalizedDate = DateTime(date.year, date.month, date.day);
              final att = attendanceMap[normalizedDate];
              if (att != null) {
                final isPresent = att.checkIn != null;
                final isSelected = isSameDay(date, selectedDate);
                final markerColor = isPresent ? kGreen : kerror;

                return Positioned(
                  bottom: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected ? kWhite : markerColor,
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? []
                          : [
                              BoxShadow(
                                color: markerColor.withAlpha(100),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
