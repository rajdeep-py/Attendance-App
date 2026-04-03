import 'package:flutter_riverpod/legacy.dart';

import '../models/documentation.dart';
import '../services/documentation_services.dart';

class DocumentationNotifier extends StateNotifier<List<Documentation>> {
  final DocumentationServices _services = DocumentationServices();

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  DocumentationNotifier() : super(const []);

  Future<void> fetchDocumentation() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final items = await _services.getAllDocumentation();
      state = items;
    } catch (e) {
      _error = e.toString();
      state = const [];
    }
    _loading = false;
    notifyListeners();
  }

  void notifyListeners() {
    state = [...state];
  }
}
