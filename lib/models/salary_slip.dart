class SalarySlip {
  final int slipId;
  final int employeeId;
  final String fileName;
  final String fileUrl;
  final String month;
  final String year;

  SalarySlip({
    required this.slipId,
    required this.employeeId,
    required this.fileName,
    required this.fileUrl,
    required this.month,
    required this.year,
  });

  factory SalarySlip.fromJson(Map<String, dynamic> json) {
    return SalarySlip(
      slipId: json['slip_id'] ?? json['id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      fileName: json['file_name'] ?? '',
      fileUrl: json['file_url'] ?? '',
      month: json['month']?.toString() ?? '',
      year: json['year']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slip_id': slipId,
      'employee_id': employeeId,
      'file_name': fileName,
      'file_url': fileUrl,
      'month': month,
      'year': year,
    };
  }
}
