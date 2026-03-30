import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/profile_provider.dart';
import '../../provider/holiday_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/leave_request_success_popup.dart';
import 'package:iconsax/iconsax.dart';
class RequestHolidayScreen extends ConsumerStatefulWidget {
  const RequestHolidayScreen({super.key});

  @override
  ConsumerState<RequestHolidayScreen> createState() => _RequestHolidayScreenState();
}

class _RequestHolidayScreenState extends ConsumerState<RequestHolidayScreen> {
  DateTime? _selectedDate;
  final _reasonController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitting = false;
  String? _error;

  Future<void> _submit() async {
    if (_selectedDate == null || _reasonController.text.isEmpty) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final user = ref.read(profileProvider);
    if (user?.employeeId == null || user?.adminId == null) {
      setState(() {
        _error = 'User info missing';
        _submitting = false;
      });
      return;
    }
    try {
      await ref.read(holidayProvider.notifier).createRequest(
        adminId: user!.adminId!,
        employeeId: user.employeeId!,
        date: _selectedDate!,
        reason: _reasonController.text,
      );
      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LeaveRequestSuccessPopup(),
      );
      // Do not call setState after dialog, as widget may be disposed
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        
          context.go('/holidays');
        },
      child: Scaffold(
        appBar: const PremiumAppBar(
          title: 'Request Holiday',
          subtitle: 'Submit your holiday request',
          showBackIcon: true,
          logoAssetPath: '',
          actions: [],
        ),
        backgroundColor: kWhiteGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('Select Date', style: kHeaderTextStyle.copyWith(fontSize: 18, color: kBlack)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: kPink, // selected day
                        onPrimary: kWhite, // selected day text
                        surface: kWhiteGrey, // calendar background
                        onSurface: kBlack, // default text
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: kBrown,
                        ),
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      onDateChanged: (date) => setState(() => _selectedDate = date),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reasonController,
                  style: kCaptionTextStyle.copyWith(color: kBlack),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.note_2, color: kBrown, size: 22),
                    labelText: 'Reason',
                    labelStyle: kDescriptionTextStyle.copyWith(color: kBrown),
                    hintText: 'E.g. Family function, health, etc.',
                    hintStyle: kDescriptionTextStyle.copyWith(color: kGrey),
                    filled: true,
                    fillColor: kWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kWhiteGrey, width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kWhiteGrey, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kPink, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _messageController,
                  style: kCaptionTextStyle.copyWith(color: kBlack),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.message, color: kBrown, size: 22),
                    labelText: 'Message',
                    labelStyle: kDescriptionTextStyle.copyWith(color: kBrown),
                    hintText: 'Add any extra details (optional)',
                    hintStyle: kDescriptionTextStyle.copyWith(color: kGrey),
                    filled: true,
                    fillColor: kWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kWhiteGrey, width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kWhiteGrey, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kPink, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                if (_error != null)
                  Center(
                    child: Text(
                      _error!,
                      style: kDescriptionTextStyle.copyWith(color: Colors.red, fontSize: 16),
                    ),
                  ),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPink,
                        foregroundColor: kWhite,
                        elevation: 8,
                        minimumSize: const Size(0, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: kHeaderTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      icon: _submitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: kWhite),
                            )
                          : const Icon(Iconsax.send_2, size: 22),
                      label: _submitting
                          ? const Text('Submitting...')
                          : const Text('Submit Request'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
           

