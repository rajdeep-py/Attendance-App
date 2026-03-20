class Attendance {
	final DateTime? checkIn;
	final DateTime? checkOut;
	final String location;

	Attendance({
		this.checkIn,
		this.checkOut,
		this.location = '',
	});

	Attendance copyWith({
		DateTime? checkIn,
		DateTime? checkOut,
		String? location,
	}) {
		return Attendance(
			checkIn: checkIn ?? this.checkIn,
			checkOut: checkOut ?? this.checkOut,
			location: location ?? this.location,
		);
	}
}
