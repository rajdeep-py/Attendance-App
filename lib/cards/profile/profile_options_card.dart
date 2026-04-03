import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/salary_slip_services.dart';
import '../../provider/profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileOptionsCard extends ConsumerWidget {
  const ProfileOptionsCard({super.key});

  Future<void> _downloadSalarySlip(BuildContext context, WidgetRef ref) async {
    final user = ref.read(profileProvider);
    if (user?.employeeId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User info missing')));
      }
      return;
    }
    try {
      final slips = await SalarySlipServices().getSalarySlipsByEmployee(
        user!.employeeId!,
      );
      if (slips.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No salary slips found.')),
          );
        }
        return;
      }
      final slip = slips.last; // Open the latest slip
      // Use the new endpoint to get the PDF URL
      final pdfUrl = await SalarySlipServices().getSalarySlipPdfUrl(
        employeeId: user.employeeId!,
        slipId: slip.slipId,
      );
      if (await canLaunchUrl(Uri.parse(pdfUrl))) {
        await launchUrl(
          Uri.parse(pdfUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open salary slip PDF.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = [
      {
        'icon': Iconsax.document,
        'title': 'Download Salary Slip',
        'subtitle': 'Get your monthly salary slip',
      },
      {
        'icon': Iconsax.map,
        'title': 'View My Store Locations',
        'subtitle': 'See all your store locations on map',
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
        'icon': Iconsax.document_text,
        'title': 'Terms & Conditions',
        'subtitle': 'Read our terms and conditions',
      },
      {
        'icon': Iconsax.shield_tick,
        'title': 'Privacy Policy',
        'subtitle': 'Read our privacy policy',
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
            color: kPink.withAlpha((0.10 * 255).toInt()),
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
          child: Divider(
            height: 1,
            color: kWhiteGrey.withAlpha((0.8 * 255).toInt()),
          ),
        ),
        itemBuilder: (context, index) {
          final option = options[index];
          final isLogout = option['title'] == 'Log Out';
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () async {
              if (option['title'] == 'Download Salary Slip') {
                await _downloadSalarySlip(context, ref);
              } else if (option['title'] == 'View My Store Locations') {
                if (context.mounted) {
                  GoRouter.of(context).go('/map');
                }
              } else if (option['title'] == 'My Holidays') {
                if (context.mounted) {
                  GoRouter.of(context).go('/my-holidays');
                }
              } else if (option['title'] == 'About Us') {
                if (context.mounted) {
                  GoRouter.of(context).go('/about-us');
                }
              } else if (option['title'] == 'Terms & Conditions') {
                if (context.mounted) {
                  GoRouter.of(context).go('/terms-conditions');
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isLogout
                            ? [kerror.withAlpha((0.8 * 255).toInt()), kerror]
                            : [kBlack, kGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kPink.withAlpha((0.13 * 255).toInt()),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      option['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
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
                            color: kBrown.withAlpha((0.85 * 255).toInt()),
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
