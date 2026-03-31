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

	factory Attendance.fromJson(Map<String, dynamic> json) {
		return Attendance(
			checkIn: json['check_in_time'] != null ? DateTime.tryParse('${json['check_in_time']}Z')?.toLocal() : null,
			checkOut: json['check_out_time'] != null ? DateTime.tryParse('${json['check_out_time']}Z')?.toLocal() : null,
			location: json['location'] ?? '',
			checkInSelfie: json['check_in_photo'],
			checkOutSelfie: json['check_out_photo'],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'check_in_time': checkIn?.toIso8601String(),
			'check_out_time': checkOut?.toIso8601String(),
			'location': location,
			'check_in_photo': checkInSelfie,
			'check_out_photo': checkOutSelfie,
		};
	}

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
