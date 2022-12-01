import 'package:adventofcode/2021/dec1_2021.dart';
import 'package:flutter/material.dart';

import '2022/1/dec1_2022.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          children: [
            Dec1_2022(),
          ],
        ),
      ),
    );
  }
}
