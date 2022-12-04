import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

const day = 4;

class Dec4_2022 extends StatefulWidget {
  const Dec4_2022({super.key});
  @override
  State<Dec4_2022> createState() => _Dec4_2022State();
}

class _Dec4_2022State extends State<Dec4_2022> {
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
    List<int> numbersFromRangeString(String range) {
      var split = range.split('-');
      var start = int.parse(split[0]);
      var end = int.parse(split[1]);
      return List<int>.generate(end - start + 1, (index) => start + index);
    }

    addToOutput(
        outputs, 'numbersFromRangeString', numbersFromRangeString('1-5'));

    bool isContained(List<int> list1, List<int> list2) {
      return list1.every((element) => list2.contains(element)) ||
          list2.every((element) => list1.contains(element));
    }

    var sampleAsNumbers = sample2
        .map((e) => e.map((e) => numbersFromRangeString(e)).toList())
        .toList();

    var containedRanges =
        sampleAsNumbers.map((e) => isContained(e[0], e[1])).toList();
    var containedRangesNum = containedRanges.where((e) => e).length;
    addToOutput(outputs, 'containedRangesNum', containedRangesNum);

    //! PART 2
    bool isOverlap(List<int> list1, List<int> list2) {
      return list1.any((element) => list2.contains(element));
    }

    var overlappedRanges =
        sampleAsNumbers.map((e) => isOverlap(e[0], e[1])).toList();
    // addToOutput(outputs, 'overlapedRanges', overlapedRanges);
    var overlapedRangesNum = overlappedRanges.where((e) => e).length;
    addToOutput(outputs, 'overlappedRangesNum', overlapedRangesNum);

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
