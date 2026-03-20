import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../provider/dashboard_provider.dart';

class CheckInOutCard extends ConsumerWidget {
	final Color cardColor;
	const CheckInOutCard({this.cardColor = kDarkGrey, super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final attendance = ref.watch(dashboardProvider);
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
						Text('Attendance', style: kHeaderTextStyle.copyWith(color: kWhite, fontSize: 20)),
						const SizedBox(height: 12),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text('Check In:', style: kCaptionTextStyle.copyWith(color: kWhiteGrey)),
										Text(
											attendance.checkIn != null ? attendance.checkIn!.toLocal().toString().substring(0, 16) : '--',
											style: kDescriptionTextStyle.copyWith(color: kWhite),
										),
									],
								),
								ElevatedButton(
									style: kPremiumButtonStyle,
									onPressed: attendance.checkIn == null
											? () {
													ref.read(dashboardProvider.notifier).checkIn(DateTime.now(), 'Current Location');
												}
											: null,
									child: const Text('Check In'),
								),
							],
						),
						const SizedBox(height: 16),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text('Check Out:', style: kCaptionTextStyle.copyWith(color: kWhiteGrey)),
										Text(
											attendance.checkOut != null ? attendance.checkOut!.toLocal().toString().substring(0, 16) : '--',
											style: kDescriptionTextStyle.copyWith(color: kWhite),
										),
									],
								),
								ElevatedButton(
									style: kPremiumButtonStyle,
									onPressed: attendance.checkIn != null && attendance.checkOut == null
											? () {
													ref.read(dashboardProvider.notifier).checkOut(DateTime.now());
												}
											: null,
									child: const Text('Check Out'),
								),
							],
						),
					],
				),
			),
		);
	}
}
