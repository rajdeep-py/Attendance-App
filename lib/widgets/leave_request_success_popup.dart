import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class LeaveRequestSuccessPopup extends StatelessWidget {
	const LeaveRequestSuccessPopup({super.key});

	@override
	Widget build(BuildContext context) {
		return Dialog(
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
			backgroundColor: kWhite,
			child: Padding(
				padding: const EdgeInsets.all(24),
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Icon(Icons.check_circle, color: kGreen, size: 56),
						const SizedBox(height: 16),
						Text(
							'Leave request submitted!',
							style: kHeaderTextStyle.copyWith(fontSize: 20, color: kGreen),
							textAlign: TextAlign.center,
						),
						const SizedBox(height: 12),
						Text(
							'The admin will review your application and notify you if it is approved.',
							style: kDescriptionTextStyle.copyWith(color: kBrown, fontSize: 16),
							textAlign: TextAlign.center,
						),
						const SizedBox(height: 24),
						SizedBox(
							width: double.infinity,
								child: ElevatedButton(
									style: kPremiumButtonStyle,
									onPressed: () {
										Navigator.of(context).pop(); // Dismiss the dialog first
										context.go('/dashboard');
									},
									child: const Text('Okay'),
								),
						),
					],
				),
			),
		);
	}
}
