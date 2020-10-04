import 'package:equatable/equatable.dart';

class CalculationModel extends Equatable {
  CalculationModel({
    this.firstOperand,
    this.operator,
    this.secondOperand,
    this.result = 0,
  });

  final int firstOperand;
  final String operator;
  final int secondOperand;
  final int result;

  @override
  String toString() {
    return "$firstOperand$operator$secondOperand=$result";
  }

  @override
  List<Object> get props => [firstOperand, operator, secondOperand, result];
}