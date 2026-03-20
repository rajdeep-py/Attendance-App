import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
			onTap: onTap,
			backgroundColor: kDarkGrey,
			selectedItemColor: kWhite,
			unselectedItemColor: kWhiteGrey,
			showSelectedLabels: true,
			showUnselectedLabels: true,
			items: const [
				BottomNavigationBarItem(
					icon: Icon(Icons.dashboard_outlined),
					label: 'Dashboard',
				),
				BottomNavigationBarItem(
					icon: Icon(Icons.check_circle_outline),
					label: 'My Attendance',
				),
				BottomNavigationBarItem(
					icon: Icon(Icons.calendar_today),
					label: 'Holidays',
				),
				BottomNavigationBarItem(
					icon: Icon(Icons.person_outline),
					label: 'Profile',
				),
			],
			type: BottomNavigationBarType.fixed,
			elevation: 8,
		);
	}
}
