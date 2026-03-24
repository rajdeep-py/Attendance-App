import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../cards/holiday/my_holiday_card.dart';
import '../../provider/holiday_provider.dart';
import '../../provider/auth_provider.dart';
import '../../theme/app_theme.dart';

class MyHolidayScreen extends ConsumerStatefulWidget {
  const MyHolidayScreen({super.key});

  @override
  ConsumerState<MyHolidayScreen> createState() => _MyHolidayScreenState();
}

class _MyHolidayScreenState extends ConsumerState<MyHolidayScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRequests();
    });
  }

  Future<void> _fetchRequests() async {
    final user = ref.read(authProvider);
    if (user?.employeeId != null) {
      await ref.read(holidayProvider.notifier).fetchRequests(user!.employeeId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(holidayProvider.notifier);
    final requests = notifier.requests;
    final loading = notifier.loading;
    final error = notifier.error;

    return Scaffold(
      backgroundColor: kWhite,
      appBar: const PremiumAppBar(
        title: 'My Holidays',
        subtitle: 'Your holiday requests',
        logoAssetPath: '',
        showBackIcon: true,
        actions: [],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Text(
                    'Error: $error',
                    style: kDescriptionTextStyle.copyWith(color: Colors.red, fontSize: 18),
                  ),
                )
              : requests.isEmpty
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
