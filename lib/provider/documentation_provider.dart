import 'package:flutter_riverpod/legacy.dart';

import '../models/documentation.dart';
import '../notifier/documentation_notifier.dart';

final documentationProvider =
    StateNotifierProvider<DocumentationNotifier, List<Documentation>>(
      (ref) => DocumentationNotifier(),
    );
