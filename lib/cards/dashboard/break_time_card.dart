import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../provider/profile_provider.dart';
import '../../provider/dashboard_provider.dart';
import '../../provider/break_time_provider.dart';
import '../../widgets/break_time_popup.dart';
import '../../theme/app_theme.dart';
import '../../models/break_time.dart';

typedef LoaderCallback = void Function(bool isLoading);

class BreakTimeCard extends ConsumerStatefulWidget {
  final LoaderCallback? onLoading;

  const BreakTimeCard({this.onLoading, super.key});

  @override
  ConsumerState<BreakTimeCard> createState() => _BreakTimeCardState();
}

class _BreakTimeCardState extends ConsumerState<BreakTimeCard> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // After build completes, fetch breaks for employee
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBreaks();
    });
  }

  Future<void> _fetchBreaks() async {
    final user = ref.read(profileProvider);
    if (user?.employeeId != null) {
      await ref.read(breakTimeProvider.notifier).fetchTodayBreaks(user!.employeeId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendance = ref.watch(dashboardProvider);
    final user = ref.watch(profileProvider);
    final breaks = ref.watch(breakTimeProvider);
    
    // Check if attendance is active
    final bool isAttendanceActive = attendance.checkIn != null && attendance.checkOut == null;
    
    // Check if user is currently on a break
    BreakTime? activeBreak;
    if (breaks.isNotEmpty) {
      try {
        activeBreak = breaks.firstWhere((b) => b.breakInTime != null && b.breakOutTime == null);
      } catch (_) {
        activeBreak = null;
      }
    }
    
    final bool isOnBreak = activeBreak != null;

    // Only show card UI if we have a resolved state and user is checked in
    if (!isAttendanceActive) {
      return const SizedBox.shrink(); // Hide entirely if attendance isn't active
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBrown.withAlpha(15), width: 1),
        boxShadow: [
          BoxShadow(
            color: kBlack.withAlpha(5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kWhiteGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Iconsax.cup, color: kBrown, size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  'Break Time',
                  style: kHeaderTextStyle.copyWith(
                    color: kBlack,
                    fontSize: 20,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOnBreak ? 'Currently on Break' : 'Ready for a Break?',
                      style: kCaptionTextStyle.copyWith(
                        color: kBrown.withAlpha(180),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isOnBreak 
                          ? 'Since ${activeBreak.breakInTime!.toLocal().toString().substring(11, 16)}'
                          : 'You can start your break now.',
                      style: kBodyTextStyle.copyWith(
                        color: kBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (!isOnBreak)
                  _buildActionButton(
                    label: 'Start Break',
                    icon: Iconsax.play,
                    color: kGreen,
                    onPressed: () => _handleBreakAction(user, isStarting: true),
                  )
                else
                  _buildActionButton(
                    label: 'End Break',
                    icon: Iconsax.stop,
                    color: kBlack,
                    onPressed: () => _handleBreakAction(user, isStarting: false),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(60),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: kWhite,
          minimumSize: const Size(120, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: kHeaderTextStyle.copyWith(color: kWhite, fontSize: 14),
        ),
      ),
    );
  }

  Future<void> _handleBreakAction(dynamic user, {required bool isStarting}) async {
    if (user?.employeeId == null) return;
    
    if (widget.onLoading != null) widget.onLoading!(true);

    try {
      final XFile? selfie = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (selfie == null) {
        if (widget.onLoading != null) widget.onLoading!(false);
        return;
      }

      if (isStarting) {
        await ref.read(breakTimeProvider.notifier).startBreak(
          employeeId: user.employeeId!,
          photoPath: selfie.path,
        );
        if (mounted) {
          BreakTimePopup.show(context, message: 'Break started successfully!');
        }
      } else {
        await ref.read(breakTimeProvider.notifier).endBreak(
          employeeId: user.employeeId!,
          photoPath: selfie.path,
        );
        if (mounted) {
          BreakTimePopup.show(context, message: 'Break ended successfully!');
        }
      }
    } catch (e) {
      if (mounted) {
        BreakTimePopup.show(context, message: 'Failed: ${e.toString().replaceAll("Exception: ", "")}');
      }
    } finally {
      if (widget.onLoading != null) widget.onLoading!(false);
    }
  }
}
