import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/app_bar.dart';
import '../../cards/holiday/calendar_card.dart';
import '../../cards/holiday/detail_card.dart';
import '../../provider/holiday_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/loader.dart';

class HolidayScreen extends ConsumerStatefulWidget {
  const HolidayScreen({super.key});

  @override
  ConsumerState<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends ConsumerState<HolidayScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentIndex = 2;
  final bool _isLoading = false;

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    final router = GoRouter.of(context);
    switch (index) {
      case 0:
        router.go('/dashboard');
        break;
      case 1:
        router.go('/my-attendance');
        break;
      case 2:
        // Already on Holidays
        break;
      case 3:
        router.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final holidayMap = ref.watch(holidayProvider);
    final normalizedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final holiday = holidayMap[normalizedDate];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.go('/dashboard');
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: kWhite,
            appBar: const PremiumAppBar(
              title: 'Holidays',
              subtitle: 'View upcoming holidays',
              logoAssetPath: '',
              actions: [],
              showBackIcon: false,
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
            floatingActionButton: SizedBox(
              height: 56,
              child: FloatingActionButton.extended(
                onPressed: () {
                  GoRouter.of(context).go('/request-holiday');
                },
                backgroundColor: kPink,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                icon: const Icon(Iconsax.logout, color: Colors.white, size: 28),
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Request Leave',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: kFontFamily,
                      fontSize: 18,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
            ),
          ),
          if (_isLoading) const AppLoader(subText: 'Loading holidays...'),
        ],
      ),
    );
  }
}
