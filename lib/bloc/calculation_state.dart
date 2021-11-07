import 'package:equatable/equatable.dart';

import '../calculation_model.dart';

abstract class CalculationState extends Equatable {
  final CalculationModel calculationModel;
  final List<CalculationModel> history;

  const CalculationState(
      {required this.calculationModel, required this.history});

  @override
  List<Object> get props => [calculationModel, history];
}

class CalculationInitial extends CalculationState {
  CalculationInitial()
      : super(calculationModel: CalculationModel(), history: []);
}

class CalculationChanged extends CalculationState {
  final CalculationModel calculationModel;
  final List<CalculationModel> history;

  const CalculationChanged(
      {required this.calculationModel, required this.history})
      : super(calculationModel: calculationModel, history: history);

  @override
  List<Object> get props => [calculationModel, history];
}
