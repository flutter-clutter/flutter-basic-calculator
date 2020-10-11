import 'dart:convert';

import 'package:basic_calculator/calculation_model.dart';
import 'package:basic_calculator/services/calculation_history_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main () {
  group('Calculation history service', () {

    final sharedPrefKey = 'calculation_history';

    test('Properly fetches all entries', () async {
      CalculationModel expectedModel = _getCalculationModelSample();
      String mockedJson = jsonEncode([expectedModel.toJson()]);

      MockSharedPreferences mock = _getMockSharedPreferences(
        sharedPrefKey, mockedJson, true
      );

      List<CalculationModel> expectedResult = [expectedModel];

      expect(
        CalculationHistoryService(sharedPreferences: mock).fetchAllEntries(),
        expectedResult
      );
    });

    test('Properly fetches all entries if nothing has been stored yet', () async {
      String mockedJson = jsonEncode([]);

      MockSharedPreferences mock = _getMockSharedPreferences(
        sharedPrefKey, mockedJson, false
      );

      List<CalculationModel> expectedResult = [];

      expect(
        CalculationHistoryService(sharedPreferences: mock).fetchAllEntries(),
        expectedResult
      );
    });

    test('Shared preferences are called correctly when fetching etnries', () async {
      String mockedJson = jsonEncode([]);

      MockSharedPreferences mock = _getMockSharedPreferences(
        sharedPrefKey, mockedJson, true
      );

      CalculationHistoryService(sharedPreferences: mock).fetchAllEntries();

      verify(mock.getString(sharedPrefKey)).called(1);
    });

    test('Shared preferences are called once with the correct json string when adding new entry', () async {
      CalculationModel inputModel = _getCalculationModelSample();

      String mockedJson = jsonEncode([inputModel.toJson()]);

      MockSharedPreferences mock = _getMockSharedPreferences(
        sharedPrefKey, mockedJson, false
      );

      await CalculationHistoryService(sharedPreferences: mock).addEntry(
        inputModel
      );

      verify(mock.setString(sharedPrefKey, mockedJson)).called(1);
    });
  });
}

MockSharedPreferences _getMockSharedPreferences(String sharedPrefKey, String mockedJson, bool containsKey) {
  MockSharedPreferences mock = MockSharedPreferences();
  when(mock.getString(sharedPrefKey))
    .thenAnswer((realInvocation) => mockedJson);
  when(mock.containsKey(sharedPrefKey))
    .thenAnswer((realInvocation) => containsKey);
  return mock;
}

CalculationModel _getCalculationModelSample() {
  CalculationModel inputModel = CalculationModel(
    firstOperand: 1,
    operator: '+',
    secondOperand: 1,
    result: 2
  );
  return inputModel;
}