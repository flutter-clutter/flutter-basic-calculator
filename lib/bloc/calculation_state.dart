part of 'calculation_bloc.dart';

abstract class CalculationState extends Equatable {
  final CalculationModel calculationModel;

  const CalculationState({@required this.calculationModel}) : assert(calculationModel != null);

  @override
  List<Object> get props => [calculationModel.firstOperand, calculationModel.operator, calculationModel.secondOperand, calculationModel.result];
}

class CalculationInitial extends CalculationState {
  CalculationInitial() : super(calculationModel: CalculationModel());
}

class CalculationSuccess extends CalculationState {
  final CalculationModel calculationModel;

  const CalculationSuccess({@required this.calculationModel})
      : assert(calculationModel != null),
        super(calculationModel: calculationModel);

  @override
  List<Object> get props => [calculationModel.firstOperand, calculationModel.operator, calculationModel.secondOperand, calculationModel.result];
}