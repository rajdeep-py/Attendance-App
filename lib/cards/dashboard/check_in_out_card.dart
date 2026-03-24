import 'package:dio/dio.dart';

import '../../widgets/attendance_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../provider/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../provider/dashboard_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class CheckInOutCard extends ConsumerWidget {
	final Color cardColor;
	const CheckInOutCard({this.cardColor = kBrown, super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final ImagePicker picker = ImagePicker();
		final attendance = ref.watch(dashboardProvider);
		final user = ref.watch(authProvider);
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
							children: [
								Container(
									decoration: BoxDecoration(
										color: kGreen,
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
												const Icon(Iconsax.login, color: kPink, size: 20),
												const SizedBox(width: 6),
												Text('Check In:', style: kCaptionTextStyle.copyWith(color: kBrown)),
											],
										),
										Text(
											attendance.checkIn != null ? attendance.checkIn!.toLocal().toString().substring(0, 16) : '--',
											style: kDescriptionTextStyle.copyWith(color: kBlack),
										),
									],
								),
								if (attendance.checkIn == null && user?.employeeId != null)
									ElevatedButton.icon(
										style: ElevatedButton.styleFrom(
											backgroundColor: kPink,
											foregroundColor: kWhite,
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
											onPressed: () async {
												try {
													bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
													if (!serviceEnabled) {
														await Geolocator.openLocationSettings();
														return;
													}
													LocationPermission permission = await Geolocator.checkPermission();
													if (permission == LocationPermission.denied) {
														permission = await Geolocator.requestPermission();
														if (permission == LocationPermission.denied) {
															return;
														}
													}
													if (permission == LocationPermission.deniedForever) {
														return;
													}
													Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
													final XFile? selfie = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
													if (selfie == null) return;
													try {
														await ref.read(dashboardProvider.notifier).checkIn(
															employeeId: user!.employeeId!,
															latitude: position.latitude,
															longitude: position.longitude,
															photoPath: selfie.path,
														);
													} on DioException catch (e) {
														if (e.response?.statusCode == 403 &&
																(e.response?.data['detail'] != null)) {
															await AttendancePopup.show(context, message: e.response?.data['detail'].toString() ?? 'Current location not allowed for check-in.');
														} else {
															rethrow;
														}
													}
												} on PermissionDeniedException {
													await AttendancePopup.show(context, message: 'Location permission denied. Please allow location access to check in.');
												} catch (e) {
													if (e.toString().contains('denied')) {
														await AttendancePopup.show(context, message: 'Location permission denied. Please allow location access to check in.');
													} else {
														rethrow;
													}
												}
											},
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
												const Icon(Iconsax.logout, color: kPink, size: 20),
												const SizedBox(width: 6),
												Text('Check Out:', style: kCaptionTextStyle.copyWith(color: kBrown)),
											],
										),
										Text(
											attendance.checkOut != null ? attendance.checkOut!.toLocal().toString().substring(0, 16) : '--',
											style: kDescriptionTextStyle.copyWith(color: kBlack),
										),
									],
								),
								if (attendance.checkIn != null && attendance.checkOut == null && user?.employeeId != null)
									ElevatedButton.icon(
										style: ElevatedButton.styleFrom(
											backgroundColor: kPink,
											foregroundColor: kWhite,
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
											onPressed: () async {
												try {
													final XFile? selfie = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
													if (selfie == null) return;
													Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
													await ref.read(dashboardProvider.notifier).checkOut(
														employeeId: user!.employeeId!,
														latitude: position.latitude,
														longitude: position.longitude,
														photoPath: selfie.path,
													);
												} on DioException catch (e) {
													if (e.response?.statusCode == 403 &&
															(e.response?.data['detail']?.toString().contains('location') ?? false)) {
														await AttendancePopup.show(context, message: 'Current location not allowed for check-out. Please go to the office to check out.');
													} else {
														rethrow;
													}
												} on PermissionDeniedException {
													await AttendancePopup.show(context, message: 'Location permission denied. Please allow location access to check out.');
												} catch (e) {
													if (e.toString().contains('denied')) {
														await AttendancePopup.show(context, message: 'Location permission denied. Please allow location access to check out.');
													} else {
														rethrow;
													}
												}
												// Optionally, refresh attendance state here
											},
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
