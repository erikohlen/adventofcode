import 'dart:math';

import 'package:flutter/material.dart';

class XmasText extends StatelessWidget {
  const XmasText(
    this.text, {
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...text.toString().split("").map((e) {
          // List of colors with different shades of red, green and blue
          List<Color> colors = [
            Colors.red[100]!,
            Colors.red[200]!,
            Colors.red[300]!,
            Colors.red[400]!,
            Colors.red[500]!,
            Colors.red[600]!,
            Colors.red[700]!,
            Colors.red[800]!,
            Colors.red[900]!,
            Colors.green[100]!,
            Colors.green[200]!,
            Colors.green[300]!,
            Colors.green[400]!,
            Colors.green[500]!,
            Colors.green[600]!,
            Colors.green[700]!,
            Colors.green[800]!,
            Colors.green[900]!,
            Colors.blue[100]!,
            Colors.blue[200]!,
            Colors.blue[300]!,
            Colors.blue[400]!,
            Colors.blue[500]!,
            Colors.blue[600]!,
            Colors.blue[700]!,
            Colors.blue[800]!,
            Colors.blue[900]!,
          ];

          // Generate random number between 0 and 3
          int random = Random().nextInt(colors.length);
          return SelectableText(
            e,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 120, color: colors[random]),
          );
        }).toList(),
      ],
    );
  }
}
