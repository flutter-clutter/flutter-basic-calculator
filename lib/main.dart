import 'package:basic_calculator/bloc/calculation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculation.dart';
import 'services/calculation_history_service.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    CalculatorApp(
      sharedPreferences: sharedPreferences
    )
  );
}

class CalculatorApp extends StatefulWidget {
  CalculatorApp({
    required this.sharedPreferences
  });

  final SharedPreferences sharedPreferences;

  @override
  _CalculatorAppState createState() => _CalculatorAppState(
  );
}

class _CalculatorAppState extends State<CalculatorApp> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      )
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter basic calculator',
      home: Scaffold(
        body: BlocProvider(
          create: (context) {
            return CalculationBloc(
              calculationHistoryService: CalculationHistoryService(
                sharedPreferences: widget.sharedPreferences
              )
            );
          },
          child: Calculation(),
        ),
      ),
    );
  }
}
