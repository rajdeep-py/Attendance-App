import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/attendance/my_attendance_screen.dart';
import '../screens/holiday/holiday_screen.dart';
import '../screens/holiday/request_holiday_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/profile/profile_screen.dart';

final GoRouter appRouter = GoRouter(
	initialLocation: '/splash',
	routes: [
		  GoRoute(
				path: '/notifications',
				pageBuilder: (context, state) => CustomTransitionPage(
				child: const NotificationScreen(),
				transitionsBuilder: (context, animation, secondaryAnimation, child) {
					return FadeTransition(opacity: animation, child: child);
				  },
				),
      ),
      GoRoute(
			path: '/splash',
			pageBuilder: (context, state) => CustomTransitionPage(
				child: const SplashScreen(),
				transitionsBuilder: (context, animation, secondaryAnimation, child) {
					return FadeTransition(opacity: animation, child: child);
				},
			),
		),
		GoRoute(
			path: '/login',
			pageBuilder: (context, state) => CustomTransitionPage(
				child: const LoginScreen(),
				transitionsBuilder: (context, animation, secondaryAnimation, child) {
					return SlideTransition(
						position: Tween<Offset>(
							begin: const Offset(0, 1),
							end: Offset.zero,
						).animate(animation),
						child: child,
					);
				},
			),
		),
		   GoRoute(
			   path: '/dashboard',
			   pageBuilder: (context, state) => CustomTransitionPage(
				   child: const DashboardScreen(),
				   transitionsBuilder: (context, animation, secondaryAnimation, child) {
					   return FadeTransition(opacity: animation, child: child);
				   },
			   ),
		   ),
		   GoRoute(
			   path: '/my-attendance',
			   pageBuilder: (context, state) => CustomTransitionPage(
				   child: const MyAttendanceScreen(),
				   transitionsBuilder: (context, animation, secondaryAnimation, child) {
					   return FadeTransition(opacity: animation, child: child);
				   },
			   ),
		   ),
		   GoRoute(
			   path: '/holidays',
			   pageBuilder: (context, state) => CustomTransitionPage(
				   child: const HolidayScreen(),
				   transitionsBuilder: (context, animation, secondaryAnimation, child) {
					   return FadeTransition(opacity: animation, child: child);
				   },
			   ),
		   ),
		   GoRoute(
			   path: '/request-holiday',
			   pageBuilder: (context, state) => CustomTransitionPage(
				   child: const RequestHolidayScreen(),
				   transitionsBuilder: (context, animation, secondaryAnimation, child) {
					   return FadeTransition(opacity: animation, child: child);
				   },
			   ),
		   ),
		GoRoute(
			path: '/profile',
			pageBuilder: (context, state) => CustomTransitionPage(
				child: const ProfileScreen(),
				transitionsBuilder: (context, animation, secondaryAnimation, child) {
					return FadeTransition(opacity: animation, child: child);
				},
			),
		),
	],
);
