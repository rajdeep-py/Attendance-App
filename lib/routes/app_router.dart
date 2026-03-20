import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';

final GoRouter appRouter = GoRouter(
	initialLocation: '/splash',
	routes: [
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
	],
);
