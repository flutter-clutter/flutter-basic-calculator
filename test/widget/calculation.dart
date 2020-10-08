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

  testWidgets('Display shows result when calculation was entered', (WidgetTester tester) async {
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
    await tester.tap(find.widgetWithText(CalculatorButton, '3'));
    await tester.tap(find.widgetWithText(CalculatorButton, '='));
    await tester.tap(find.widgetWithText(CalculatorButton, 'C'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ResultDisplay, '0'), findsOneWidget);
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
}

Future _setSize(TestWidgetsFlutterBinding binding) async {
  await binding.setSurfaceSize(Size(1080, 2340));
}
