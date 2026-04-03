import 'package:flutter_riverpod/legacy.dart';

import '../models/privacy_policy.dart';
import '../services/privacy_policy_services.dart';

class PrivacyPolicyNotifier extends StateNotifier<List<PrivacyPolicy>> {
  final PrivacyPolicyServices _services = PrivacyPolicyServices();

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  PrivacyPolicyNotifier() : super(const []);

  Future<void> fetchPrivacyPolicies() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final items = await _services.getAllPrivacyPolicies();
      state = items;
    } catch (e) {
      _error = e.toString();
      state = const [];
    }
    _loading = false;
    notifyListeners();
  }

  // Helper to notify listeners for legacy StateNotifier
  void notifyListeners() {
    state = [...state];
  }
}
