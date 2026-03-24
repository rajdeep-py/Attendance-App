class User {
	final int? employeeId;
	final int? adminId;
	final String fullName;
	final String phoneNo;
	final String email;
	final String address;
	final String designation;
	final String password;
	final String bankAccountNo;
	final String bankName;
	final String branchName;
	final String ifscCode;
	final String? profilePhoto;

	User({
		this.employeeId,
		this.adminId,
		required this.fullName,
		required this.phoneNo,
		required this.email,
		required this.address,
		required this.designation,
		required this.password,
		required this.bankAccountNo,
		required this.bankName,
		required this.branchName,
		required this.ifscCode,
		this.profilePhoto,
	});

	factory User.fromJson(Map<String, dynamic> json) {
		return User(
			employeeId: json['employee_id'] as int?,
			adminId: json['admin_id'] as int?,
			fullName: json['full_name'] ?? '',
			phoneNo: json['phone_no'] ?? '',
			email: json['email'] ?? '',
			address: json['address'] ?? '',
			designation: json['designation'] ?? '',
			password: json['password'] ?? '',
			bankAccountNo: json['bank_account_no'] ?? '',
			bankName: json['bank_name'] ?? '',
			branchName: json['branch_name'] ?? '',
			ifscCode: json['ifsc_code'] ?? '',
			profilePhoto: json['profile_photo'],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'employee_id': employeeId,
			'admin_id': adminId,
			'full_name': fullName,
			'phone_no': phoneNo,
			'email': email,
			'address': address,
			'designation': designation,
			'password': password,
			'bank_account_no': bankAccountNo,
			'bank_name': bankName,
			'branch_name': branchName,
			'ifsc_code': ifscCode,
			'profile_photo': profilePhoto,
		};
	}

	User copyWith({
		int? employeeId,
		int? adminId,
		String? fullName,
		String? phoneNo,
		String? email,
		String? address,
		String? designation,
		String? password,
		String? bankAccountNo,
		String? bankName,
		String? branchName,
		String? ifscCode,
		String? profilePhoto,
	}) {
		return User(
			employeeId: employeeId ?? this.employeeId,
			adminId: adminId ?? this.adminId,
			fullName: fullName ?? this.fullName,
			phoneNo: phoneNo ?? this.phoneNo,
			email: email ?? this.email,
			address: address ?? this.address,
			designation: designation ?? this.designation,
			password: password ?? this.password,
			bankAccountNo: bankAccountNo ?? this.bankAccountNo,
			bankName: bankName ?? this.bankName,
			branchName: branchName ?? this.branchName,
			ifscCode: ifscCode ?? this.ifscCode,
			profilePhoto: profilePhoto ?? this.profilePhoto,
		);
	}
}
