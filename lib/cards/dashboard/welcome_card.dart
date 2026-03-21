import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class WelcomeCard extends StatelessWidget {
	final String userName;
	final Color cardColor;
	const WelcomeCard({required this.userName, this.cardColor = kBrown, super.key});

	@override
	Widget build(BuildContext context) {
		return Card(
			color: cardColor,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
			elevation: 3,
			margin: const EdgeInsets.symmetric(vertical: 8),
			child: Padding(
				padding: const EdgeInsets.all(20.0),
				child: Row(
					children: [
						Container(
							decoration: BoxDecoration(
								color: kGreen,
								borderRadius: BorderRadius.circular(12),
							),
							padding: const EdgeInsets.all(10),
							child: const Icon(Iconsax.user, color: kWhite, size: 32),
						),
						const SizedBox(width: 18),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text('Hello, $userName!', style: kHeaderTextStyle.copyWith(color: kBlack, fontSize: 22)),
									const SizedBox(height: 2),
									Text('Ready to record your attendance today?', style: kTaglineTextStyle.copyWith(color: kBrown)),
								],
							),
						),
					],
				),
			),
		);
	}
}
