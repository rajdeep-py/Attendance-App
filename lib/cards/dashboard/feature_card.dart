import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FeatureCard extends StatelessWidget {
	final Color cardColor;
	const FeatureCard({this.cardColor = kDarkGrey, super.key});

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
						Text('How Attendance Works', style: kHeaderTextStyle.copyWith(color: kBlack, fontSize: 18)),
						const SizedBox(height: 8),
						Text(
							'• Check In and Check Out record your attendance with your location.\n'
							'• Holiday list is available in the app.\n'
							'• Attendance records are securely stored and accessible anytime.',
							style: kDescriptionTextStyle.copyWith(color: kGrey),
						),
					],
				),
			),
		);
	}
}
