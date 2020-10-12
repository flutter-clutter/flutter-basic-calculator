import 'dart:async';
import 'dart:developer';

import 'package:basic_calculator/calculation_model.dart';
import 'package:basic_calculator/services/calculation_history_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'calculation_state.dart';
import 'calculation_event.dart';

export 'calculation_state.dart';
export 'calculation_event.dart';

class CalculationBloc extends Bloc<CalculationEvent, CalculationState> {
  CalculationBloc({
    @required this.calculationHistoryService
  }) : assert(calculationHistoryService != null), super(CalculationInitial());

  CalculationHistoryService calculationHistoryService;

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
      yield* _mapCalculateResultToState(event);
    }

    if (event is ClearCalculation) {
      CalculationModel resultModel = CalculationInitial().calculationModel.copyWith();

      yield CalculationChanged(
        calculationModel: resultModel,
        history: List.of(state.history)
      );
    }

    if (event is FetchHistory) {
      yield CalculationChanged(
        calculationModel: state.calculationModel,
        history: calculationHistoryService.fetchAllEntries()
      );
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

      return CalculationChanged(
        calculationModel: newModel,
        history: List.of(state.history)
      );
    }

    if (model.firstOperand == null) {
      CalculationModel newModel = model.copyWith(
        firstOperand: () => event.number
      );

      return CalculationChanged(
        calculationModel: newModel,
        history: List.of(state.history)
      );
    }

    if (model.operator == null) {
      CalculationModel newModel = model.copyWith(
        firstOperand: () => int.parse('${model.firstOperand}${event.number}')
      );

      return CalculationChanged(
        calculationModel: newModel,
        history: List.of(state.history)
      );
    }

    if (model.secondOperand == null) {
      CalculationModel newModel = model.copyWith(
        secondOperand: () => event.number
      );

      return CalculationChanged(
        calculationModel: newModel,
        history: List.of(state.history)
      );
    }

    return CalculationChanged(
      calculationModel: model.copyWith(
        secondOperand: () =>  int.parse('${model.secondOperand}${event.number}')
      ),
      history: List.of(state.history)
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

    return CalculationChanged(
      calculationModel: newModel,
      history: List.of(state.history)
    );
  }

  Stream<CalculationState> _mapCalculateResultToState(
      CalculateResult event,
    ) async* {
    CalculationModel model = state.calculationModel;

    if (model.operator == null || model.secondOperand == null) {
      yield state;
      return;
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
          result = 0;
        }
        else {
          result = model.firstOperand ~/ model.secondOperand;
        }
        break;
    }

    CalculationModel newModel = CalculationInitial().calculationModel.copyWith(
      firstOperand: () => result
    );

    yield CalculationChanged(
      calculationModel: newModel,
      history: List.of(state.history)
    );

    yield* _yieldHistoryStorageResult(model, newModel);
  }

  Stream<CalculationChanged> _yieldHistoryStorageResult(CalculationModel model, CalculationModel newModel) async* {
    CalculationModel resultModel = model.copyWith(result: () => newModel.firstOperand);

    if(await calculationHistoryService.addEntry(resultModel)) {
      yield CalculationChanged(
        calculationModel: newModel,
        history: calculationHistoryService.fetchAllEntries()
      );
    }
  }

  @override
  void onChange(Change<CalculationState> change) {
    log(change.currentState.calculationModel.toString());
    log(change.nextState.calculationModel.toString());
    super.onChange(change);
  }
}
