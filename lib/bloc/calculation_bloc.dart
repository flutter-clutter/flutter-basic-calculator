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
      model.result = null;
      model.firstOperand = event.number;

      return CalculationSuccess(
        calculationModel: model
      );
    }
    
    if (model.firstOperand == null) {
      model.firstOperand = event.number;

      return CalculationSuccess(
        calculationModel: model
      );
    }
    
    if (model.operator == null) {
      model.firstOperand = int.parse('${state.calculationModel.firstOperand}${event.number}');

      return CalculationSuccess(
        calculationModel: model
      );
    }
    
    if (model.secondOperand == null) {
      model.secondOperand = event.number;

      return CalculationSuccess(
        calculationModel: model
      );
    }

    model.secondOperand = int.parse('${state.calculationModel.secondOperand}${event.number}');

    return CalculationSuccess(
      calculationModel: model
    );
  }

  Future<CalculationState> _mapOperatorPressedToState(
    OperatorPressed event,
  ) async {
    CalculationModel model = state.calculationModel;
    model.firstOperand = state.calculationModel.firstOperand == null ? 0 : null;
    model.operator = event.operator;

    return CalculationSuccess(
      calculationModel: model
    );
  }

  Future<CalculationState> _mapCalculateResultToState(
      CalculateResult event,
      ) async {
    if (state.calculationModel.operator == null || state.calculationModel.secondOperand == null) {
      return state;
    }

    CalculationModel model = state.calculationModel;
    int result = state.calculationModel.result;

    switch (state.calculationModel.operator) {
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

    model.result = result;

    return CalculationSuccess(
      calculationModel: model
    );
  }

  @override
  void onTransition(Transition<CalculationEvent, CalculationState> transition) {
    log(transition.currentState.calculationModel.toString());
    log(transition.nextState.calculationModel.toString());
    super.onTransition(transition);
  }

  @override
  void onChange(Change<CalculationState> change) {
    log(change.currentState.calculationModel.toString());
    log(change.nextState.calculationModel.toString());
    super.onChange(change);
  }
}
