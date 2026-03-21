import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class ProfileOptionsCard extends StatelessWidget {
  const ProfileOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      {
        'icon': Iconsax.edit,
        'title': 'Update Profile',
        'subtitle': 'Edit your personal information',
      },
      {
        'icon': Iconsax.document,
        'title': 'Download Salary Slip',
        'subtitle': 'Get your monthly salary slip',
      },
      {
        'icon': Iconsax.calendar,
        'title': 'My Holidays',
        'subtitle': 'View and manage your holiday requests',
      },
      {
        'icon': Iconsax.notification,
        'title': 'Notifications',
        'subtitle': 'Manage notification preferences',
      },
      {
        'icon': Iconsax.info_circle,
        'title': 'About Us',
        'subtitle': 'Learn more about the company',
      },
      {
        'icon': Iconsax.message,
        'title': 'Help Center',
        'subtitle': 'Get support and assistance',
      },
      {
        'icon': Iconsax.logout,
        'title': 'Log Out',
        'subtitle': 'Sign out of your account',
      },
    ];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kPink.withOpacity(0.10),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
        color: kWhite,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (_, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Divider(height: 1, color: kWhiteGrey.withOpacity(0.8)),
        ),
        itemBuilder: (context, index) {
          final option = options[index];
          final isLogout = option['title'] == 'Log Out';
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isLogout
                            ? [kerror.withOpacity(0.8), kPink]
                            : [kGreen, kGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kPink.withOpacity(0.13),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(option['icon'] as IconData, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option['title'] as String,
                          style: TextStyle(
                            color: isLogout ? kerror : kBlack,
                            fontWeight: FontWeight.w700,
                            fontFamily: kFontFamily,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          option['subtitle'] as String,
                          style: TextStyle(
                            color: kBrown.withOpacity(0.85),
                            fontWeight: FontWeight.w400,
                            fontFamily: kFontFamily,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Iconsax.arrow_right_3, color: kPink, size: 22),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
