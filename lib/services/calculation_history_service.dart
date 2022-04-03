import 'dart:convert';

import 'package:basic_calculator/calculation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculationHistoryService {
  static const String _sharedPreferenceKey = 'calculation_history';

  CalculationHistoryService({required this.sharedPreferences});

  SharedPreferences sharedPreferences;

  List<CalculationModel> fetchAllEntries() {
    final List<CalculationModel> result = <CalculationModel>[];

    if (!sharedPreferences.containsKey(_sharedPreferenceKey)) {
      return [];
    }

    List<dynamic> history = [];

    try {
      final String? storedValue =
          sharedPreferences.getString(_sharedPreferenceKey);
      if (storedValue == null) {
        return [];
      }
      history = jsonDecode(storedValue) as List<dynamic>;
    } on FormatException {
      sharedPreferences.remove(_sharedPreferenceKey);
    }

    for (final dynamic entry in history) {
      result.add(CalculationModel.fromJson(entry as Map<String, dynamic>));
    }

    return result;
  }

  Future<bool> addEntry(CalculationModel model) async {
    final List<CalculationModel> allEntries = fetchAllEntries();
    allEntries.add(model);

    return sharedPreferences.setString(
      _sharedPreferenceKey,
      jsonEncode(allEntries),
    );
  }
}
