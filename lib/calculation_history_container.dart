import 'package:basic_calculator/calculation_model.dart';
import 'package:flutter/material.dart';

class CalculationHistoryContainer extends StatelessWidget{
  CalculationHistoryContainer({
    @required this.calculations
  });

  final List<CalculationModel> calculations;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            spreadRadius: 2.0,
            color: Colors.black12
          )
        ]
      ),
      child: ListView(
        padding: EdgeInsets.all(12),
        children: [
          for (var model in calculations)
            Text(
              '${model.firstOperand} ${model.operator} ${model.secondOperand} = ${model.result}',
              textAlign: TextAlign.center
            )
        ],
      )
    );
  }
}