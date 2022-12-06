import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

const day = 6;

class Dec6_2022 extends StatefulWidget {
  const Dec6_2022({super.key});
  @override
  State<Dec6_2022> createState() => _Dec6_2022State();
}

class _Dec6_2022State extends State<Dec6_2022> {
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

    if (sample.length == 0) {
      return Text('loading...');
    }

    //! PART 1
    var sampleLength = sample.length;
    addToOutput(outputs, 'sampleLength', sampleLength);

    bool hasRepeatedChar(String str) {
      var charMap = <String, int>{};
      for (var i = 0; i < str.length; i++) {
        var char = str[i];
        if (charMap.containsKey(char)) {
          return true;
        }
        charMap[char] = 1;
      }
      return false;
    }

    int indexFirstNonRepeated(String sample) {
      var firstNonRepeated = 0;
      for (var i = 0; i < sampleLength && firstNonRepeated == 0; i++) {
        String fourCharSample = sample.substring(i, i + 4);
        if (!hasRepeatedChar(fourCharSample)) {
          firstNonRepeated = i + 1 + 3;
        }
      }
      return firstNonRepeated;
    }

    var firstNonRepeated = indexFirstNonRepeated(sample);
    addToOutput(outputs, 'firstNonRepeated', firstNonRepeated);

    //! PART 2
    int indexFirstNonRepeated14(String sample) {
      var firstNonRepeated = 0;
      for (var i = 0; i < sampleLength && firstNonRepeated == 0; i++) {
        String fourCharSample = sample.substring(i, i + 14);
        if (!hasRepeatedChar(fourCharSample)) {
          firstNonRepeated = i + 1 + 13;
        }
      }
      return firstNonRepeated;
    }

    addToOutput(
        outputs, 'indexFirstNonRepeated14', indexFirstNonRepeated14(sample));

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListView(
        reverse: false,
        children: [
          const Text(
            'Dec 6',
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
