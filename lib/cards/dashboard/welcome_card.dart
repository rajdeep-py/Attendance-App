import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class WelcomeCard extends StatelessWidget {
	final String userName;
	final Color cardColor;
	const WelcomeCard({required this.userName, this.cardColor = kDarkGrey, super.key});

	@override
	Widget build(BuildContext context) {
		return Card(
			color: cardColor,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			elevation: 4,
			margin: const EdgeInsets.symmetric(vertical: 8),
			child: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Hello, $userName!', style: kHeaderTextStyle.copyWith(color: kBlack, fontSize: 22)),
						const SizedBox(height: 8),
						Text('Ready to record your attendance today?', style: kTaglineTextStyle.copyWith(color: kGrey)),
					],
				),
			),
		);
	}
}
