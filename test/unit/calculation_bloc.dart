import 'package:basic_calculator/bloc/calculation_bloc.dart';
import 'package:basic_calculator/calculation_model.dart';
import 'package:basic_calculator/services/calculation_history_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

class MockCalculationHistoryService extends Mock implements CalculationHistoryService {}


void main() {
  group('CalculationBloc', () {
    blocTest(
      'emits [] when nothing is added',
      build: () => CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      ),
      expect: [],
    );

    blocTest(
      'first operand is set on number pressed',
      build: () => CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      ),
      act: (bloc) => bloc.add(NumberPressed(number: 1)),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 1,
            operator: null,
            secondOperand: null,
            result: null,
          ),
          history: []
        ),
      ],
    );

    blocTest(
      'first operand is concatenated when number pressed repeatedly',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 1));
        return bloc;
      } ,
      skip: 1,
      act: (bloc) => bloc.add(NumberPressed(number: 1)),
      expect: [
        CalculationChanged(
            calculationModel: CalculationModel(
              firstOperand: 11,
              operator: null,
              secondOperand: null,
              result: null,
            ),
            history: []
        )
      ],
    );

    blocTest(
      'operator is set when valid operator pressed and first operand is set',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 1));
        return bloc;
      } ,
      skip: 1,
      act: (bloc) => bloc.add(OperatorPressed(operator: '+')),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 1,
            operator: '+',
            secondOperand: null,
            result: null,
          ),
          history: []
        )
      ],
    );

    blocTest(
      'operator is not set when invalid operator pressed and first operand is set',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 1));
        return bloc;
      } ,
      skip: 1,
      act: (bloc) => bloc.add(OperatorPressed(operator: 'x')),
      expect: [],
    );

    blocTest(
      'second operand is set when first operand and operator is set and number pressed',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 1));
        bloc.add(OperatorPressed(operator: '+'));
        return bloc;
      } ,
      skip: 2,
      act: (bloc) => bloc.add(NumberPressed(number: 2)),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 1,
            operator: '+',
            secondOperand: 2,
            result: null,
          ),
          history: []
        )
      ],
    );

    blocTest(
      'first operand is concatenated when number pressed repeatedly',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 1));
        bloc.add(OperatorPressed(operator: '+'));
        bloc.add(NumberPressed(number: 3));
        bloc.add(NumberPressed(number: 3));
        return bloc;
      } ,
      skip: 4,
      act: (bloc) => bloc.add(NumberPressed(number: 7)),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 1,
            operator: '+',
            secondOperand: 337,
            result: null,
          ),
          history: []
        )
      ],
    );

    blocTest(
      'first operand is not concatenated when repeated number starts with zero',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 0));
        bloc.add(NumberPressed(number: 0));
        bloc.add(OperatorPressed(operator: '+'));
        return bloc;
      } ,
      skip: 2,
      act: (bloc) => bloc.add(NumberPressed(number: 0)),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 0,
            operator: '+',
            secondOperand: 0,
            result: null,
          ),
          history: []
        )
      ],
    );

    blocTest(
      'result is set when first operand, operator and second operand are set and result is requested',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 1));
        bloc.add(OperatorPressed(operator: '+'));
        bloc.add(NumberPressed(number: 432));
        return bloc;
      } ,
      skip: 3,
      act: (bloc) => bloc.add(CalculateResult()),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 433,
            operator: null,
            secondOperand: null,
            result: null,
          ),
          history: []
        )
      ],
    );

    blocTest(
      'result is not set when second operand and operator are not set and result is requested',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 1));
        return bloc;
      } ,
      skip: 2,
      act: (bloc) => bloc.add(CalculateResult()),
      expect: [],
    );

    blocTest(
      'result is not set when second operand is not set and result is requested',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 1));
        bloc.add(OperatorPressed(operator: '+'));
        return bloc;
      } ,
      skip: 2,
      act: (bloc) => bloc.add(CalculateResult()),
      expect: [],
    );

    blocTest(
      'calculation is reset when clear button is pressed',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 1));
        bloc.add(OperatorPressed(operator: '/'));
        bloc.add(NumberPressed(number: 10));
        return bloc;
      } ,
      skip: 3,
      act: (bloc) => bloc.add(ClearCalculation()),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: null,
            operator: null,
            secondOperand: null,
            result: null,
          ),
          history: []
        )
      ],
    );

    blocTest(
      'adding numbers works',
      build: () {
        CalculationBloc bloc = CalculationBloc(
        calculationHistoryService: MockCalculationHistoryService()
      );
        bloc.add(NumberPressed(number: 10));
        bloc.add(OperatorPressed(operator: '+'));
        bloc.add(NumberPressed(number: 123));
        return bloc;
      } ,
      skip: 3,
      act: (bloc) => bloc.add(CalculateResult()),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 133,
            operator: null,
            secondOperand: null,
            result: null,
          ),
          history: []
        )
      ],
    );

    blocTest(
      'subtracting numbers works',
      build: () {
        CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService()
       );
        bloc.add(NumberPressed(number: 123));
        bloc.add(OperatorPressed(operator: '-'));
        bloc.add(NumberPressed(number: 10));
        return bloc;
      } ,
      skip: 3,
      act: (bloc) => bloc.add(CalculateResult()),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 113,
            operator: null,
            secondOperand: null,
            result: null,
          ),
          history: []
        )
      ],
    );

    blocTest(
      'multiplying numbers works',
      build: () {
        CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService()
        );
        bloc.add(NumberPressed(number: 123));
        bloc.add(OperatorPressed(operator: '*'));
        bloc.add(NumberPressed(number: 10));
        return bloc;
      } ,
      skip: 3,
      act: (bloc) => bloc.add(CalculateResult()),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 1230,
            operator: null,
            secondOperand: null,
            result: null,
          ),
          history: []
        )
      ],
    );

    blocTest(
      'dividing numbers works',
      build: () {
        CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService()
        );
        bloc.add(NumberPressed(number: 123));
        bloc.add(OperatorPressed(operator: '/'));
        bloc.add(NumberPressed(number: 10));
        return bloc;
      } ,
      skip: 3,
      act: (bloc) => bloc.add(CalculateResult()),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 12,
            operator: null,
            secondOperand: null,
            result: null,
          ),
          history: []
        )
      ],
    );

    blocTest(
      'dividing by zero results in a calculation with result: 0',
      build: () {
        CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: MockCalculationHistoryService()
        );
        bloc.add(NumberPressed(number: 123));
        bloc.add(OperatorPressed(operator: '/'));
        bloc.add(NumberPressed(number: 0));
        return bloc;
      } ,
      skip: 3,
      act: (bloc) => bloc.add(
        CalculateResult()
      ),
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 0,
            operator: null,
            secondOperand: null,
            result: null
          ),
          history: []
        )
      ],
    );

    blocTest(
      'executing a calculation writes to the history and returns that result',
      build: () {
        CalculationHistoryService mock = MockCalculationHistoryService();
        CalculationModel expectedResultModel = CalculationModel(
          firstOperand: 123,
          operator: '+',
          secondOperand: 123,
          result: 246,
        );
        when(mock.fetchAllEntries())
        .thenAnswer((realInvocation) => [expectedResultModel]);
        when(mock.addEntry(any))
        .thenAnswer((realInvocation) async => true);

        CalculationBloc bloc = CalculationBloc(
          calculationHistoryService: mock
        );
        bloc.add(NumberPressed(number: 123));
        bloc.add(OperatorPressed(operator: '+'));
        bloc.add(NumberPressed(number: 123));
        return bloc;
      } ,
      skip: 3,
      act: (bloc) => bloc.add(
        CalculateResult()
      ),
      verify: (CalculationBloc bloc) {
        verify(bloc.calculationHistoryService.fetchAllEntries()).called(1);
        verify(bloc.calculationHistoryService.addEntry(any)).called(1);
      },
      expect: [
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 246,
            operator: null,
            secondOperand: null,
            result: null
          ),
          history: []
        ),
        CalculationChanged(
          calculationModel: CalculationModel(
            firstOperand: 246,
            operator: null,
            secondOperand: null,
            result: null
          ),
          history: [
            CalculationModel(
              firstOperand: 123,
              operator: '+',
              secondOperand: 123,
              result: 246
            )
          ]
        ),
      ],
    );
  });
}