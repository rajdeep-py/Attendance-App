class Holiday {
  final int holidayId;
  final int adminId;
  final DateTime date;
  final String title;
  final String? remarks;

  Holiday({
    required this.holidayId,
    required this.adminId,
    required this.date,
    required this.title,
    this.remarks,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      holidayId: json['holiday_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      date: DateTime.parse(json['date']),
      title: json['occasion'] is Map ? (json['occasion']['title'] ?? '') : (json['occasion'] ?? ''),
      remarks: json['occasion'] is Map ? json['occasion']['remarks'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'holiday_id': holidayId,
      'admin_id': adminId,
      'date': date.toIso8601String(),
      'occasion': {
        'title': title,
        'remarks': remarks,
      },
    };
  }
}
