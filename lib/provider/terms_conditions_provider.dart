import 'package:flutter_riverpod/legacy.dart';

import '../models/terms_conditions.dart';
import '../notifier/terms_conditions_notifier.dart';

final termsConditionsProvider =
    StateNotifierProvider<TermsConditionsNotifier, List<TermsConditions>>(
      (ref) => TermsConditionsNotifier(),
    );
