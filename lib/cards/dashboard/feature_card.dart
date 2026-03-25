import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class FeatureCard extends StatelessWidget {
	final Color cardColor;
	const FeatureCard({this.cardColor = kBrown, super.key});

	@override
	Widget build(BuildContext context) {
		return Card(
			color: cardColor,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
			elevation: 2,
			margin: const EdgeInsets.symmetric(vertical: 8),
			child: Padding(
				padding: const EdgeInsets.all(20.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								Container(
									decoration: BoxDecoration(
										color: kPink,
										borderRadius: BorderRadius.circular(12),
									),
									padding: const EdgeInsets.all(10),
									child: const Icon(Iconsax.info_circle, color: kGreen, size: 32),
								),
								const SizedBox(width: 18),
								Text('App Features', style: kHeaderTextStyle.copyWith(color: kBrown, fontSize: 22)),
							],
						),
						const SizedBox(height: 16),
						_featureRow(Iconsax.login, 'Check in to start your shift. You must be within 10 meters of the store and upload a selfie.'),
						_featureRow(Iconsax.location, 'Check in/out only works in close proximity to the store.'),
						_featureRow(Iconsax.camera, 'Upload a selfie for both check in and check out.'),
						_featureRow(Iconsax.logout, 'Check out at the end of your day by uploading a selfie.'),
						_featureRow(Iconsax.calendar, 'Apply for leaves and view the full holiday calendar of Manju Medical Stores & Digital Clinic.'),
						_featureRow(Iconsax.document, 'See your attendance record in brief.'),
						_featureRow(Iconsax.wallet, 'Download your salary slips.'),
					],
				),
			),
		);
	}
}

// Helper widget for feature row
Widget _featureRow(IconData icon, String text) {
	return Padding(
		padding: const EdgeInsets.only(bottom: 10),
		child: Row(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Icon(icon, color: kPink, size: 20),
				const SizedBox(width: 10),
				Expanded(
					child: Text(
						text,
						style: kDescriptionTextStyle.copyWith(color: kBrown),
					),
				),
			],
		),
	);
}