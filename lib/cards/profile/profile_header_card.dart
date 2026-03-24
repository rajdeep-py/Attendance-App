import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

import 'package:go_router/go_router.dart';
import '../../models/user.dart';

class ProfileHeaderCard extends StatelessWidget {
  final User user;
  const ProfileHeaderCard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kBlack.withAlpha((0.10 * 255).toInt()),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
        color: kWhite,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPink, kBrown],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withAlpha((0.18 * 255).toInt()),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: const Icon(Iconsax.user, color: Colors.white, size: 40),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.fullName,
                        style: kHeaderTextStyle.copyWith(
                          fontSize: 22,
                          color: kBrown,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      Icon(Iconsax.verify5, color: kGreen, size: 22),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Iconsax.call, color: kPink, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        user.phoneNo,
                        style: TextStyle(
                          color: kBrown,
                          fontWeight: FontWeight.w500,
                          fontFamily: kFontFamily,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Use GoRouter to navigate to update profile
                context.go('/update-profile');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kWhiteGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Iconsax.edit, color: kBrown, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
