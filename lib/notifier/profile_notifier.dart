import 'package:flutter_riverpod/legacy.dart';
import '../models/user.dart';
import '../services/auth_services.dart';

class ProfileNotifier extends StateNotifier<User?> {
  final AuthServices _authServices = AuthServices();

  ProfileNotifier() : super(null);

  Future<void> fetchProfile(int employeeId) async {
    try {
      final user = await _authServices.getEmployeeById(employeeId);
      state = user;
    } catch (e) {
      state = null;
      rethrow;
    }
  }

  Future<void> updateProfile({
    required int employeeId,
    String? fullName,
    String? phoneNo,
    String? email,
    String? address,
    String? designation,
    String? password,
    String? bankAccountNo,
    String? bankName,
    String? branchName,
    String? ifscCode,
    String? profilePhotoPath,
  }) async {
    try {
      final user = await _authServices.updateEmployeeProfile(
        employeeId: employeeId,
        fullName: fullName,
        phoneNo: phoneNo,
        email: email,
        address: address,
        designation: designation,
        password: password,
        bankAccountNo: bankAccountNo,
        bankName: bankName,
        branchName: branchName,
        ifscCode: ifscCode,
        profilePhotoPath: profilePhotoPath,
      );
      state = user;
    } catch (e) {
      rethrow;
    }
  }
}
