import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/privacy_policy/privacy_policy_card.dart';
import '../../provider/privacy_policy_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  ConsumerState<PrivacyPolicyScreen> createState() =>
      _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(privacyPolicyProvider.notifier).fetchPrivacyPolicies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(privacyPolicyProvider.notifier);
    final policies = ref.watch(privacyPolicyProvider);
    final loading = notifier.loading;
    final error = notifier.error;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go('/profile');
        }
      },
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: const PremiumAppBar(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
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
                  style: kDescriptionTextStyle.copyWith(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : policies.isEmpty
            ? Center(
                child: Text(
                  'No privacy policy available',
                  style: kDescriptionTextStyle.copyWith(
                    color: kBrown,
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                itemCount: policies.length,
                itemBuilder: (context, index) {
                  return PrivacyPolicyCard(policy: policies[index]);
                },
              ),
      ),
    );
  }
}
