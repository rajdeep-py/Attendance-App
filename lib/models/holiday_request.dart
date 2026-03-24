class HolidayRequest {
  final DateTime date;
  final String reason;
  final String message;
  final int? leaveId;
  final int? adminId;
  final int? employeeId;
  final String? status;

  HolidayRequest({
    required this.date,
    required this.reason,
    required this.message,
    this.leaveId,
    this.adminId,
    this.employeeId,
    this.status,
  });

  factory HolidayRequest.fromJson(Map<String, dynamic> json) {
    // Handle date as either full ISO or just yyyy-MM-dd
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['date']);
    } catch (_) {
      parsedDate = DateTime.now();
    }
    return HolidayRequest(
      date: parsedDate,
      reason: json['reason'] ?? '',
      message: json['message'] ?? json['reason'] ?? json['subtitle'] ?? '',
      leaveId: json['leave_id'],
      adminId: json['admin_id'],
      employeeId: json['employee_id'],
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'reason': reason,
      'message': message,
      'leave_id': leaveId,
      'admin_id': adminId,
      'employee_id': employeeId,
      'status': status,
    };
  }
}
