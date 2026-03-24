
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/profile_provider.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

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
		return Scaffold(
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
						children: [
							TextFormField(
								controller: _fullNameController,
								decoration: const InputDecoration(labelText: 'Full Name'),
								validator: (v) => v == null || v.isEmpty ? 'Required' : null,
							),
							TextFormField(
								controller: _phoneController,
								decoration: const InputDecoration(labelText: 'Phone Number'),
								validator: (v) => v == null || v.isEmpty ? 'Required' : null,
							),
							TextFormField(
								controller: _emailController,
								decoration: const InputDecoration(labelText: 'Email'),
								validator: (v) => v == null || v.isEmpty ? 'Required' : null,
							),
							TextFormField(
								controller: _addressController,
								decoration: const InputDecoration(labelText: 'Address'),
							),
							TextFormField(
								controller: _designationController,
								decoration: const InputDecoration(labelText: 'Designation'),
							),
							TextFormField(
								controller: _passwordController,
								decoration: const InputDecoration(labelText: 'Password'),
								obscureText: true,
							),
							TextFormField(
								controller: _bankAccountController,
								decoration: const InputDecoration(labelText: 'Bank Account No'),
							),
							TextFormField(
								controller: _bankNameController,
								decoration: const InputDecoration(labelText: 'Bank Name'),
							),
							TextFormField(
								controller: _branchNameController,
								decoration: const InputDecoration(labelText: 'Branch Name'),
							),
							TextFormField(
								controller: _ifscController,
								decoration: const InputDecoration(labelText: 'IFSC Code'),
							),
							const SizedBox(height: 24),
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
									style: ElevatedButton.styleFrom(backgroundColor: kBrown),
									child: _loading
											? const CircularProgressIndicator(color: Colors.white)
											: const Text('Update'),
								),
							),
						],
					),
				),
			),
		);
	}
}
