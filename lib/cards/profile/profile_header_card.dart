import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../models/user.dart';
import '../../services/api_url.dart';

class ProfileHeaderCard extends StatelessWidget {
  final User user;
  const ProfileHeaderCard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final String initials = user.fullName.isNotEmpty
        ? user.fullName
              .trim()
              .split(' ')
              .map((e) => e[0])
              .take(2)
              .join()
              .toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kBlack.withAlpha((0.07 * 255).toInt()),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          children: [
            // ── Avatar row ────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with green ring
                Stack(
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kGreen, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: kGreen.withAlpha((0.18 * 255).toInt()),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child:
                            user.profilePhoto != null &&
                                user.profilePhoto!.isNotEmpty
                            ? Image.network(
                                user.profilePhoto!.startsWith('http')
                                    ? user.profilePhoto!
                                    : '${ApiUrl.baseUrl}/${user.profilePhoto!}',
                                width: 86,
                                height: 86,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _InitialsAvatar(initials: initials),
                              )
                            : _InitialsAvatar(initials: initials),
                      ),
                    ),
                    // Verified badge
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: kWhite, width: 2),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Iconsax.verify5,
                          color: kWhite,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                // Name + designation
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: kHeaderTextStyle.copyWith(
                          fontSize: 21,
                          color: kBlack,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Designation chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: kBlack,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.designation.isEmpty
                              ? 'Employee'
                              : user.designation,
                          style: kCaptionTextStyle.copyWith(
                            color: kGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit button
                GestureDetector(
                  onTap: () => context.go('/update-profile'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kWhiteGrey,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: kBlack.withAlpha((0.08 * 255).toInt()),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Iconsax.edit_2, color: kBlack, size: 20),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Divider(height: 1, color: kWhiteGrey.withAlpha(220)),
            const SizedBox(height: 2),

            // ── Info chips row ────────────────────────────────────────────
            Row(
              children: [
                _InfoChip(
                  icon: Iconsax.call,
                  label: user.phoneNo.isEmpty ? '—' : user.phoneNo,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoChip(
                    icon: Iconsax.sms,
                    label: user.email.isEmpty ? '—' : user.email,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────────────────────────────────

class _InitialsAvatar extends StatelessWidget {
  final String initials;
  const _InitialsAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBlack,
      child: Center(
        child: Text(
          initials,
          style: kHeaderTextStyle.copyWith(
            color: kGreen,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool fullWidth;

  const _InfoChip({
    required this.icon,
    required this.label,
    // ignore: unused_element_parameter
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: kWhiteGrey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: kBrown),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: kCaptionTextStyle.copyWith(
                fontSize: 13,
                color: kBlack,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: child) : child;
  }
}
