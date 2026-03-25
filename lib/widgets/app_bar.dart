import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
		this.logoAssetPath = 'assets/logo/attendx24_logo.jpeg',
		this.logoSize = 40,
		this.actions,
		this.showBackIcon = false,
		super.key,
	});

	@override
	Size get preferredSize => const Size.fromHeight(60);

	@override
	Widget build(BuildContext context) {
		return AppBar(
			backgroundColor: kWhite,
			elevation: 0,
			leading: (showBackIcon || logoAssetPath.isNotEmpty)
				? Row(
					mainAxisSize: MainAxisSize.min,
					children: [
						if (showBackIcon)
								IconButton(
									icon: const Icon(Iconsax.arrow_left, color: kBlack, size: 24),
									onPressed: () {
										if (Navigator.of(context).canPop()) {
											context.pop();
										} else {
											GoRouter.of(context).go('/dashboard');
										}
									},
									tooltip: 'Back',
								),
						if (logoAssetPath.isNotEmpty)
							Padding(
								padding: const EdgeInsets.all(8.0),
								child: AppLogo(size: logoSize, assetPath: logoAssetPath),
							),
					],
				)
				: null,
			title: Align(
				alignment: (showBackIcon || logoAssetPath.isNotEmpty)
					? Alignment.centerLeft
					: Alignment.centerLeft,
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(title, style: kHeaderTextStyle.copyWith(color: kBlack, fontSize: 20)),
						Text(subtitle, style: kTaglineTextStyle.copyWith(color: kBrown, fontSize: 14)),
					],
				),
			),
			actions: actions ?? [
							 Builder(
								 builder: (context) => IconButton(
									 icon: const Icon(Iconsax.notification, color: kPink, size: 28),
									 onPressed: () {
										 GoRouter.of(context).go('/notifications');
									 },
									 tooltip: 'Notifications',
								 ),
							 ),
			],
		);
	}
}
