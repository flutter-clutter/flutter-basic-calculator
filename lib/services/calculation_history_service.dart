import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../calculation_model.dart';

class CalculationHistoryService {
  CalculationHistoryService({
    @required this.sharedPreferences
  }) : assert (sharedPreferences != null);

  SharedPreferences sharedPreferences;

  List<CalculationModel> fetchAllEntries() {
    List<CalculationModel> result = <CalculationModel>[];

    if (!sharedPreferences.containsKey('calculation_history')) {
      return [];
    }

    List<dynamic> history = jsonDecode(
        sharedPreferences.getString('calculation_history')
    );

    for (var entry in history) {
      result.add(
          CalculationModel.fromJson(entry)
      );
    };

    return result;
  }

  Future<bool> addEntry(CalculationModel model) async {
    List<CalculationModel> allEntries = fetchAllEntries();
    allEntries.add(model);

    return sharedPreferences.setString(
      'calculation_history',
      jsonEncode(allEntries)
    );
  }
}