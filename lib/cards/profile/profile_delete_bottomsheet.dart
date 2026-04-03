import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';

import '../../provider/auth_provider.dart';
import '../../provider/profile_provider.dart';
import '../../services/auth_services.dart';
import '../../theme/app_theme.dart';

class ProfileDeleteBottomSheet extends ConsumerStatefulWidget {
  const ProfileDeleteBottomSheet({super.key});

  @override
  ConsumerState<ProfileDeleteBottomSheet> createState() =>
      _ProfileDeleteBottomSheetState();
}

class _ProfileDeleteBottomSheetState
    extends ConsumerState<ProfileDeleteBottomSheet> {
  final _passwordController = TextEditingController();
  bool _confirmed = false;
  bool _loading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    final user = ref.read(profileProvider);
    final employeeId = user?.employeeId;
    final adminId = user?.adminId;
    if (employeeId == null || adminId == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User info missing.')));
      }
      return;
    }

    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your password.')),
        );
      }
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthServices().deleteEmployeeAccount(
        employeeId: employeeId,
        adminId: adminId,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      await prefs.remove('employee_id');

      ref.read(authProvider.notifier).logout();
      ref.read(profileProvider.notifier).clear();

      if (!mounted) return;
      context.pop();
      context.go('/splash');
    } on DioException catch (e) {
      if (mounted) {
        final statusCode = e.response?.statusCode;

        String message;
        if (statusCode == 401 || statusCode == 403) {
          message = 'Incorrect password. Please try again.';
        } else if (statusCode == 400) {
          final data = e.response?.data;
          final raw = data is String ? data : data?.toString();
          final lower = (raw ?? '').toLowerCase();
          message =
              lower.contains('password') ||
                  lower.contains('invalid') ||
                  lower.contains('incorrect')
              ? 'Incorrect password. Please try again.'
              : 'Could not delete account. Please try again.';
        } else {
          message = 'Could not delete account. Please try again.';
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not delete account. Please try again.'),
          ),
        );
      }
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
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
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
                  child: const Icon(Iconsax.warning_2, color: kerror, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Delete Account',
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
              _confirmed
                  ? 'Enter your password to confirm deletion.'
                  : 'This action is permanent. Your account and related data will be deleted.',
              style: kBodyTextStyle.copyWith(
                color: kBrown.withAlpha((0.85 * 255).toInt()),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            if (_confirmed) ...[
              Text(
                'Password',
                style: kHeaderTextStyle.copyWith(fontSize: 14, color: kBlack),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                enabled: !_loading,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  filled: true,
                  fillColor: kWhiteGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: kBrown.withAlpha(26)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: kBrown.withAlpha(26)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: kerror, width: 1.2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
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
                    onPressed: _loading
                        ? null
                        : () {
                            if (_confirmed) {
                              _deleteAccount();
                            } else {
                              setState(() => _confirmed = true);
                            }
                          },
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
                        : Text(_confirmed ? 'Delete My Account' : 'Continue'),
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
