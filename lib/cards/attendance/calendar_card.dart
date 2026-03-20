import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/attendance_provider.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class CalendarCard extends ConsumerWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  const CalendarCard({
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceMap = ref.watch(attendanceProvider);
    return Card(
      color: kWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TableCalendar(
        focusedDay: selectedDate,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        selectedDayPredicate: (day) => isSameDay(day, selectedDate),
        onDaySelected: (selected, _) => onDateSelected(selected),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: kWhiteGrey,
            shape: BoxShape.circle,
            border: Border.all(color: kDarkGrey, width: 2),
          ),
          selectedDecoration: BoxDecoration(
            color: kDarkGrey,
            shape: BoxShape.circle,
            border: Border.all(color: kBlack, width: 2),
          ),
          markerDecoration: BoxDecoration(
            color: kBlack,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 1,
          outsideDaysVisible: false,
          todayTextStyle: TextStyle(color: kDarkGrey, fontWeight: FontWeight.bold),
          selectedTextStyle: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
          weekendTextStyle: TextStyle(color: kGrey),
          defaultTextStyle: TextStyle(color: kBlack),
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(color: kBlack, fontWeight: FontWeight.bold, fontSize: 16),
          formatButtonDecoration: BoxDecoration(
            color: kWhiteGrey,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kDarkGrey),
          ),
          formatButtonTextStyle: TextStyle(color: kDarkGrey, fontWeight: FontWeight.w600),
          leftChevronIcon: const Icon(Iconsax.arrow_left, color: kDarkGrey, size: 20),
          rightChevronIcon: const Icon(Iconsax.arrow_right, color: kDarkGrey, size: 20),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (attendanceMap[date] != null) {
              return Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: kBlack,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
            return null;
          },
          selectedBuilder: (context, date, _) {
            return Container(
              decoration: BoxDecoration(
                color: kDarkGrey,
                shape: BoxShape.circle,
                border: Border.all(color: kBlack, width: 2),
              ),
              child: Center(
                child: Icon(Iconsax.tick_circle, color: kWhite, size: 18),
              ),
            );
          },
          todayBuilder: (context, date, _) {
            return Container(
              decoration: BoxDecoration(
                color: kWhiteGrey,
                shape: BoxShape.circle,
                border: Border.all(color: kDarkGrey, width: 2),
              ),
              child: Center(
                child: Icon(Iconsax.calendar, color: kDarkGrey, size: 18),
              ),
            );
          },
        ),
      ),
    );
  }
}
