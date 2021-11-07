import 'package:equatable/equatable.dart';

abstract class CalculationEvent extends Equatable {
  const CalculationEvent();
}

class NumberPressed extends CalculationEvent {
  final int number;

  const NumberPressed({required this.number});

  @override
  List<Object> get props => [number];
}

class OperatorPressed extends CalculationEvent {
  final String operator;

  const OperatorPressed({required this.operator});

  @override
  List<Object> get props => [operator];
}

class CalculateResult extends CalculationEvent {
  @override
  List<Object> get props => [];
}

class ClearCalculation extends CalculationEvent {
  @override
  List<Object> get props => [];
}

class FetchHistory extends CalculationEvent {
  @override
  List<Object> get props => [];
}
