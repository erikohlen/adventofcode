import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

//! 1 December 2022
class Dec1_2022 extends StatefulWidget {
  const Dec1_2022({super.key});

  @override
  State<Dec1_2022> createState() => _Dec1_2022State();
}

class _Dec1_2022State extends State<Dec1_2022> {
  String sample = "";
  String input = "";

  @override
  void initState() {
    loadAssetFileAsString("2022_1_sample.txt").then((value) {
      setState(() {
        sample = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Split the string into lines.
    List<String> lines = sample.split('\n');
    lines.forEach((element) {
      print(element);
    });

    return Center(
      child: Column(
        children: [
          ...lines.map((e) => SelectableText(e)),
        ],
      ),
    );
  }
}
