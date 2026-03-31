class BreakTime {
  final int? breakId;
  final int? attendanceId;
  final int? employeeId;
  final int? adminId;
  final DateTime? breakInTime;
  final String? breakInPhoto;
  final DateTime? breakOutTime;
  final String? breakOutPhoto;

  BreakTime({
    this.breakId,
    this.attendanceId,
    this.employeeId,
    this.adminId,
    this.breakInTime,
    this.breakInPhoto,
    this.breakOutTime,
    this.breakOutPhoto,
  });

  factory BreakTime.fromJson(Map<String, dynamic> json) {
    return BreakTime(
      breakId: json['break_id'],
      attendanceId: json['attendance_id'],
      employeeId: json['employee_id'],
      adminId: json['admin_id'],
      breakInTime: json['break_in_time'] != null
          ? DateTime.parse('${json['break_in_time']}Z').toLocal()
          : null,
      breakInPhoto: json['break_in_photo'],
      breakOutTime: json['break_out_time'] != null
          ? DateTime.parse('${json['break_out_time']}Z').toLocal()
          : null,
      breakOutPhoto: json['break_out_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'break_id': breakId,
      'attendance_id': attendanceId,
      'employee_id': employeeId,
      'admin_id': adminId,
      'break_in_time': breakInTime?.toIso8601String(),
      'break_in_photo': breakInPhoto,
      'break_out_time': breakOutTime?.toIso8601String(),
      'break_out_photo': breakOutPhoto,
    };
  }
}
