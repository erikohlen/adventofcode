import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

const day = 5;

class Dec5_2022 extends StatefulWidget {
  const Dec5_2022({super.key});
  @override
  State<Dec5_2022> createState() => _Dec5_2022State();
}

class _Dec5_2022State extends State<Dec5_2022> {
  String sampleStr = "";
  String inputStr = "";

  @override
  void initState() {
    loadAssetFileAsString("2022_${day}_sample.txt").then((value) {
      setState(() {
        sampleStr = value;
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
    var sample = sampleStr;
    var outputs = <String>[];
    void addToOutput(List<String> list, String varName, dynamic val) {
      list.add('$varName: $val');
    }

    // Get sample but only include row 1 to 9
    var sampleRows = sample.split('\n');

    // Number of stacks
    var bottomRowIndex = 7; // Add this manually by looking at input
    var widthMax = sampleRows[bottomRowIndex].length;
    var numStack = (widthMax + 1) / 4;
    addToOutput(outputs, 'numStack', numStack);

    // Create list of letters for each stack
    var heightRangeStart = 0;
    var heightRangeEnd = bottomRowIndex;
    var heightRange = heightRangeEnd - heightRangeStart + 1;
    addToOutput(outputs, 'heightRange', heightRange);

    var startColumn = 0;
    var stacks = [];
    for (var i = 0; i < numStack; i++) {
      List<String> _stack = [];
      for (var j = 0; j < heightRange; j++) {
        var row = sampleRows[j];
        var letter = row[startColumn + 1];
        _stack.add(letter);
      }
      stacks.add(_stack);

      startColumn += 4;
    }
    // Remove empty strings from stacks
    stacks.forEach((element) {
      element.removeWhere((element) => element == ' ');
    });

    stacks.forEach((element) {
      addToOutput(outputs, 'stack', element);
    });

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
