import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
	final String title;
	final String subtitle;
	final String logoAssetPath;
	final double logoSize;
	final List<Widget>? actions;
	final bool showBackIcon;
	const PremiumAppBar({
		required this.title,
		required this.subtitle,
		this.logoAssetPath = 'assets/logo/logo_no_bg.png',
		this.logoSize = 40,
		this.actions,
		this.showBackIcon = false,
		super.key,
	});

	@override
	Size get preferredSize => const Size.fromHeight(80);

	@override
	Widget build(BuildContext context) {
		return AppBar(
			backgroundColor: kWhite,
			elevation: 0,
						leading: Row(
							mainAxisSize: MainAxisSize.min,
							children: [
								if (showBackIcon)
									IconButton(
										icon: const Icon(Iconsax.arrow_left, color: kBlack, size: 24),
										onPressed: () {
											Navigator.of(context).maybePop();
										},
										tooltip: 'Back',
									),
								Padding(
									padding: const EdgeInsets.all(8.0),
									child: AppLogo(size: logoSize, assetPath: logoAssetPath),
								),
							],
						),
			title: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(title, style: kHeaderTextStyle.copyWith(color: kBlack, fontSize: 20)),
					Text(subtitle, style: kTaglineTextStyle.copyWith(color: kGrey, fontSize: 14)),
				],
			),
						actions: actions ?? [
							IconButton(
								icon: const Icon(Iconsax.notification, color: kBlack, size: 28),
								onPressed: () {},
								tooltip: 'Notifications',
							),
						],
		);
	}
}
