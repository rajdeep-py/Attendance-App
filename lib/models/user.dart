class User {
	final String id;
	final String phone;
	final String name;
	final String password;

	User({
		required this.id,
		required this.phone,
		required this.name,
		required this.password,
	});

	User copyWith({
		String? id,
		String? phone,
		String? name,
		String? password,
	}) {
		return User(
			id: id ?? this.id,
			phone: phone ?? this.phone,
			name: name ?? this.name,
			password: password ?? this.password,
		);
	}
}
