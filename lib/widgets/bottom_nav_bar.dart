import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
	final int currentIndex;
	final Function(int) onTap;
	const BottomNavBar({
		required this.currentIndex,
		required this.onTap,
		super.key,
	});

	@override
	Widget build(BuildContext context) {
		return BottomNavigationBar(
			currentIndex: currentIndex,
			onTap: (index) {
				onTap(index);
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
			},
			backgroundColor: kWhite,
			selectedItemColor: kDarkGrey,
			unselectedItemColor: kGrey,
			showSelectedLabels: true,
			showUnselectedLabels: true,
			items: [
				BottomNavigationBarItem(
					icon: Container(
						decoration: BoxDecoration(
							color: currentIndex == 0 ? kDarkGrey.withAlpha(30) : Colors.transparent,
							borderRadius: BorderRadius.circular(12),
						),
						padding: const EdgeInsets.all(8),
						child: Icon(Iconsax.category, color: currentIndex == 0 ? kDarkGrey : kGrey, size: 26),
					),
					label: 'Dashboard',
				),
				BottomNavigationBarItem(
					icon: Container(
						decoration: BoxDecoration(
							color: currentIndex == 1 ? kDarkGrey.withAlpha(30) : Colors.transparent,
							borderRadius: BorderRadius.circular(12),
						),
						padding: const EdgeInsets.all(8),
						child: Icon(Iconsax.tick_circle, color: currentIndex == 1 ? kDarkGrey : kGrey, size: 26),
					),
					label: 'My Attendance',
				),
				BottomNavigationBarItem(
					icon: Container(
						decoration: BoxDecoration(
							color: currentIndex == 2 ? kDarkGrey.withAlpha(30) : Colors.transparent,
							borderRadius: BorderRadius.circular(12),
						),
						padding: const EdgeInsets.all(8),
						child: Icon(Iconsax.calendar, color: currentIndex == 2 ? kDarkGrey : kGrey, size: 26),
					),
					label: 'Holidays',
				),
				BottomNavigationBarItem(
					icon: Container(
						decoration: BoxDecoration(
							color: currentIndex == 3 ? kDarkGrey.withAlpha(30) : Colors.transparent,
							borderRadius: BorderRadius.circular(12),
						),
						padding: const EdgeInsets.all(8),
						child: Icon(Iconsax.user, color: currentIndex == 3 ? kDarkGrey : kGrey, size: 26),
					),
					label: 'Profile',
				),
			],
			type: BottomNavigationBarType.fixed,
			elevation: 16,
			selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: kFontFamily),
			unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontFamily: kFontFamily),
		);
	}
}
