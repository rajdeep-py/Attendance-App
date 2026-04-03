import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/terms_conditions/terms_conditions_card.dart';
import '../../provider/terms_conditions_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class TermsConditionsScreen extends ConsumerStatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  ConsumerState<TermsConditionsScreen> createState() =>
      _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends ConsumerState<TermsConditionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(termsConditionsProvider.notifier).fetchTermsConditions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(termsConditionsProvider.notifier);
    final termsList = ref.watch(termsConditionsProvider);
    final loading = notifier.loading;
    final error = notifier.error;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.go('/profile');
      },
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: const PremiumAppBar(
          title: 'Terms & Conditions',
          subtitle: 'Read our terms and conditions',
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
            : termsList.isEmpty
            ? Center(
                child: Text(
                  'No terms available',
                  style: kDescriptionTextStyle.copyWith(
                    color: kBrown,
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                itemCount: termsList.length,
                itemBuilder: (context, index) {
                  return TermsConditionsCard(terms: termsList[index]);
                },
              ),
      ),
    );
  }
}
