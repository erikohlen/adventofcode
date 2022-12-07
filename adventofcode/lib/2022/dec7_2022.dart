import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

const day = 7;

class Dec7_2022 extends StatefulWidget {
  const Dec7_2022({super.key});
  @override
  State<Dec7_2022> createState() => _Dec7_2022State();
}

class _Dec7_2022State extends State<Dec7_2022> {
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
    var sample = inputStr;
    var outputs = <String>[];
    void addToOutput(List<String> list, String varName, dynamic val) {
      list.add('$varName: $val');
    }

    if (sample.length == 0) {
      return Text('loading...');
    }

    //! PARSING
    var lines = sample.split('\n');

    var dirs = sample.split('\$ ls');

    // Sum size of current folder
    int sizeOfCurrentFolder(String e) {
      var lines = e.split('\n');
      var sum = 0;
      lines.forEach((element) {
        // If string contains a number
        if (RegExp(r'\d').hasMatch(element)) {
          var size = int.parse(element.split(' ')[0]);
          sum += size;
        }
      });

      return sum;
    }

    dirs.forEach((element) {
      addToOutput(outputs, 'element', element);
      addToOutput(outputs, 'size', sizeOfCurrentFolder(element));
    });

    /*  var sumsPerDir = dirs.map((e) {
      var lines = e.split('\n');
      var sum = 0;
      lines.forEach((element) {
        // If string contains a number
        if (RegExp(r'\d').hasMatch(element)) {
          var size = int.parse(element.split(' ')[0]);
          sum += size;
        }
      });

      return sum;
    }); */

    // Filter sumsPerDir to only include numbers of max 100000
    //sumsPerDir = sumsPerDir.where((element) => element <= 100000);
    //var sumUpto100000 = sumsPerDir.reduce((value, element) => value + element);
    // addToOutput(outputs, 'sumsPerDir', sumUpto100000);

    /*  sumsPerDir.forEach((element) {
      addToOutput(outputs, 'sum: ', element);
    }); */
    /* 
    - / (dir)
      - a (dir)
        - e (dir)
          - i (file, size=584)
          - f (file, size=29116)
          - g (file, size=2557)
          - h.lst (file, size=62596)
    - b.txt (file, size=14848514)
    - c.dat (file, size=8504156)
    - d (dir)
      - j (file, size=4060174)
      - d.log (file, size=8033020)
      - d.ext (file, size=5626152)
      - k (file, size=7214296) 
    */

    //! PART 1

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListView(
        reverse: false,
        children: [
          const Text(
            'Dec 7',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            '🗂',
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
