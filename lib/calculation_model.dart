class CalculationModel {
  CalculationModel({
    this.firstOperand,
    this.operator,
    this.secondOperand,
    this.result = 0,
  });

  int firstOperand;
  String operator;
  int secondOperand;
  int result;

  @override
  String toString() {
    return "$firstOperand$operator$secondOperand=$result";
  }
}