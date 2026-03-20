import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
	const SplashScreen({super.key});

	@override
	State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
	late AnimationController _controller;
	late Animation<double> _logoScale;
	late Animation<double> _logoFade;

	@override
	void initState() {
		super.initState();
		_controller = AnimationController(
			vsync: this,
			duration: const Duration(milliseconds: 1800),
		);
		_logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
			CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
		);
		_logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
			CurvedAnimation(parent: _controller, curve: Curves.easeIn),
		);
		_controller.forward();
		Future.delayed(const Duration(milliseconds: 2500), () {
			if (mounted) {
				context.go('/login');
			}
		});
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: kWhite,
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						AnimatedBuilder(
							animation: _controller,
							builder: (context, child) => Transform.scale(
								scale: _logoScale.value,
								child: Opacity(
									opacity: _logoFade.value,
									child: child,
								),
							),
							child: Image.asset(
								'assets/logo/logo_no_bg.png',
								width: 400,
								height: 400,
							),
						),
						const SizedBox(height: 24),
						Text(
							'Naiyo24 Attendance',
							style: kHeaderTextStyle.copyWith(color: kBlack),
						),
					],
				),
			),
		);
	}
}
