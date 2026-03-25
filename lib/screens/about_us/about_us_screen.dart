import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_bar.dart';
import '../../cards/about_us/header_card.dart';
import '../../cards/about_us/description_card.dart';
import '../../cards/about_us/director_card.dart';
import '../../cards/about_us/contact_card.dart';
import '../../provider/about_us_provider.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutUs = ref.watch(aboutUsProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        
          context.go('/dashboard');
        },
        child:
    Scaffold(
      backgroundColor: Colors.white,
      appBar: const PremiumAppBar(
        title: 'About Us',
        subtitle: 'Learn more about us',
        logoAssetPath: '',
        showBackIcon: true,
        actions: [],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          HeaderCard(aboutUs: aboutUs),
          DescriptionCard(aboutUs: aboutUs),
          DirectorCard(aboutUs: aboutUs),
          ContactCard(aboutUs: aboutUs),
        ],
      ),
    ),
    );
  }
}
