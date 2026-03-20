import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
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
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
			elevation: 8,
			margin: const EdgeInsets.symmetric(vertical: 8),
			child: Padding(
				padding: const EdgeInsets.all(20.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								Container(
									decoration: BoxDecoration(
										color: kDarkGrey,
										borderRadius: BorderRadius.circular(12),
									),
									padding: const EdgeInsets.all(8),
									child: const Icon(Iconsax.clock, color: kWhiteGrey, size: 28),
								),
								const SizedBox(width: 12),
								Text('Attendance', style: kHeaderTextStyle.copyWith(color: kBlack, fontSize: 22)),
							],
						),
						const SizedBox(height: 18),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Row(
											children: [
												const Icon(Iconsax.login, color: kDarkGrey, size: 20),
												const SizedBox(width: 6),
												Text('Check In:', style: kCaptionTextStyle.copyWith(color: kGrey)),
											],
										),
										Text(
											attendance.checkIn != null ? attendance.checkIn!.toLocal().toString().substring(0, 16) : '--',
											style: kDescriptionTextStyle.copyWith(color: kBlack),
										),
									],
								),
								ElevatedButton.icon(
									style: ElevatedButton.styleFrom(
										backgroundColor: attendance.checkIn == null ? kDarkGrey : kWhiteGrey,
										foregroundColor: attendance.checkIn == null ? kWhite : kGrey,
										minimumSize: const Size(120, 48),
										padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
										shape: RoundedRectangleBorder(
											borderRadius: BorderRadius.circular(16),
										),
										textStyle: const TextStyle(
											fontFamily: kFontFamily,
											fontWeight: FontWeight.bold,
											fontSize: 16,
										),
										elevation: 6,
									),
									onPressed: attendance.checkIn == null
											? () {
													ref.read(dashboardProvider.notifier).checkIn(DateTime.now(), 'Current Location');
												}
											: null,
									icon: const Icon(Iconsax.login, size: 20),
									label: const Text('Check In'),
								),
							],
						),
						const SizedBox(height: 18),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Row(
											children: [
												const Icon(Iconsax.logout, color: kDarkGrey, size: 20),
												const SizedBox(width: 6),
												Text('Check Out:', style: kCaptionTextStyle.copyWith(color: kGrey)),
											],
										),
										Text(
											attendance.checkOut != null ? attendance.checkOut!.toLocal().toString().substring(0, 16) : '--',
											style: kDescriptionTextStyle.copyWith(color: kBlack),
										),
									],
								),
								ElevatedButton.icon(
									style: ElevatedButton.styleFrom(
										backgroundColor: attendance.checkIn != null && attendance.checkOut == null ? kDarkGrey : kWhiteGrey,
										foregroundColor: attendance.checkIn != null && attendance.checkOut == null ? kWhite : kGrey,
										minimumSize: const Size(120, 48),
										padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
										shape: RoundedRectangleBorder(
											borderRadius: BorderRadius.circular(16),
										),
										textStyle: const TextStyle(
											fontFamily: kFontFamily,
											fontWeight: FontWeight.bold,
											fontSize: 16,
										),
										elevation: 6,
									),
									onPressed: attendance.checkIn != null && attendance.checkOut == null
											? () {
													ref.read(dashboardProvider.notifier).checkOut(DateTime.now());
												}
											: null,
									icon: const Icon(Iconsax.logout, size: 20),
									label: const Text('Check Out'),
								),
							],
						),
					],
				),
			),
		);
	}
}
