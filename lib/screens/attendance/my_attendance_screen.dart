import '../../widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../provider/profile_provider.dart';
import '../../widgets/app_bar.dart';
import '../../cards/attendance/calendar_card.dart';
import '../../cards/attendance/attendance_card.dart';
import '../../provider/attendance_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class MyAttendanceScreen extends ConsumerStatefulWidget {
  const MyAttendanceScreen({super.key});

  @override
  ConsumerState<MyAttendanceScreen> createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends ConsumerState<MyAttendanceScreen> {
      bool _isLoading = false;
    Future<void> _refreshAttendance() async {
      setState(() => _isLoading = true);
      final user = ref.read(profileProvider);
      if (user?.employeeId != null) {
        await ref.read(attendanceProvider.notifier).fetchAttendanceByEmployee(user!.employeeId!);
      }
      if (mounted) setState(() => _isLoading = false);
    }
  DateTime _selectedDate = DateTime.now();
  int _currentIndex = 1;


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
        router.go('/holidays');
        break;
      case 3:
        router.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceMap = ref.watch(attendanceProvider);
    final normalizedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final attendance = attendanceMap[normalizedDate];
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        
          context.go('/dashboard');
        },
      
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: PremiumAppBar(
              title: 'My Attendance',
              subtitle: 'View your daily records',
              logoAssetPath: '',
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.refresh, color: Colors.black),
                  onPressed: _refreshAttendance,
                  tooltip: 'Refresh',
                ),
              ],
              showBackIcon: false,
            ),
            body: Column(
              children: [
                CalendarCard(
                  selectedDate: _selectedDate,
                  onDateSelected: _onDateSelected,
                  onRefresh: _refreshAttendance,
                ),
                AttendanceCard(attendance: attendance),
              ],
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
            ),
          ),
          if (_isLoading) const AppLoader(subText: 'Loading attendance...'),
        ],
      ),
    );
  }
}
