import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../cards/holiday/my_holiday_card.dart';
import '../../provider/holiday_provider.dart';
import '../../theme/app_theme.dart';

class MyHolidayScreen extends ConsumerWidget {
  const MyHolidayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(holidayRequestProvider);
    return Scaffold(
      backgroundColor: kWhite,
      appBar: const PremiumAppBar(
        title: 'My Holidays',
        subtitle: 'Your holiday requests',
        logoAssetPath: '',
        showBackIcon: true,
        actions: [],
      ),
      body: requests.isEmpty
          ? Center(
              child: Text(
                'No holiday requests yet',
                style: kDescriptionTextStyle.copyWith(color: kBrown, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return MyHolidayCard(request: request);
              },
            ),
    );
  }
}
