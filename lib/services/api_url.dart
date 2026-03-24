
class ApiUrl {
	static const String baseUrl = 'http://10.0.2.2:8000'; // TODO: Replace with your backend URL

	static const String loginEmployee = '/login/employees/';
	static const String getEmployeeById = '/get-by/employees/'; // Usage: /get-by/employees/{employee_id}
	static const String updateEmployeeById = '/update/employees/'; // Usage: /update/employees/{employee_id}

	static const String getNotificationsForEmployee = '/notifications/employee/'; // Usage: /notifications/employee/{employee_id}

	static const String createLeaveRequest = '/create/leave_requests/';
	static const String getLeaveRequestsByEmployee = '/get-all/leave_requests/employee/'; // Usage: /get-all/leave_requests/employee/{employee_id}
	static const String deleteLeaveRequest = '/delete/leave_requests/'; // Usage: /delete/leave_requests/{leave_id}

	static const String getSalarySlipsByEmployee = '/salary_slip/employee/'; // Usage: /salary_slip/employee/{employee_id}
	static const String getSalarySlipPdf = '/salary_slip/pdf/'; // Usage: /salary_slip/pdf/{employee_id}/{slip_id}
}
