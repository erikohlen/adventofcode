import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

/* 
Each rucksack two large coparments
All items of gi
 */

class Dec3_2022 extends StatefulWidget {
  const Dec3_2022({super.key});
  @override
  State<Dec3_2022> createState() => _Dec3_2022State();
}

class _Dec3_2022State extends State<Dec3_2022> {
  String sampleStr = "";
  String sample2Str = "";
  String inputStr = "";

  @override
  void initState() {
    loadAssetFileAsString("2022_3_sample.txt").then((value) {
      setState(() {
        sampleStr = value;
      });
    });
    loadAssetFileAsString("2022_3_sample2.txt").then((value) {
      setState(() {
        sample2Str = value;
      });
    });
    loadAssetFileAsString("2022_3_input.txt").then((value) {
      setState(() {
        inputStr = value;
        print('input loaded');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sample = sampleStr.split('\n');
    var sample2 = sample2Str.split('\n');
    var input = inputStr.split('\n');
    var outputs = <String>[];
    void addToOutput(List<String> list, String varName, dynamic val) {
      list.add('$varName: $val');
    }

    sample = input;

    addToOutput(outputs, 'first item in txt', sample[0]);

    //! PART 1
    //! Find repeating characters
    // Split a string in a first and second part. Then return character that exists in both parts
    String findRepeatingChar(String str) {
      var first = str.substring(0, str.length ~/ 2);
      var second = str.substring(str.length ~/ 2);
      // Find character that exists in both parts
      for (var i = 0; i < first.length; i++) {
        if (second.contains(first[i])) {
          return first[i];
        }
      }
      return '@';
    }

    addToOutput(outputs, 'test findRepeatingChar',
        findRepeatingChar('vJrwpWtwJgWrhcsFMMfFFhFp'));
    addToOutput(outputs, 'repeating char for each item',
        sample.map((e) => findRepeatingChar(e)));

    //! Get points
    // Get value 1-52 from a-z or A-Z where a=1, b=2, ..., z=26, A=27, B=28, ..., Z=52
    int getVal(String s) {
      var val = s.codeUnitAt(0);
      if (val >= 97) {
        return val - 96;
      } else {
        return val - 38;
      }
    }

    addToOutput(outputs, 'values each item', sample.map((e) {
      return getVal(findRepeatingChar(e));
    }));

    addToOutput(
        outputs,
        'total score',
        sample.map((e) {
          return getVal(findRepeatingChar(e));
        }).reduce((value, element) => value + element));

    // Sum list of values
    int sumList(List<int> list) {
      var sum = 0;
      for (var i = 0; i < list.length; i++) {
        sum += list[i];
      }
      return sum;
    }

    //! PART 2
    // Group items in groups of 3
    List<List<String>> groupItems(List<String> list) {
      var groups = <List<String>>[];
      for (var i = 0; i < list.length; i += 3) {
        groups.add(list.sublist(i, i + 3));
      }
      return groups;
    }

    var sampleBy3 = groupItems(sample);

    addToOutput(outputs, 'sampleBy3', sampleBy3);

    // Find repeating character in each group
    List<String> findRepeatingCharInGroup(List<List<String>> list) {
      var repeatingChars = <String>[];
      for (var i = 0; i < list.length; i++) {
        var group = list[i];
        var first = group[0];
        var second = group[1];
        var third = group[2];
        for (var j = 0; j < first.length; j++) {
          if (second.contains(first[j]) && third.contains(first[j])) {
            repeatingChars.add(first[j]);
            break;
          }
        }
      }
      return repeatingChars;
    }

    addToOutput(outputs, 'repeatingBy3', findRepeatingCharInGroup(sampleBy3));

    // Get values for each group
    addToOutput(outputs, 'repeatingBy3',
        findRepeatingCharInGroup(sampleBy3).map((e) => getVal(e)).toList());

    // Get total score
    addToOutput(
        outputs,
        'total score by 3',
        sumList(findRepeatingCharInGroup(sampleBy3)
            .map((e) => getVal(e))
            .toList()));

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListView(
        reverse: true,
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
            '💰',
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
