import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/documentation/documentation_card.dart';
import '../../provider/documentation_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class DocumentationScreen extends ConsumerStatefulWidget {
  const DocumentationScreen({super.key});

  @override
  ConsumerState<DocumentationScreen> createState() =>
      _DocumentationScreenState();
}

class _DocumentationScreenState extends ConsumerState<DocumentationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(documentationProvider.notifier).fetchDocumentation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(documentationProvider.notifier);
    final docs = ref.watch(documentationProvider);
    final loading = notifier.loading;
    final error = notifier.error;

    return Scaffold(
      backgroundColor: kWhite,
      appBar: const PremiumAppBar(
        title: 'Documentation',
        subtitle: 'Read our App Flow documentation',
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
          : docs.isEmpty
          ? Center(
              child: Text(
                'No documentation available',
                style: kDescriptionTextStyle.copyWith(
                  color: kBrown,
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return DocumentationCard(documentation: docs[index]);
              },
            ),
    );
  }
}
