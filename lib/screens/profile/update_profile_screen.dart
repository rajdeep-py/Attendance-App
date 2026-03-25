
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';
import '../../provider/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../../services/api_url.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
	const UpdateProfileScreen({super.key});

	@override
	ConsumerState<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
	final _formKey = GlobalKey<FormState>();
	final _fullNameController = TextEditingController();
	final _phoneController = TextEditingController();
	final _emailController = TextEditingController();
	final _addressController = TextEditingController();
	final _designationController = TextEditingController();
	final _passwordController = TextEditingController();
	final _bankAccountController = TextEditingController();
	final _bankNameController = TextEditingController();
	final _branchNameController = TextEditingController();
	final _ifscController = TextEditingController();

	bool _loading = false;
	File? _profileImage;

	@override
	void dispose() {
		_fullNameController.dispose();
		_phoneController.dispose();
		_emailController.dispose();
		_addressController.dispose();
		_designationController.dispose();
		_passwordController.dispose();
		_bankAccountController.dispose();
		_bankNameController.dispose();
		_branchNameController.dispose();
		_ifscController.dispose();
		super.dispose();
	}

	void _populateFields(User user) {
		_fullNameController.text = user.fullName;
		_phoneController.text = user.phoneNo;
		_emailController.text = user.email;
		_addressController.text = user.address;
		_designationController.text = user.designation;
		_passwordController.text = user.password;
		_bankAccountController.text = user.bankAccountNo;
		_bankNameController.text = user.bankName;
		_branchNameController.text = user.branchName;
		_ifscController.text = user.ifscCode;
		// Optionally, show existing profile photo if available
		// (for now, only new uploads are previewed)
	}

	Future<void> _pickImage(ImageSource source) async {
		final picker = ImagePicker();
		final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
		if (pickedFile != null) {
			setState(() {
				_profileImage = File(pickedFile.path);
			});
		}
	}

	void _showImagePickerSheet() {
		showModalBottomSheet(
			context: context,
			shape: const RoundedRectangleBorder(
				borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
			),
			builder: (context) => SafeArea(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						ListTile(
							leading: const Icon(Iconsax.camera, color: kBrown),
							title: const Text('Take Photo'),
							onTap: () {
								Navigator.pop(context);
								_pickImage(ImageSource.camera);
							},
						),
						ListTile(
							leading: const Icon(Iconsax.gallery, color: kBrown),
							title: const Text('Choose from Gallery'),
							onTap: () {
								Navigator.pop(context);
								_pickImage(ImageSource.gallery);
							},
						),
					],
				),
			),
		);
	}

	@override
	void didChangeDependencies() {
		super.didChangeDependencies();
		final user = ref.read(profileProvider);
		if (user != null) {
			_populateFields(user);
		}
	}

	Future<void> _handleUpdateProfile() async {
		final user = ref.read(profileProvider);
		if (user == null) return;
		setState(() => _loading = true);
		try {
			await ref.read(profileProvider.notifier).updateProfile(
				employeeId: user.employeeId!,
				fullName: _fullNameController.text,
				phoneNo: _phoneController.text,
				email: _emailController.text,
				address: _addressController.text,
				designation: _designationController.text,
				password: _passwordController.text,
				bankAccountNo: _bankAccountController.text,
				bankName: _bankNameController.text,
				branchName: _branchNameController.text,
				ifscCode: _ifscController.text,
				profilePhotoPath: _profileImage?.path,
			);
			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					const SnackBar(content: Text('Profile updated successfully')),
				);
			}
		} catch (e) {
			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(content: Text('Update failed: $e')),
				);
			}
		} finally {
			if (mounted) setState(() => _loading = false);
		}
	}

	@override
	Widget build(BuildContext context) {
		final user = ref.watch(profileProvider);
		if (user == null) {
			return const Scaffold(
				body: Center(child: CircularProgressIndicator()),
			);
		}
		return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        
          context.go('/profile');
        },
        child:
    Stack(
			children: [
				Scaffold(
					appBar: const PremiumAppBar(
						title: 'Manage Profile',
						subtitle: 'View and manage your account',
						logoAssetPath: '',
						actions: [],
						showBackIcon: true,
					),
					body: SingleChildScrollView(
						padding: const EdgeInsets.all(16),
						child: Form(
							key: _formKey,
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Center(
										child: GestureDetector(
											onTap: _showImagePickerSheet,
											child: Container(
												margin: const EdgeInsets.only(bottom: 24),
												decoration: BoxDecoration(
													shape: BoxShape.circle,
													gradient: LinearGradient(
														colors: [kPink, kBrown],
														begin: Alignment.topLeft,
														end: Alignment.bottomRight,
													),
													boxShadow: [
														BoxShadow(
															color: kBlack.withAlpha((0.18 * 255).toInt()),
															blurRadius: 16,
															offset: const Offset(0, 4),
														),
													],
												),
												padding: const EdgeInsets.all(2),
												child: _profileImage != null
																? ClipOval(
																				child: Image.file(
																					_profileImage!,
																					width: 80,
																					height: 80,
																					fit: BoxFit.cover,
																				),
																			)
																: (user.profilePhoto != null && user.profilePhoto!.isNotEmpty
																				? ClipOval(
																								child: Image.network(
																									user.profilePhoto!.startsWith('http')
																													? user.profilePhoto!
																													: '${ApiUrl.baseUrl}/${user.profilePhoto!}',
																									width: 80,
																									height: 80,
																									fit: BoxFit.cover,
																									errorBuilder: (context, error, stackTrace) => const Icon(Iconsax.user, color: Colors.white, size: 48),
																								),
																							)
																				: const Icon(Iconsax.user, color: Colors.white, size: 48)),
											),
										),
									),
									Text('Personal Details', style: kHeaderTextStyle.copyWith(fontSize: 20)),
									const SizedBox(height: 12),
									_ModernTextField(
										controller: _fullNameController,
										label: 'Full Name',
										icon: Iconsax.user,
										validator: (v) => v == null || v.isEmpty ? 'Required' : null,
									),
									const SizedBox(height: 12),
									_ModernTextField(
										controller: _phoneController,
										label: 'Phone Number',
										icon: Iconsax.call,
										keyboardType: TextInputType.phone,
										validator: (v) => v == null || v.isEmpty ? 'Required' : null,
									),
									const SizedBox(height: 12),
									_ModernTextField(
										controller: _emailController,
										label: 'Email',
										icon: Iconsax.sms,
										keyboardType: TextInputType.emailAddress,
										validator: (v) => v == null || v.isEmpty ? 'Required' : null,
									),
									const SizedBox(height: 12),
									_ModernTextField(
										controller: _addressController,
										label: 'Address',
										icon: Iconsax.location,
									),
									const SizedBox(height: 12),
									_ModernTextField(
										controller: _designationController,
										label: 'Designation',
										icon: Iconsax.briefcase,
									),
									const SizedBox(height: 24),
									Text('Security', style: kHeaderTextStyle.copyWith(fontSize: 20)),
									const SizedBox(height: 12),
									_ModernTextField(
										controller: _passwordController,
										label: 'Password',
										icon: Iconsax.lock,
										obscureText: true,
									),
									const SizedBox(height: 24),
									Text('Bank Details', style: kHeaderTextStyle.copyWith(fontSize: 20)),
									const SizedBox(height: 12),
									_ModernTextField(
										controller: _bankAccountController,
										label: 'Bank Account No',
										icon: Iconsax.card,
									),
									const SizedBox(height: 12),
									_ModernTextField(
										controller: _bankNameController,
										label: 'Bank Name',
										icon: Iconsax.bank,
									),
									const SizedBox(height: 12),
									_ModernTextField(
										controller: _branchNameController,
										label: 'Branch Name',
										icon: Iconsax.building,
									),
									const SizedBox(height: 12),
									_ModernTextField(
										controller: _ifscController,
										label: 'IFSC Code',
										icon: Iconsax.code,
									),
									const SizedBox(height: 32),
									SizedBox(
										width: double.infinity,
										child: ElevatedButton(
											onPressed: _loading
															? null
															: () {
																			if (_formKey.currentState?.validate() ?? false) {
																				_handleUpdateProfile();
																			}
																		},
											style: kPremiumButtonStyle,
											child: _loading
															? const CircularProgressIndicator(color: Colors.white)
															: const Text('Update'),
										),
									),
								],
							),
						),
					),
				),
				if (_loading) const AppLoader(subText: 'Updating profile...'),
			],
		),
    );
	}

}

class _ModernTextField extends StatelessWidget {
	final TextEditingController controller;
	final String label;
	final IconData icon;
	final bool obscureText;
	final TextInputType? keyboardType;
	final String? Function(String?)? validator;

	const _ModernTextField({
		required this.controller,
		required this.label,
		required this.icon,
		this.obscureText = false,
		this.keyboardType,
		this.validator,
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				color: kWhiteGrey,
				borderRadius: BorderRadius.circular(16),
				boxShadow: [
					BoxShadow(
						color: kBrown.withAlpha(18),
						blurRadius: 8,
						offset: const Offset(0, 2),
					),
				],
			),
			child: TextFormField(
				controller: controller,
				obscureText: obscureText,
				keyboardType: keyboardType,
				validator: validator,
				style: const TextStyle(color: kBrown, fontWeight: FontWeight.w500),
				decoration: InputDecoration(
					prefixIcon: Icon(icon, color: kPink),
					labelText: label,
					labelStyle: kTaglineTextStyle.copyWith(color: kBrown),
					border: InputBorder.none,
					filled: true,
					fillColor: kWhiteGrey,
				),
			),
		);
	}
}

