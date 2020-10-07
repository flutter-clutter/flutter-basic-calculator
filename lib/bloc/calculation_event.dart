import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CalculationEvent extends Equatable {
  const CalculationEvent();
}

class NumberPressed extends CalculationEvent {
  final int number;

  const NumberPressed({@required this.number}) : assert(number != null);

  @override
  List<Object> get props => [number];
}

class OperatorPressed extends CalculationEvent {
  final String operator;

  const OperatorPressed({@required this.operator}) : assert(operator != null);

  @override
  List<Object> get props => [operator];
}

class CalculateResult extends CalculationEvent {
  @override
  List<Object> get props =>  [];
}

class ClearCalculation extends CalculationEvent {
  @override
  List<Object> get props =>  [];
}
