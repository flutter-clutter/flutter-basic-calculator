import 'package:equatable/equatable.dart';

class CalculationModel extends Equatable {
  const CalculationModel({
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
    int? firstOperand,
    String? operator,
    int? secondOperand,
    int? result,
  }) {
    return CalculationModel(
      firstOperand: firstOperand ?? this.firstOperand,
      operator: operator ?? this.operator,
      secondOperand: secondOperand ?? this.secondOperand,
      result: result ?? this.result,
    );
  }

  CalculationModel.fromJson(Map<String, dynamic> json)
      : firstOperand = json['firstOperand'] as int?,
        operator = json['operator'] as String?,
        secondOperand = json['secondOperand'] as int?,
        result = json['result'] as int?;

  Map<String, dynamic> toJson() => {
        'firstOperand': firstOperand,
        'operator': operator,
        'secondOperand': secondOperand,
        'result': result,
      };

  @override
  String toString() {
    return '$firstOperand$operator$secondOperand=$result';
  }

  @override
  List<Object?> get props => <Object?>[
        firstOperand,
        operator,
        secondOperand,
        result,
      ];
}
