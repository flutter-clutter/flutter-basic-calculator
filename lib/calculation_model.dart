import 'package:equatable/equatable.dart';

class CalculationModel extends Equatable {
  CalculationModel({
    this.firstOperand,
    this.operator,
    this.secondOperand,
    this.result,
  });

  final int? firstOperand;
  final String? operator;
  final int? secondOperand;
  final int? result;

  CalculationModel copyWith({
      int? Function()? firstOperand,
      String? Function()? operator,
      int? Function()? secondOperand,
      int? Function()? result
    })
  {
    return CalculationModel(
      firstOperand: firstOperand?.call() ?? this.firstOperand,
      operator: operator?.call() ?? this.operator,
      secondOperand: secondOperand?.call() ?? this.secondOperand,
      result: result?.call() ?? this.result,
    );
  }

  CalculationModel.fromJson(Map<String, dynamic> json)
      : firstOperand = json['firstOperand'],
        operator = json['operator'],
        secondOperand = json['secondOperand'],
        result = json['result'];

  Map<String, dynamic> toJson() =>
      {
        'firstOperand': firstOperand,
        'operator': operator,
        'secondOperand': secondOperand,
        'result': result,
      };

  @override
  String toString() {
    return "$firstOperand$operator$secondOperand=$result";
  }

  @override
  List<Object?> get props => [firstOperand, operator, secondOperand, result];
}