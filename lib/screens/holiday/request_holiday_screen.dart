import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../provider/holiday_provider.dart';
import '../../models/holiday_request.dart';
import '../../theme/app_theme.dart';

class RequestHolidayScreen extends ConsumerStatefulWidget {
  const RequestHolidayScreen({super.key});

  @override
  ConsumerState<RequestHolidayScreen> createState() => _RequestHolidayScreenState();
}

class _RequestHolidayScreenState extends ConsumerState<RequestHolidayScreen> {
  DateTime? _selectedDate;
  final _reasonController = TextEditingController();
  final _messageController = TextEditingController();

  void _submit() {
    if (_selectedDate == null || _reasonController.text.isEmpty || _messageController.text.isEmpty) return;
    final request = HolidayRequest(
      date: _selectedDate!,
      reason: _reasonController.text,
      message: _messageController.text,
    );
    ref.read(holidayProvider.notifier).addRequest(request);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Request Holiday',
        subtitle: 'Submit your holiday request',
        showBackIcon: true,
        logoAssetPath: '',
        actions: [],
      ),
      backgroundColor: kWhiteGrey,
      body: Padding(
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
                labelText: 'Reason',
                labelStyle: kDescriptionTextStyle.copyWith(color: kBrown),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              style: kCaptionTextStyle.copyWith(color: kBlack),
              decoration: InputDecoration(
                labelText: 'Message',
                labelStyle: kDescriptionTextStyle.copyWith(color: kBrown),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _submit,
                style: kPremiumButtonStyle,
                child: const Text('Submit Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
