import 'package:basic_calculator/calculator_button.dart';
import 'package:basic_calculator/result_display.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:basic_calculator/main.dart';
import 'package:flutter/material.dart';

void main() {
  final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Display shows "0" initially', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

    expect(find.widgetWithText(ResultDisplay, '0'), findsOneWidget);
  });

  testWidgets('Display shows number when tapped', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

    await tester.tap(find.widgetWithText(CalculatorButton, '3'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ResultDisplay, '3'), findsOneWidget);
  });

  testWidgets('Display shows first operand and operator', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

    await tester.tap(find.widgetWithText(CalculatorButton, '3'));
    await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ResultDisplay, '3x'), findsOneWidget);
  });

  testWidgets('Display shows first operand, operator and second operand', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

    await tester.tap(find.widgetWithText(CalculatorButton, '3'));
    await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
    await tester.tap(find.widgetWithText(CalculatorButton, '4'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ResultDisplay, '3x4'), findsOneWidget);
  });

  testWidgets('Display shows correct result after single calculation', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

    await tester.tap(find.widgetWithText(CalculatorButton, '3'));
    await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
    await tester.tap(find.widgetWithText(CalculatorButton, '4'));
    await tester.tap(find.widgetWithText(CalculatorButton, '='));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ResultDisplay, '12'), findsOneWidget);
  });

  testWidgets('Display shows "0" after clearing', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

    await tester.tap(find.widgetWithText(CalculatorButton, '3'));
    await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
    await tester.tap(find.widgetWithText(CalculatorButton, '4'));
    await tester.tap(find.widgetWithText(CalculatorButton, '='));
    await tester.tap(find.widgetWithText(CalculatorButton, 'C'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ResultDisplay, '0'), findsOneWidget);
  });

  testWidgets('Display shows correct second calculation after chained calculation', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

    await tester.tap(find.widgetWithText(CalculatorButton, '3'));
    await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
    await tester.tap(find.widgetWithText(CalculatorButton, '4'));
    await tester.tap(find.widgetWithText(CalculatorButton, '='));
    await tester.tap(find.widgetWithText(CalculatorButton, 'x'));
    await tester.tap(find.widgetWithText(CalculatorButton, '3'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ResultDisplay, '12x3'), findsOneWidget);
  });

  testWidgets('Display shows correct result after chained calculation', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

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

  testWidgets('Display shows integer after division', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

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

  testWidgets('Display shows "0" after division by zero', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

    await tester.tap(find.widgetWithText(CalculatorButton, '3'));
    await tester.tap(find.widgetWithText(CalculatorButton, '/'));
    await tester.tap(find.widgetWithText(CalculatorButton, '0'));
    await tester.tap(find.widgetWithText(CalculatorButton, '='));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ResultDisplay, '0'), findsOneWidget);
  });

  testWidgets('Repeatedly pressing "0" does not extend the displayed number', (WidgetTester tester) async {
    await _setSize(binding);

    await tester.pumpWidget(
      CalculatorApp()
    );

    await tester.tap(find.widgetWithText(CalculatorButton, '0'));
    await tester.tap(find.widgetWithText(CalculatorButton, '0'));
    await tester.tap(find.widgetWithText(CalculatorButton, '+'));
    await tester.tap(find.widgetWithText(CalculatorButton, '0'));
    await tester.tap(find.widgetWithText(CalculatorButton, '0'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ResultDisplay, '0+0'), findsOneWidget);
  });
}

Future _setSize(TestWidgetsFlutterBinding binding) async {
  await binding.setSurfaceSize(Size(1080, 2340));
}
