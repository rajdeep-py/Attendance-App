import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/auth_provider.dart';
import '../../provider/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/background_location_service.dart';

class ProfileLogoutBottomSheet extends ConsumerStatefulWidget {
  const ProfileLogoutBottomSheet({super.key});

  @override
  ConsumerState<ProfileLogoutBottomSheet> createState() =>
      _ProfileLogoutBottomSheetState();
}

class _ProfileLogoutBottomSheetState
    extends ConsumerState<ProfileLogoutBottomSheet> {
  bool _loading = false;

  Future<void> _logout() async {
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      await prefs.remove('employee_id');

      await prefs.remove(BackgroundLocationService.prefsEnabledKey);
      await prefs.remove(BackgroundLocationService.prefsEmployeeIdKey);
      await prefs.remove(BackgroundLocationService.prefsAuthTokenKey);
      await prefs.remove(BackgroundLocationService.prefsIntervalSecondsKey);
      await prefs.remove(BackgroundLocationService.prefsPendingLocationsKey);

      await BackgroundLocationService.stopTracking();

      ref.read(authProvider.notifier).logout();
      ref.read(profileProvider.notifier).clear();

      if (!context.mounted) return;
      context.pop();
      context.go('/splash');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: kBlack.withAlpha(38),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kerror.withAlpha((0.12 * 255).toInt()),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Iconsax.logout, color: kerror, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Log Out',
                    style: kHeaderTextStyle.copyWith(
                      fontSize: 20,
                      color: kerror,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Are you sure you want to log out?',
              style: kBodyTextStyle.copyWith(
                color: kBrown.withAlpha((0.85 * 255).toInt()),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loading ? null : () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kBlack,
                      side: BorderSide(color: kBlack.withAlpha(20)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kerror,
                      foregroundColor: kWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: kWhite,
                            ),
                          )
                        : const Text('Log Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
