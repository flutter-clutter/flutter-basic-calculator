import 'dart:async';
import 'dart:developer';

import 'package:basic_calculator/calculation_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'calculation_state.dart';
import 'calculation_event.dart';

export 'calculation_state.dart';
export 'calculation_event.dart';

class CalculationBloc extends Bloc<CalculationEvent, CalculationState> {
  CalculationBloc() : super(CalculationInitial());

  @override
  Stream<CalculationState> mapEventToState(
    CalculationEvent event,
  ) async* {
    if (event is NumberPressed) {
      yield await _mapNumberPressedToState(event);
    }

    if (event is OperatorPressed) {
      yield await _mapOperatorPressedToState(event);
    }

    if (event is CalculateResult) {
      yield await _mapCalculateResultToState(event);
    }

    if (event is ClearCalculation) {
      yield CalculationInitial();
    }
  }

  Future<CalculationState> _mapNumberPressedToState(
    NumberPressed event,
  ) async {
    CalculationModel model = state.calculationModel;

    if (model.result != null) {
      CalculationModel newModel = model.copyWith(
        firstOperand: () => event.number,
        result: () => null
      );

      return CalculationChanged(calculationModel: newModel);
    }

    if (model.firstOperand == null) {
      CalculationModel newModel = model.copyWith(
        firstOperand: () => event.number
      );

      return CalculationChanged(calculationModel: newModel);
    }

    if (model.operator == null) {
      CalculationModel newModel = model.copyWith(
        firstOperand: () => int.parse('${model.firstOperand}${event.number}')
      );

      return CalculationChanged(calculationModel: newModel);
    }

    if (model.secondOperand == null) {
      CalculationModel newModel = model.copyWith(
        secondOperand: () => event.number
      );

      return CalculationChanged(calculationModel: newModel);
    }

    return CalculationChanged(
      calculationModel: model.copyWith(
        secondOperand: () =>  int.parse('${model.secondOperand}${event.number}')
      )
    );
  }

  Future<CalculationState> _mapOperatorPressedToState(
      OperatorPressed event,
      ) async {
    List<String> allowedOperators = ['+', '-', '*', '/'];

    if (!allowedOperators.contains(event.operator)) {
      return state;
    }

    CalculationModel model = state.calculationModel;

    CalculationModel newModel = state.calculationModel.copyWith(
      firstOperand: () => model.firstOperand == null ? 0 : model.firstOperand,
      operator: () => event.operator
    );

    return CalculationChanged(calculationModel: newModel);
  }

  Future<CalculationState> _mapCalculateResultToState(
      CalculateResult event,
    ) async {
    CalculationModel model = state.calculationModel;

    if (model.operator == null || model.secondOperand == null) {
      return state;
    }

    int result = 0;

    switch (model.operator) {
      case '+':
        result = model.firstOperand + model.secondOperand;
        break;
      case '-':
        result = model.firstOperand - model.secondOperand;
        break;
      case '*':
        result = model.firstOperand * model.secondOperand;
        break;
      case '/':
        if (model.secondOperand == 0) {
          CalculationModel resultModel = CalculationInitial().calculationModel.copyWith(
            firstOperand: () => 0
          );

          return CalculationChanged(calculationModel: resultModel);
        }
        result = model.firstOperand ~/ model.secondOperand;
        break;
    }

    CalculationModel newModel = CalculationInitial().calculationModel.copyWith(
      firstOperand: () => result
    );

    return CalculationChanged(calculationModel: newModel);
  }

  @override
  void onChange(Change<CalculationState> change) {
    log(change.currentState.calculationModel.toString());
    log(change.nextState.calculationModel.toString());
    super.onChange(change);
  }
}
