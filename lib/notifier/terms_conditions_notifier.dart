import 'package:flutter_riverpod/legacy.dart';

import '../models/terms_conditions.dart';
import '../services/terms_conditions_services.dart';

class TermsConditionsNotifier extends StateNotifier<List<TermsConditions>> {
  final TermsConditionsServices _services = TermsConditionsServices();

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  TermsConditionsNotifier() : super(const []);

  Future<void> fetchTermsConditions() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final items = await _services.getAllTermsConditions();
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
