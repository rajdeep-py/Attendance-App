
import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
	final String subText;
	const AppLoader({
		this.subText = 'Please wait...'
	, super.key});

	@override
	Widget build(BuildContext context) {
		return Stack(
			children: [
				// Transparent dark overlay
				Positioned.fill(
					child: Container(
						color: Colors.black.withAlpha(35),
					),
				),
				// Centered loader content
				Center(
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							Container(
								width: 90,
								height: 90,
								decoration: BoxDecoration(
									shape: BoxShape.circle,
									boxShadow: [
										BoxShadow(
											color: Colors.black.withAlpha(46),
											blurRadius: 24,
											spreadRadius: 2,
										),
									],
									gradient: const LinearGradient(
										colors: [Color.fromARGB(255, 143, 142, 142), Color.fromARGB(255, 212, 212, 212)],
										begin: Alignment.topLeft,
										end: Alignment.bottomRight,
									),
								),
								child: Padding(
									padding: const EdgeInsets.all(16.0),
									child: Image.asset(
										'assets/logo/naiyo24_logo.png',
										fit: BoxFit.contain,
									),
								),
							),
							const SizedBox(height: 28),
							const CircularProgressIndicator(
								valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 29, 28, 27)),
								strokeWidth: 4.5,
								backgroundColor: Colors.white24,
							),
							const SizedBox(height: 24),
							Text(
								subText,
								style: const TextStyle(
									color: Colors.white,
									fontSize: 18,
									fontWeight: FontWeight.w600,
									letterSpacing: 0.2,
									shadows: [
										Shadow(
											color: Colors.black38,
											blurRadius: 8,
										),
									],
								),
								textAlign: TextAlign.center,
							),
						],
					),
				),
			],
		);
	}
}
