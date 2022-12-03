import 'package:adventofcode/ui_components/spacers.dart';
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
    loadAssetFileAsString("2022_1_input.txt").then((value) {
      setState(() {
        input = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Split the string into lines
    List<String> sampleLines = input.split('\n');
    // Group list of ints into a list of lists of ints, split by empty lines
    List<List<int>> sampleGroups = [];
    List<int> currentGroup = [];
    for (String line in sampleLines) {
      if (line.isEmpty) {
        sampleGroups.add(currentGroup);
        currentGroup = [];
      } else {
        currentGroup.add(int.parse(line));
      }
    }
    // Return list of sums for each group
    List<int> sampleSums = sampleGroups.map((group) {
      return group.reduce((a, b) => a + b);
    }).toList();
    // Sort decending
    sampleSums.sort((a, b) => b.compareTo(a));
    // Sum first 3
    int sampleSum = sampleSums.take(3).reduce((a, b) => a + b);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListView(
        children: [
          const Text('Jan 1, 2022'),
          const SizedBox(
            height: 64,
          ),
          SelectableText('$sampleSum'),
          Text('$sampleSums'),
        ],
      ),
    );
  }
}
