import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

const day = 4;

class Dec5_2022 extends StatefulWidget {
  const Dec5_2022({super.key});
  @override
  State<Dec5_2022> createState() => _Dec5_2022State();
}

class _Dec5_2022State extends State<Dec5_2022> {
  String sampleStr = "";
  String sample2Str = "";
  String inputStr = "";

  @override
  void initState() {
    loadAssetFileAsString("2022_${day}_sample.txt").then((value) {
      setState(() {
        sampleStr = value;
      });
    });
    loadAssetFileAsString("2022_${day}_sample2.txt").then((value) {
      setState(() {
        sample2Str = value;
      });
    });
    loadAssetFileAsString("2022_${day}_input.txt").then((value) {
      setState(() {
        inputStr = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sample = inputStr.split('\n').map((e) => e.split('\n')).toList();
    var outputs = <String>[];
    void addToOutput(List<String> list, String varName, dynamic val) {
      list.add('$varName: $val');
    }

    var sample2 = sample.map((e) => e[0].split(',')).toList();

    //! PART 1

    //! PART 2

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListView(
        reverse: false,
        children: [
          const Text(
            'Dec 4',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            '🧹',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
          const SizedBox(
            height: 64,
          ),
          ...outputs.map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(e),
              )),
        ],
      ),
    );
  }
}
