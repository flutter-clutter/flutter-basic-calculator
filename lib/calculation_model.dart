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

  CalculationModel copyWith(
      {int? firstOperand, String? operator, int? secondOperand, int? result}) {
    return CalculationModel(
      firstOperand: firstOperand ?? this.firstOperand,
      operator: operator ?? this.operator,
      secondOperand: secondOperand ?? this.secondOperand,
      result: result ?? this.result,
    );
  }

  CalculationModel.fromJson(Map<String, dynamic> json)
      : firstOperand = json['firstOperand'],
        operator = json['operator'],
        secondOperand = json['secondOperand'],
        result = json['result'];

  Map<String, dynamic> toJson() => {
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
  List<Object?> get props => <Object?>[
        firstOperand,
        operator,
        secondOperand,
        result,
      ];
}
