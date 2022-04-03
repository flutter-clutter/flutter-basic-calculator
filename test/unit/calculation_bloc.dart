import 'package:basic_calculator/bloc/calculation_bloc.dart';
import 'package:basic_calculator/calculation_model.dart';
import 'package:basic_calculator/services/calculation_history_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCalculationHistoryService extends Mock
    implements CalculationHistoryService {}

void main() {
  setUpAll(() {
    registerFallbackValue(const CalculationModel());
  });

  group('CalculationBloc', () {
    blocTest(
      'emits [] when nothing is added',
      build: () => CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService(),
      ),
      expect: () => [],
    );

    blocTest(
      'first operand is set on number pressed',
      build: () => CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService(),
      ),
      act: (CalculationBloc bloc) => bloc.add(
        const NumberPressed(number: 1),
      ),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 1,
          ),
          history: [],
        ),
      ],
    );

    blocTest(
      'first operand is concatenated when number pressed repeatedly',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 1));
        return bloc;
      },
      skip: 1,
      act: (CalculationBloc bloc) => bloc.add(const NumberPressed(number: 1)),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 11,
          ),
          history: [],
        )
      ],
    );

    blocTest(
      'operator is set when valid operator pressed and first operand is set',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 1));
        return bloc;
      },
      skip: 1,
      act: (CalculationBloc bloc) =>
          bloc.add(const OperatorPressed(operator: '+')),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 1,
            operator: '+',
          ),
          history: [],
        )
      ],
    );

    blocTest(
      'operator is not set when invalid operator pressed and first operand is set',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 1));
        return bloc;
      },
      skip: 1,
      act: (CalculationBloc bloc) =>
          bloc.add(const OperatorPressed(operator: 'x')),
      expect: () => [],
    );

    blocTest(
      'second operand is set when first operand and operator is set and number pressed',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 1));
        bloc.add(const OperatorPressed(operator: '+'));
        return bloc;
      },
      skip: 2,
      act: (CalculationBloc bloc) => bloc.add(const NumberPressed(number: 2)),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 1,
            operator: '+',
            secondOperand: 2,
          ),
          history: [],
        )
      ],
    );

    blocTest(
      'first operand is concatenated when number pressed repeatedly',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 1));
        bloc.add(const OperatorPressed(operator: '+'));
        bloc.add(const NumberPressed(number: 3));
        bloc.add(const NumberPressed(number: 3));
        return bloc;
      },
      skip: 4,
      act: (CalculationBloc bloc) => bloc.add(const NumberPressed(number: 7)),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 1,
            operator: '+',
            secondOperand: 337,
          ),
          history: [],
        )
      ],
    );

    blocTest(
      'first operand is not concatenated when repeated number starts with zero',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 0));
        bloc.add(const NumberPressed(number: 0));
        bloc.add(const OperatorPressed(operator: '+'));
        return bloc;
      },
      skip: 2,
      act: (CalculationBloc bloc) => bloc.add(const NumberPressed(number: 0)),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 0,
            operator: '+',
            secondOperand: 0,
          ),
          history: [],
        )
      ],
    );

    blocTest(
      'result is set when first operand, operator and second operand are set and result is requested',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 1));
        bloc.add(const OperatorPressed(operator: '+'));
        bloc.add(const NumberPressed(number: 432));
        return bloc;
      },
      skip: 3,
      act: (CalculationBloc bloc) => bloc.add(CalculateResult()),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 433,
          ),
          history: [],
        )
      ],
    );

    blocTest(
      'result is not set when second operand and operator are not set and result is requested',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 1));
        return bloc;
      },
      skip: 2,
      act: (CalculationBloc bloc) => bloc.add(CalculateResult()),
      expect: () => [],
    );

    blocTest(
      'result is not set when second operand is not set and result is requested',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 1));
        bloc.add(const OperatorPressed(operator: '+'));
        return bloc;
      },
      skip: 2,
      act: (CalculationBloc bloc) => bloc.add(CalculateResult()),
      expect: () => [],
    );

    blocTest(
      'calculation is reset when clear button is pressed',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 1));
        bloc.add(const OperatorPressed(operator: '/'));
        bloc.add(const NumberPressed(number: 10));
        return bloc;
      },
      skip: 3,
      act: (CalculationBloc bloc) => bloc.add(ClearCalculation()),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(),
          history: [],
        )
      ],
    );

    blocTest(
      'adding numbers works',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 10));
        bloc.add(const OperatorPressed(operator: '+'));
        bloc.add(const NumberPressed(number: 123));
        return bloc;
      },
      skip: 3,
      act: (CalculationBloc bloc) => bloc.add(CalculateResult()),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 133,
          ),
          history: [],
        )
      ],
    );

    blocTest(
      'subtracting numbers works',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 123));
        bloc.add(const OperatorPressed(operator: '-'));
        bloc.add(const NumberPressed(number: 10));
        return bloc;
      },
      skip: 3,
      act: (CalculationBloc bloc) => bloc.add(CalculateResult()),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 113,
          ),
          history: [],
        )
      ],
    );

    blocTest(
      'multiplying numbers works',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 123));
        bloc.add(const OperatorPressed(operator: '*'));
        bloc.add(const NumberPressed(number: 10));
        return bloc;
      },
      skip: 3,
      act: (CalculationBloc bloc) => bloc.add(CalculateResult()),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 1230,
          ),
          history: [],
        )
      ],
    );

    blocTest(
      'dividing numbers works',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 123));
        bloc.add(const OperatorPressed(operator: '/'));
        bloc.add(const NumberPressed(number: 10));
        return bloc;
      },
      skip: 3,
      act: (CalculationBloc bloc) => bloc.add(CalculateResult()),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 12,
          ),
          history: [],
        )
      ],
    );

    blocTest(
      'dividing by zero results in a calculation with result: 0',
      build: () {
        final CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService(),
        );
        bloc.add(const NumberPressed(number: 123));
        bloc.add(const OperatorPressed(operator: '/'));
        bloc.add(const NumberPressed(number: 0));
        return bloc;
      },
      skip: 3,
      act: (CalculationBloc bloc) => bloc.add(CalculateResult()),
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(firstOperand: 0),
          history: [],
        )
      ],
    );

    blocTest(
      'executing a calculation writes to the history and returns that result',
      build: () {
        final CalculationHistoryService mock = MockCalculationHistoryService();
        const CalculationModel expectedResultModel = CalculationModel(
          firstOperand: 123,
          operator: '+',
          secondOperand: 123,
          result: 246,
        );
        when(() => mock.fetchAllEntries()).thenAnswer(
          (realInvocation) => [expectedResultModel],
        );
        when(() => mock.addEntry(any())).thenAnswer(
          (realInvocation) async => true,
        );

        final CalculationBloc bloc =
            CalculationBloc(calculationHistoryService: mock);
        bloc.add(const NumberPressed(number: 123));
        bloc.add(const OperatorPressed(operator: '+'));
        bloc.add(const NumberPressed(number: 123));
        return bloc;
      },
      skip: 3,
      act: (CalculationBloc bloc) => bloc.add(CalculateResult()),
      verify: (CalculationBloc bloc) {
        verify(() => bloc.calculationHistoryService.fetchAllEntries())
            .called(1);
        verify(() => bloc.calculationHistoryService.addEntry(any())).called(1);
      },
      expect: () => [
        const CalculationChanged(
          calculationModel: CalculationModel(firstOperand: 246),
          history: [],
        ),
        const CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 246,
          ),
          history: [
            CalculationModel(
              firstOperand: 123,
              operator: '+',
              secondOperand: 123,
              result: 246,
            )
          ],
        ),
      ],
    );
  });
}
