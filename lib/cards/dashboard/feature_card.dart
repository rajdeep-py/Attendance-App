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
			elevation: 8,
			margin: const EdgeInsets.symmetric(vertical: 8),
			child: Padding(
				padding: const EdgeInsets.all(20.0),
				child: Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Container(
							decoration: BoxDecoration(
								color: kBrown,
								borderRadius: BorderRadius.circular(12),
							),
							padding: const EdgeInsets.all(10),
							child: const Icon(Iconsax.info_circle, color: kWhiteGrey, size: 32),
						),
						const SizedBox(width: 18),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text('How Attendance Works', style: kHeaderTextStyle.copyWith(color: kBlack, fontSize: 18)),
									const SizedBox(height: 8),
									Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Row(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													const Icon(Iconsax.location, color: kBrown, size: 20),
													const SizedBox(width: 8),
													Expanded(
														child: Text(
															'Check In and Check Out record your attendance with your location.',
															style: kDescriptionTextStyle.copyWith(color: kBrown),
														),
													),
												],
											),
											const SizedBox(height: 8),
											Row(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													const Icon(Iconsax.calendar, color: kBrown, size: 20),
													const SizedBox(width: 8),
													Expanded(
														child: Text(
															'Holiday list is available in the app.',
															style: kDescriptionTextStyle.copyWith(color: kBrown),
														),
													),
												],
											),
											const SizedBox(height: 8),
											Row(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													const Icon(Iconsax.document, color: kBrown, size: 20),
													const SizedBox(width: 8),
													Expanded(
														child: Text(
															'Attendance records are securely stored and accessible anytime.',
															style: kDescriptionTextStyle.copyWith(color: kBrown),
														),
													),
												],
											),
										],
									),
								],
							),
						),
					],
				),
			),
		);
	}
}
