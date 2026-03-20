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
			backgroundColor: kDarkGrey,
			selectedItemColor: kWhite,
			unselectedItemColor: kWhiteGrey,
			showSelectedLabels: true,
			showUnselectedLabels: true,
			items: const [
				BottomNavigationBarItem(
					icon: Icon(Iconsax.category),
					label: 'Dashboard',
				),
				BottomNavigationBarItem(
					icon: Icon(Iconsax.tick_circle),
					label: 'My Attendance',
				),
				BottomNavigationBarItem(
					icon: Icon(Iconsax.calendar),
					label: 'Holidays',
				),
				BottomNavigationBarItem(
					icon: Icon(Iconsax.user),
					label: 'Profile',
				),
			],
			type: BottomNavigationBarType.fixed,
			elevation: 8,
		);
	}
}
