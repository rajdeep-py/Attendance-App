import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kBlack,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Iconsax.info_circle, color: kGreen, size: 28),
              ),
              const SizedBox(width: 16),
              Text(
                'App Features',
                style: kHeaderTextStyle.copyWith(color: kBlack, fontSize: 22),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _featureRow(
            Iconsax.login,
            'Check in to start your shift. You must be within 10 meters of the store and upload a selfie.',
          ),
          _featureRow(
            Iconsax.location,
            'Check in/out only works in close proximity to the store.',
          ),
          _featureRow(
            Iconsax.camera,
            'Upload a selfie for both check in and check out.',
          ),
          _featureRow(
            Iconsax.logout,
            'Check out at the end of your day by uploading a selfie.',
          ),
          _featureRow(
            Iconsax.calendar,
            'Apply for leaves and view the full holiday calendar of Manju Medical Stores & Digital Clinic.',
          ),
          _featureRow(Iconsax.document, 'See your attendance record in brief.'),
          _featureRow(Iconsax.wallet, 'Download your salary slips.'),
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kWhiteGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: kBrown, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: kBodyTextStyle.copyWith(
                  color: kBrown.withAlpha(200),
                  height: 1.4,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
