import 'package:flutter/material.dart';

class ResultDisplay extends StatelessWidget {
  const ResultDisplay({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      color: Colors.black,
      child: Container(
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.only(right: 24, bottom: 24),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 34),
        ),
      ),
    );
  }
}
