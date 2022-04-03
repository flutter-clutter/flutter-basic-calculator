import 'package:basic_calculator/bloc/calculation_bloc.dart';
import 'package:basic_calculator/calculation.dart';
import 'package:basic_calculator/calculation_history_container.dart';
import 'package:basic_calculator/calculation_model.dart';
import 'package:basic_calculator/calculator_button.dart';
import 'package:basic_calculator/result_display.dart';
import 'package:basic_calculator/services/calculation_history_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCalculationHistoryService extends Mock
    implements CalculationHistoryService {}

void main() {
  setUpAll(() {
    registerFallbackValue(const CalculationModel());
  });

  group('Calculation Widget', () {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized()
            as TestWidgetsFlutterBinding;

    testWidgets('Display shows "0" initially', (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      expect(find.widgetWithText(ResultDisplay, '0'), findsOneWidget);
    });

    testWidgets('Display shows number when tapped',
        (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ResultDisplay, '3'), findsOneWidget);
    });

    testWidgets('Display shows first operand and operator',
        (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ResultDisplay, '3*'), findsOneWidget);
    });

    testWidgets('Display shows first operand, operator and second operand',
        (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
      await tester.tap(find.widgetWithText(CalculatorButton, '4'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ResultDisplay, '3*4'), findsOneWidget);
    });

    testWidgets('Display shows correct result after single calculation',
        (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
      await tester.tap(find.widgetWithText(CalculatorButton, '4'));
      await tester.tap(find.widgetWithText(CalculatorButton, '='));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ResultDisplay, '12'), findsOneWidget);
    });

    testWidgets('Display shows "0" after clearing',
        (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
      await tester.tap(find.widgetWithText(CalculatorButton, '4'));
      await tester.tap(find.widgetWithText(CalculatorButton, '='));
      await tester.tap(find.widgetWithText(CalculatorButton, 'C'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ResultDisplay, '0'), findsOneWidget);
    });

    testWidgets(
        'Display shows correct second calculation after chained calculation',
        (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
      await tester.tap(find.widgetWithText(CalculatorButton, '4'));
      await tester.tap(find.widgetWithText(CalculatorButton, '='));
      await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ResultDisplay, '12*3'), findsOneWidget);
    });

    testWidgets('Display shows correct result after chained calculation',
        (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
      await tester.tap(find.widgetWithText(CalculatorButton, '4'));
      await tester.tap(find.widgetWithText(CalculatorButton, '='));
      await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.tap(find.widgetWithText(CalculatorButton, '='));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ResultDisplay, '36'), findsOneWidget);
    });

    testWidgets('Display shows integer after division',
        (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      await tester.tap(find.widgetWithText(CalculatorButton, '2'));
      await tester.tap(find.widgetWithText(CalculatorButton, '0'));
      await tester.tap(find.widgetWithText(CalculatorButton, '/'));
      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ResultDisplay, '20/3'), findsOneWidget);
      await tester.tap(find.widgetWithText(CalculatorButton, '='));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ResultDisplay, '6'), findsOneWidget);
    });

    testWidgets('Display shows "0" after division by zero',
        (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.tap(find.widgetWithText(CalculatorButton, '/'));
      await tester.tap(find.widgetWithText(CalculatorButton, '0'));
      await tester.tap(find.widgetWithText(CalculatorButton, '='));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ResultDisplay, '0'), findsOneWidget);
    });

    testWidgets('Repeatedly pressing "0" does not extend the displayed number',
        (WidgetTester tester) async {
      await _setSize(binding);

      await tester.pumpWidget(_getAppWithMockedSharedPreferences());

      await tester.tap(find.widgetWithText(CalculatorButton, '0'));
      await tester.tap(find.widgetWithText(CalculatorButton, '0'));
      await tester.tap(find.widgetWithText(CalculatorButton, '+'));
      await tester.tap(find.widgetWithText(CalculatorButton, '0'));
      await tester.tap(find.widgetWithText(CalculatorButton, '0'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ResultDisplay, '0+0'), findsOneWidget);
    });

    testWidgets('History is shown correctly after single calculation',
        (WidgetTester tester) async {
      await _setSize(binding);

      final CalculationHistoryService mock = MockCalculationHistoryService();
      when(() => mock.addEntry(any()))
          .thenAnswer((realInvocation) async => true);
      when(() => mock.fetchAllEntries()).thenAnswer(
        (realInvocation) => [
          const CalculationModel(
            firstOperand: 3,
            operator: '*',
            secondOperand: 4,
            result: 12,
          )
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create: (context) {
                return CalculationBloc(calculationHistoryService: mock);
              },
              child: const Calculation(),
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(CalculatorButton, '3'));
      await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
      await tester.tap(find.widgetWithText(CalculatorButton, '4'));
      await tester.tap(find.widgetWithText(CalculatorButton, '='));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(CalculationHistoryContainer, '3 * 4 = 12'),
        findsOneWidget,
      );
    });
  });
}

MaterialApp _getAppWithMockedSharedPreferences() {
  final CalculationHistoryService mock = MockCalculationHistoryService();

  when(() => mock.addEntry(any())).thenAnswer((realInvocation) async => true);
  when(() => mock.fetchAllEntries()).thenAnswer(
    (realInvocation) => [
      const CalculationModel(
        firstOperand: 3,
        operator: '*',
        secondOperand: 4,
        result: 12,
      )
    ],
  );

  return MaterialApp(
    home: Scaffold(
      body: BlocProvider(
        create: (context) {
          return CalculationBloc(calculationHistoryService: mock);
        },
        child: const Calculation(),
      ),
    ),
  );
}

Future _setSize(TestWidgetsFlutterBinding binding) async {
  await binding.setSurfaceSize(const Size(1080, 2340));
}
