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
        break;
      case 3:
        router.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final holidayMap = ref.watch(holidayProvider);
    final normalizedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final holiday = holidayMap[normalizedDate];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.go('/dashboard');
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: kWhiteGrey,
            appBar: const PremiumAppBar(
              title: 'Holidays',
              subtitle: 'View upcoming holidays',
              logoAssetPath: '',
              actions: [],
              showBackIcon: false,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    HolidayCalendarCard(
                      selectedDate: _selectedDate,
                      onDateSelected: _onDateSelected,
                    ),
                    const SizedBox(height: 16),
                    HolidayDetailCard(holiday: holiday),
                    const SizedBox(height: 100), // padding for FAB
                  ],
                ),
              ),
            ),
            floatingActionButton: Container(
              height: 58,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: kGreen.withAlpha(75),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: FloatingActionButton.extended(
                onPressed: () {
                  GoRouter.of(context).go('/request-holiday');
                },
                backgroundColor: kGreen,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                icon: const Icon(Iconsax.add_circle, color: kWhite, size: 28),
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'Request Leave',
                    style: kHeaderTextStyle.copyWith(
                      color: kWhite,
                      fontSize: 16,
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
