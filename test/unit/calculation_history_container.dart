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

    test('Properly fetches its data', () async {
      CalculationModel expectedModel = CalculationModel(
        firstOperand: 1,
        operator: '+',
        secondOperand: 1,
        result: 2
      );
      String mockedJson = jsonEncode([expectedModel.toJson()]);

      MockSharedPreferences mock = MockSharedPreferences();
      when(mock.getString(sharedPrefKey))
        .thenAnswer((realInvocation) => mockedJson);
      when(mock.containsKey(sharedPrefKey))
          .thenAnswer((realInvocation) => true);

      List<CalculationModel> expectedResult = [expectedModel];

      expect(
        await CalculationHistoryService(sharedPreferences: mock).fetchAllEntries(),
        expectedResult
      );
    });

    test('Properly fetches its if it\'s not yet stored', () async {
      String mockedJson = jsonEncode([]);

      MockSharedPreferences mock = MockSharedPreferences();
      when(mock.getString(sharedPrefKey))
        .thenAnswer((realInvocation) => mockedJson);
      when(mock.containsKey(sharedPrefKey))
        .thenAnswer((realInvocation) => false);

      List<CalculationModel> expectedResult = [];

      expect(
        await CalculationHistoryService(sharedPreferences: mock).fetchAllEntries(),
        expectedResult
      );
    });

    test('Properly stores its data', () async {
      CalculationModel inputModel = CalculationModel(
        firstOperand: 1,
        operator: '+',
        secondOperand: 1,
        result: 2
      );

      String mockedJson = jsonEncode([inputModel.toJson()]);

      MockSharedPreferences mock = MockSharedPreferences();
      when(mock.getString(sharedPrefKey))
          .thenAnswer((realInvocation) => '[]');
      when(mock.containsKey(sharedPrefKey))
          .thenAnswer((realInvocation) => true);

      await CalculationHistoryService(sharedPreferences: mock).addEntry(
        inputModel
      );
      verify(mock.setString(sharedPrefKey, mockedJson)).called(1);
    });
  });
}