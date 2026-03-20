import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
	final String title;
	final String subtitle;
	const DashboardAppBar({
		required this.title,
		required this.subtitle,
		super.key,
	});

	@override
	Size get preferredSize => const Size.fromHeight(80);

	@override
	Widget build(BuildContext context) {
		return AppBar(
			backgroundColor: kWhite,
			elevation: 0,
			leading: Padding(
				padding: const EdgeInsets.all(8.0),
				child: AppLogo(size: 40),
			),
			title: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(title, style: kHeaderTextStyle.copyWith(color: kBlack, fontSize: 20)),
					Text(subtitle, style: kTaglineTextStyle.copyWith(color: kGrey, fontSize: 14)),
				],
			),
			actions: [
				IconButton(
					icon: const Icon(Icons.notifications_none, color: kBlack, size: 28),
					onPressed: () {},
				),
			],
		);
	}
}
