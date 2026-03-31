import 'package:dio/dio.dart';
import '../../widgets/attendance_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../provider/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../provider/dashboard_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

typedef LoaderCallback = void Function(bool isLoading);
typedef RefreshCallback = Future<void> Function();

class CheckInOutCard extends ConsumerWidget {
  final LoaderCallback? onLoading;
  final RefreshCallback? onRefresh;

  const CheckInOutCard({this.onLoading, this.onRefresh, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ImagePicker picker = ImagePicker();
    final attendance = ref.watch(dashboardProvider);
    final user = ref.watch(profileProvider);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime? checkInDate = attendance.checkIn != null
        ? DateTime(
            attendance.checkIn!.toLocal().year,
            attendance.checkIn!.toLocal().month,
            attendance.checkIn!.toLocal().day,
          )
        : null;

    final DateTime? checkOutDate = attendance.checkOut != null
        ? DateTime(
            attendance.checkOut!.toLocal().year,
            attendance.checkOut!.toLocal().month,
            attendance.checkOut!.toLocal().day,
          )
        : null;

    final bool isTodayCheckIn = checkInDate != null && checkInDate == today;
    final bool isTodayCheckOut = checkOutDate != null && checkOutDate == today;
    final bool showCheckIn = !isTodayCheckIn && user?.employeeId != null;
    final bool showCheckOut =
        isTodayCheckIn && !isTodayCheckOut && user?.employeeId != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBrown.withAlpha(15), width: 1),
        boxShadow: [
          BoxShadow(
            color: kBlack.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kBlack,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Iconsax.clock, color: kGreen, size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  'Attendance',
                  style: kHeaderTextStyle.copyWith(
                    color: kBlack,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: kWhiteGrey, thickness: 1.5, height: 1),

          // Check In Section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.login, color: kBrown, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Check In',
                          style: kCaptionTextStyle.copyWith(
                            color: kBrown.withAlpha(180),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      attendance.checkIn != null
                          ? attendance.checkIn!.toLocal().toString().substring(
                              0,
                              16,
                            )
                          : '--',
                      style: kBodyTextStyle.copyWith(
                        color: kBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (showCheckIn)
                  _buildActionButton(
                    context: context,
                    ref: ref,
                    picker: picker,
                    user: user,
                    isCheckIn: true,
                    label: 'Check In',
                    icon: Iconsax.login,
                    color: kGreen,
                  ),
              ],
            ),
          ),

          // Check Out Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            decoration: BoxDecoration(
              color: kWhiteGrey.withAlpha(150),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.logout, color: kBrown, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Check Out',
                          style: kCaptionTextStyle.copyWith(
                            color: kBrown.withAlpha(180),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      attendance.checkOut != null
                          ? attendance.checkOut!.toLocal().toString().substring(
                              0,
                              16,
                            )
                          : '--',
                      style: kBodyTextStyle.copyWith(
                        color: kBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (showCheckOut)
                  _buildActionButton(
                    context: context,
                    ref: ref,
                    picker: picker,
                    user: user,
                    isCheckIn: false,
                    label: 'Check Out',
                    icon: Iconsax.logout,
                    color: kBlack,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required WidgetRef ref,
    required ImagePicker picker,
    required dynamic user,
    required bool isCheckIn,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(60),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: kWhite,
          minimumSize: const Size(130, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: () => _handleAction(context, ref, picker, user, isCheckIn),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: kHeaderTextStyle.copyWith(color: kWhite, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    ImagePicker picker,
    dynamic user,
    bool isCheckIn,
  ) async {
    if (onLoading != null) onLoading!(true);
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
          if (context.mounted) {
            await AttendancePopup.show(
              context,
              message:
                  'Location permission denied. Please allow location access.',
            );
          }
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          await AttendancePopup.show(
            context,
            message:
                'Location permission permanently denied. Please enable it from settings.',
          );
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final XFile? selfie = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (selfie == null) return;

      try {
        if (isCheckIn) {
          await ref
              .read(dashboardProvider.notifier)
              .checkIn(
                employeeId: user!.employeeId!,
                latitude: position.latitude,
                longitude: position.longitude,
                photoPath: selfie.path,
              );
          if (onRefresh != null) await onRefresh!();
          if (context.mounted) {
            await AttendancePopup.show(
              context,
              message: 'Check-in successful!',
            );
          }
        } else {
          await ref
              .read(dashboardProvider.notifier)
              .checkOut(
                employeeId: user!.employeeId!,
                latitude: position.latitude,
                longitude: position.longitude,
                photoPath: selfie.path,
              );
          if (onRefresh != null) await onRefresh!();
          if (context.mounted) {
            await AttendancePopup.show(
              context,
              message: 'Check-out successful!',
            );
          }
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 403 &&
            (e.response?.data['detail']?.toString().contains('location') ??
                false)) {
          if (context.mounted) {
            await AttendancePopup.show(
              context,
              message: 'You are not at the allowed location.',
            );
          }
        } else {
          if (context.mounted) {
            await AttendancePopup.show(
              context,
              message:
                  '${isCheckIn ? 'Check-in' : 'Check-out'} failed. Please try again.',
            );
          }
        }
      }
    } on PermissionDeniedException {
      if (context.mounted) {
        await AttendancePopup.show(
          context,
          message: 'Location permission denied. Please allow location access.',
        );
      }
    } catch (e) {
      if (e.toString().contains('denied')) {
        if (context.mounted) {
          await AttendancePopup.show(
            context,
            message: 'Location permission denied.',
          );
        }
      } else {
        rethrow;
      }
    } finally {
      if (onLoading != null) onLoading!(false);
    }
  }
}
