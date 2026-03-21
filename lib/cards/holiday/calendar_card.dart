import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/holiday_provider.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class HolidayCalendarCard extends ConsumerWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  const HolidayCalendarCard({
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holidayMap = ref.watch(holidayProvider);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kBrown.withAlpha((0.07 * 255).toInt()),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          focusedDay: selectedDate,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          selectedDayPredicate: (day) => isSameDay(day, selectedDate),
          onDaySelected: (selected, _) => onDateSelected(selected),
          daysOfWeekHeight: 32,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: kBrown,
              fontWeight: FontWeight.w600,
              fontFamily: kFontFamily,
              fontSize: 14,
              height: 1.2,
            ),
            weekendStyle: TextStyle(
              color: kPink,
              fontWeight: FontWeight.w600,
              fontFamily: kFontFamily,
              fontSize: 14,
              height: 1.2,
            ),
            decoration: BoxDecoration(
              color: kWhiteGrey,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: kWhiteGrey,
              shape: BoxShape.circle,
              border: Border.all(color: kBrown, width: 2),
            ),
            selectedDecoration: BoxDecoration(
              color: kPink,
              shape: BoxShape.circle,
              border: Border.all(color: kBrown, width: 2),
              boxShadow: [
                BoxShadow(
                  color: kPink.withAlpha((0.2 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            markerDecoration: BoxDecoration(
              color: kPink,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 1,
            outsideDaysVisible: false,
            todayTextStyle: TextStyle(color: kBrown, fontWeight: FontWeight.bold, fontFamily: kFontFamily),
            selectedTextStyle: TextStyle(color: kWhite, fontWeight: FontWeight.bold, fontFamily: kFontFamily),
            weekendTextStyle: TextStyle(color: kPink, fontFamily: kFontFamily),
            defaultTextStyle: TextStyle(color: kBlack, fontFamily: kFontFamily),
            withinRangeTextStyle: TextStyle(color: kBrown, fontFamily: kFontFamily),
            disabledTextStyle: TextStyle(color: kWhiteGrey, fontFamily: kFontFamily),
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(color: kBlack, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: kFontFamily),
            formatButtonDecoration: BoxDecoration(
              color: kWhiteGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kBrown),
            ),
            formatButtonTextStyle: TextStyle(color: kBrown, fontWeight: FontWeight.w600, fontFamily: kFontFamily),
            leftChevronIcon: const Icon(Iconsax.arrow_left, color: kBrown, size: 20),
            rightChevronIcon: const Icon(Iconsax.arrow_right, color: kBrown, size: 20),
            headerPadding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: kWhiteGrey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              final normalizedDate = DateTime(date.year, date.month, date.day);
              if (holidayMap[normalizedDate] != null) {
                return Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        color: kPink,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kPink.withAlpha((0.3 * 255).toInt()),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
            selectedBuilder: (context, date, _) {
              return Container(
                decoration: BoxDecoration(
                  color: kPink,
                  shape: BoxShape.circle,
                  border: Border.all(color: kBrown, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: kPink.withAlpha((0.2 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                  border: Border.all(color: kBrown, width: 2),
                ),
                child: Center(
                  child: Icon(Iconsax.calendar, color: kBrown, size: 18),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
