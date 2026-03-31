class ApiUrl {
  // Base URL
  static const String baseUrl =
      'https://attendxappbackend.naiyo24.com'; // Replace with your backend URL
  //static const String baseUrl = 'http://192.168.1.44:8000'; // For local testing
  // Employee Endpoints
  static const String loginEmployee = '/login/employees/';
  static const String getEmployeeById =
      '/get-by/employees/'; // Usage: /get-by/employees/{employee_id}
  static const String updateEmployeeById =
      '/update/employees/'; // Usage: /update/employees/{employee_id}

  // Notifications
  static const String getNotificationsForEmployee =
      '/notifications/employee/'; // Usage: /notifications/employee/{employee_id}

  // Leave Requests
  static const String createLeaveRequest = '/create/leave_requests/';
  static const String getLeaveRequestsByEmployee =
      '/get-all/leave_requests/employee/'; // Usage: /get-all/leave_requests/employee/{employee_id}
  static const String deleteLeaveRequest =
      '/delete/leave_requests/'; // Usage: /delete/leave_requests/{leave_id}

  // Salary Slips
  static const String getSalarySlipsByEmployee =
      '/salary_slip/employee/'; // Usage: /salary_slip/employee/{employee_id}
  static const String getSalarySlipPdf =
      '/salary_slip/pdf/'; // Usage: /salary_slip/pdf/{employee_id}/{slip_id}

  // Location Matrix
  static const String getLocationMatrixByAdmin =
      '/location-matrix/admin/'; // Usage: /location-matrix/admin/{admin_id}

  //Holidays
  static const String getHolidayByAdminAndId =
      '/get-holidays/'; // Usage: /get-holidays/{holiday_id}/admin/{admin_id}
  static const String getHolidaysByAdmin =
      '/get-holidays/admin/'; // Usage: /get-holidays/admin/{admin_id}

  // Attendance
  static const String attendanceCheckIn =
      '/attendance/check-in/'; // Usage: /attendance/check-in/{employee_id}
  static const String attendanceCheckOut =
      '/attendance/check-out/'; // Usage: /attendance/check-out/{employee_id}
  static const String getAttendanceByEmployee =
      '/attendance/employee/'; // Usage: /attendance/employee/{employee_id}
  static const String getAttendanceByAdminAndEmployee =
      '/attendance/admin/'; // Usage: /attendance/admin/{admin_id}/employee/{employee_id}

  // App Updates
  static const String getAllVersions = '/get-all/versions';
  static const String downloadSpecificApk =
      '/download/'; // Usage: /download/{filename}
  static const String downloadLatestApk = '/download-latest';
  static const String getLatestVersion = '/latest-version';
}
