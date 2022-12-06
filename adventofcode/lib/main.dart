import 'dart:io';

import 'package:adventofcode/2021/dec1_2021.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '2022/dec1_2022.dart';
import '2022/dec2_2022.dart';
import '2022/dec3_2022.dart';
import '2022/dec4_2022.dart';
import '2022/dec5_2022.dart';
import '2022/dec6_2022.dart';

void main() {
  runApp(const MyApp());
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);
  if (Platform.isMacOS) {
    return baseTheme;
  }
  return baseTheme.copyWith(
    textTheme: GoogleFonts.mountainsOfChristmasTextTheme(baseTheme.textTheme),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: _buildTheme(Brightness.dark),
      home: Scaffold(
        //backgroundColor: Colors.black54,
        body: PageView(
          children: const [
            Dec6_2022(),
            Dec5_2022(),
            Dec4_2022(),
            Dec3_2022(),
            Dec2_2022(),
            Dec1_2022(),
          ],
        ),
      ),
    );
  }
}
