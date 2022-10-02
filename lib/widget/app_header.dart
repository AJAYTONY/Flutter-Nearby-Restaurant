import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String text;

  const AppHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Text(
          text,
          style: const TextStyle(
              fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
