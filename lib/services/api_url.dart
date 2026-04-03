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
  static const String deleteEmployeeByAdmin =
      '/delete/employees/'; // Usage: /delete/employees/{employee_id}/admin/{admin_id}

  // Notifications
  static const String getNotificationsForEmployee =
      '/notifications/employee/'; // Usage: /notifications/employee/{employee_id}

  // Terms & Conditions
  static const String getTermsConditions =
      '/get/terms-conditions/'; // Usage: /get/terms-conditions/

  // Privacy Policy
  static const String getPrivacyPolicy =
      '/get/privacy-policy/'; // Usage: /get/privacy-policy/

  // Documentation
  static const String getDocumentation =
      '/get/documentation/'; // Usage: /get/documentation/

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

  // Current Location
  static const String postCurrentLocation =
      '/current-location/employee/'; // Usage: /current-location/employee/{employee_id}

  // Break Time
  static const String breakCheckIn =
      '/break-time/check-in/'; // Usage: /break-time/check-in/{employee_id}
  static const String breakCheckOut =
      '/break-time/check-out/'; // Usage: /break-time/check-out/{employee_id}
  static const String getBreaksByEmployee =
      '/break-time/employee/'; // Usage: /break-time/employee/{employee_id}

  // App Updates
  static const String getAllVersions = '/get-all/versions';
  static const String downloadSpecificApk =
      '/download/'; // Usage: /download/{filename}
  static const String downloadLatestApk = '/download-latest';
  static const String getLatestVersion = '/latest-version';
}
