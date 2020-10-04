import 'dart:async';
import 'dart:developer';

import 'package:basic_calculator/calculation_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'calculation_event.dart';
part 'calculation_state.dart';

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
      CalculationModel newModel = CalculationModel(
        firstOperand: event.number,
        operator: model.operator,
        secondOperand: model.secondOperand,
        result: null
      );

      return CalculationChanged(
          calculationModel: newModel
      );
    }

    if (model.firstOperand == null) {
      CalculationModel newModel = CalculationModel(
        firstOperand: event.number,
        operator: model.operator,
        secondOperand: model.secondOperand,
        result: model.result
      );

      return CalculationChanged(
        calculationModel: newModel
      );
    }

    if (model.operator == null) {
      CalculationModel newModel = CalculationModel(
        firstOperand: int.parse('${model.firstOperand}${event.number}'),
        operator: model.operator,
        secondOperand: model.secondOperand,
        result: model.result
      );

      return CalculationChanged(
        calculationModel: newModel
      );
    }

    if (model.secondOperand == null) {
      CalculationModel newModel = CalculationModel(
        firstOperand: model.firstOperand,
        operator: model.operator,
        secondOperand: event.number,
        result: model.result
      );

      return CalculationChanged(
          calculationModel: newModel
      );
    }

    return CalculationChanged(
      calculationModel: CalculationModel(
        firstOperand: model.firstOperand,
        operator: model.operator,
        secondOperand: int.parse('${model.secondOperand}${event.number}'),
        result: model.result
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

    return CalculationChanged(
      calculationModel: CalculationModel(
        firstOperand: model.firstOperand == null ? 0 : model.firstOperand,
        operator: event.operator,
        secondOperand: model.secondOperand,
        result: model.result
      )
    );
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
          return state;
        }
        result = model.firstOperand ~/ model.secondOperand;
        break;
    }

    return CalculationChanged(
      calculationModel: CalculationModel(
        firstOperand: result,
        operator: null,
        secondOperand: null,
        result: null
      )
    );
  }

  @override
  void onChange(Change<CalculationState> change) {
    log(change.currentState.calculationModel.toString());
    log(change.nextState.calculationModel.toString());
    super.onChange(change);
  }
}
