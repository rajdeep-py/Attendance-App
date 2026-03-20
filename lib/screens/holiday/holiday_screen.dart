import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../cards/holiday/calendar_card.dart';
import '../../cards/holiday/detail_card.dart';
import '../../provider/holiday_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_nav_bar.dart';

class HolidayScreen extends ConsumerStatefulWidget {
  const HolidayScreen({super.key});

  @override
  ConsumerState<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends ConsumerState<HolidayScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentIndex = 2;

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    final router = Navigator.of(context);
    switch (index) {
      case 0:
        router.pushReplacementNamed('/dashboard');
        break;
      case 1:
        router.pushReplacementNamed('/my-attendance');
        break;
      case 2:
        // Already on Holidays
        break;
      case 3:
        router.pushReplacementNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final holidayMap = ref.watch(holidayProvider);
    final normalizedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final holiday = holidayMap[normalizedDate];
    return Scaffold(
      backgroundColor: kWhite,
      appBar: const PremiumAppBar(
        title: 'Holidays',
        subtitle: 'View upcoming holidays',
        showBackIcon: false,
        logoAssetPath: 'assets/logo/logo_no_bg.png',
      ),
      body: Column(
        children: [
          HolidayCalendarCard(
            selectedDate: _selectedDate,
            onDateSelected: _onDateSelected,
          ),
          HolidayDetailCard(holiday: holiday),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
