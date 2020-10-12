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

    test('Shared preferences (getString) is called once when storage key exists', () async {
      String mockedJson = jsonEncode([]);

      MockSharedPreferences mock = _getMockSharedPreferences(
          sharedPrefKey, mockedJson, true
      );

      CalculationHistoryService(sharedPreferences: mock).fetchAllEntries();

      verify(mock.getString(sharedPrefKey)).called(1);
    });

    test('Properly fetches all entries from shared preferences if storage key exists', () async {
      CalculationModel expectedModel = _getCalculationModelAddSample();
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

    test('Properly fetches empty list if nothing has been stored yet', () async {
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

    test('If there is corrupt JSON in the shared preferences, it is deleted and an empty list is returned', () async {
      MockSharedPreferences mock = _getMockSharedPreferences(
        sharedPrefKey, 'invalid JSON', true
      );

      expect(
        CalculationHistoryService(sharedPreferences: mock).fetchAllEntries(),
        []
      );

      verify(mock.getString(sharedPrefKey)).called(1);
      verify(mock.remove(sharedPrefKey)).called(1);
    });

    test('Shared preferences are called once when adding new entry on an empty list', () async {
      CalculationModel inputModel = _getCalculationModelAddSample();

      String mockedJson = jsonEncode([inputModel.toJson()]);

      MockSharedPreferences mock = _getMockSharedPreferences(
        sharedPrefKey, mockedJson, false
      );

      await CalculationHistoryService(sharedPreferences: mock).addEntry(
        inputModel
      );

      verifyNever(mock.getString(sharedPrefKey));
      verify(mock.setString(sharedPrefKey, mockedJson)).called(1);
    });

    test('Shared preferences are called once with the correct json string when adding new entry on an existing list', () async {
      CalculationModel inputModel = _getCalculationModelAddSample();

      String mockedExistingJson = jsonEncode([inputModel.toJson()]);

      MockSharedPreferences mock = _getMockSharedPreferences(
        sharedPrefKey, mockedExistingJson, true
      );

      String mockedExpectedJson = jsonEncode([
        inputModel.toJson(), _getCalculationModelSubtractSample().toJson()
      ]);

      await CalculationHistoryService(sharedPreferences: mock).addEntry(
        _getCalculationModelSubtractSample()
      );

      verify(mock.getString(sharedPrefKey)).called(1);
      verify(mock.setString(sharedPrefKey, mockedExpectedJson)).called(1);
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

CalculationModel _getCalculationModelAddSample() {
  CalculationModel inputModel = CalculationModel(
    firstOperand: 1,
    operator: '+',
    secondOperand: 1,
    result: 2
  );
  return inputModel;
}

CalculationModel _getCalculationModelSubtractSample() {
  CalculationModel inputModel = CalculationModel(
    firstOperand: 10,
    operator: '-',
    secondOperand: 6,
    result: 4
  );
  return inputModel;
}