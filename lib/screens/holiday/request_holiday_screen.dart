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
  ConsumerState<RequestHolidayScreen> createState() =>
      _RequestHolidayScreenState();
}

class _RequestHolidayScreenState extends ConsumerState<RequestHolidayScreen> {
  DateTime? _selectedDate;
  final _reasonController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _reasonController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
      await ref
          .read(holidayProvider.notifier)
          .createRequest(
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
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _submitting = false;
      });
    }
  }

  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            labelText,
            style: kHeaderTextStyle.copyWith(fontSize: 16, color: kBrown),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: kBlack.withAlpha(10),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: kBrown.withAlpha(26)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: maxLines == 1
                  ? Icon(icon, color: kBrown.withAlpha(180))
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 48),
                      child: Icon(icon, color: kBrown.withAlpha(180)),
                    ),
              hintText: hintText,
              hintStyle: kBodyTextStyle.copyWith(color: kGrey),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: false,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.go('/holidays');
      },
      child: Scaffold(
        backgroundColor: kWhiteGrey,
        appBar: const PremiumAppBar(
          title: 'Request Leave',
          subtitle: 'Submit an application',
          showBackIcon: true,
          logoAssetPath: '',
          actions: [],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Date',
                  style: kHeaderTextStyle.copyWith(fontSize: 16, color: kBrown),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
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
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: kBlack, // Selected day color
                        onPrimary: kWhite, // Selected day text
                        surface: kWhite, // Calendar background
                        onSurface: kBlack, // Default text
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(foregroundColor: kBrown),
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      onDateChanged: (date) =>
                          setState(() => _selectedDate = date),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _buildPremiumTextField(
                  controller: _reasonController,
                  labelText: 'Reason',
                  hintText: 'e.g., Sick leave, Personal...',
                  icon: Iconsax.note_2,
                ),
                const SizedBox(height: 20),
                _buildPremiumTextField(
                  controller: _messageController,
                  labelText: 'Additional Details',
                  hintText: 'Optional message to HR...',
                  icon: Iconsax.message,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: Text(
                        _error!,
                        style: kBodyTextStyle.copyWith(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: kGreen.withAlpha(75),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: kWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: kWhite,
                            ),
                          )
                        : Text(
                            'Submit Request',
                            style: kHeaderTextStyle.copyWith(
                              fontSize: 18,
                              color: kWhite,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 48), // Padding at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
