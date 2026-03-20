class Attendance {
	final DateTime? checkIn;
	final DateTime? checkOut;
	final String location;
	final String? checkInSelfie;
	final String? checkOutSelfie;

	Attendance({
		this.checkIn,
		this.checkOut,
		this.location = '',
		this.checkInSelfie,
		this.checkOutSelfie,
	});

	Attendance copyWith({
		DateTime? checkIn,
		DateTime? checkOut,
		String? location,
		String? checkInSelfie,
		String? checkOutSelfie,
	}) {
		return Attendance(
			checkIn: checkIn ?? this.checkIn,
			checkOut: checkOut ?? this.checkOut,
			location: location ?? this.location,
			checkInSelfie: checkInSelfie ?? this.checkInSelfie,
			checkOutSelfie: checkOutSelfie ?? this.checkOutSelfie,
		);
	}
}
