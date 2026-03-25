
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
						color: kBlack.withAlpha((0.28 * 255).toInt()),
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
											color: kBlack.withAlpha((0.18 * 255).toInt()),
											blurRadius: 24,
											spreadRadius: 2,
										),
									],
									gradient: const LinearGradient(
										colors: [kWhiteGrey, kWhite],
										begin: Alignment.topLeft,
										end: Alignment.bottomRight,
									),
								),
								child: Padding(
									padding: const EdgeInsets.all(16.0),
									child: Image.asset(
										'assets/logo/A24.png',
										fit: BoxFit.contain,
									),
								),
							),
							const SizedBox(height: 28),
							CircularProgressIndicator(
								valueColor: const AlwaysStoppedAnimation<Color>(kBrown),
								strokeWidth: 4.5,
								backgroundColor: kWhiteGrey.withAlpha((0.18 * 255).toInt()),
							),
							const SizedBox(height: 24),
							Text(
								subText,
								style: kHeaderTextStyle.copyWith(
									color: kWhite,
									fontSize: 10,
									fontWeight: FontWeight.w900,
									letterSpacing: 0.2,
									shadows: [
										Shadow(
											color: kBlack.withAlpha((0.18 * 255).toInt()),
											blurRadius: 4,
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
