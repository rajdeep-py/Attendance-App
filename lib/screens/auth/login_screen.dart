import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../provider/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
	const LoginScreen({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final phoneController = TextEditingController();
		final passwordController = TextEditingController();

		return Scaffold(
			backgroundColor: kWhite,
			body: SafeArea(
				child: Padding(
					padding: const EdgeInsets.all(kScreenPadding),
					child: SingleChildScrollView(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								const SizedBox(height: 24),
								Text('Ready to jump into your activity hub?', style: kHeaderTextStyle.copyWith(color: kBlack)),
								const SizedBox(height: 8),
								Text('Welcome back! Please login to continue.', style: kTaglineTextStyle.copyWith(color: kBrown)),
								const SizedBox(height: 20),
								Container(
									decoration: BoxDecoration(
										color: kWhiteGrey,
										borderRadius: BorderRadius.circular(12),
									),
									child: TextField(
										controller: phoneController,
										keyboardType: TextInputType.phone,
										style: const TextStyle(color: kBlack),
										decoration: InputDecoration(
											prefixIcon: const Icon(Iconsax.call, color: kBrown),
											hintText: 'Phone Number',
											border: InputBorder.none,
											filled: true,
											fillColor: kWhiteGrey,
											hintStyle: const TextStyle(color: kBlack),
										),
									),
								),
								const SizedBox(height: 16),
								Container(
									decoration: BoxDecoration(
										color: kWhiteGrey,
										borderRadius: BorderRadius.circular(12),
									),
									child: TextField(
										controller: passwordController,
										obscureText: true,
										style: const TextStyle(color: kBlack),
										decoration: InputDecoration(
											prefixIcon: const Icon(Iconsax.lock, color: kBrown),
											hintText: 'Password',
											border: InputBorder.none,
											filled: true,
											fillColor: kWhiteGrey,
											hintStyle: const TextStyle(color: kBlack),
										),
									),
								),
								const SizedBox(height: 6),
								Align(
									alignment: Alignment.centerRight,
									child: TextButton(
										onPressed: () {},
										child: Text('Forgot Password?', style: kCaptionTextStyle.copyWith(color: kerror)),
									),
								),
								const SizedBox(height: 6),
								SizedBox(
									width: double.infinity,
									child: ElevatedButton(
										style: kPremiumButtonStyle,
										onPressed: () {
											ref.read(authProvider.notifier).login(
												phoneController.text,
												passwordController.text,
											);
											// Use GoRouter for navigation
											context.go('/dashboard');
										},
										child: const Text('Login'),
									),
								),
								const SizedBox(height: 12),
								Padding(
									padding: const EdgeInsets.symmetric(vertical: 8.0),
									child: Divider(
										color: kBrown.withAlpha(40),
										thickness: 1.2,
									),
								),
								Center(
									child: RichText(
										text: TextSpan(
											text: "Don't have an account? ",
											style: kCaptionTextStyle.copyWith(color: kBrown),
											children: [
												WidgetSpan(
													child: GestureDetector(
														onTap: () {},
														child: Row(
															mainAxisSize: MainAxisSize.min,
															children: [
																Icon(Iconsax.user_add, color: kPink, size: 20),
																const SizedBox(width: 4),
																Text(
																	"Sign up now",
																	style: kTaglineTextStyle.copyWith(
																		color: kPink,
																		fontWeight: FontWeight.bold,
																		decoration: TextDecoration.underline,
																	),
																),
															],
														),
													),
												),
											],
										),
									),
								),
								const SizedBox(height: 24),
							],
						),
					),
				),
			),
		);
	}
}
