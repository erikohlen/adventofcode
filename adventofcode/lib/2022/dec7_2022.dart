import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

const day = 7;

enum RowType { cdDir, cdDotDot, ls, dir, file }

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

    var rows = sample.split('\n');

    RowType strToType(String str) {
      if (str.startsWith('\$ cd ..')) {
        return RowType.cdDotDot;
      } else if (str.startsWith('\$ cd')) {
        return RowType.cdDir;
      } else if (str.startsWith('\$ ls')) {
        return RowType.ls;
      } else if (str.startsWith('dir')) {
        return RowType.dir;
      } else if (str.startsWith(RegExp(r'[0-9]'))) {
        return RowType.file;
      } else {
        throw Exception('Unknown row type: $str');
      }
    }

    Map<String, int> dirMap = {};
    String currentDir = '/';
    List<String> alreadyAddedFiles = [];
    rows.forEach((element) {
      var type = strToType(element);

      switch (type) {
        case RowType.cdDir:
          if (currentDir == '/') {
            currentDir += element.split(' ')[2];
          } else {
            currentDir += '/${element.split(' ')[2]}';
          }
          break;
        case RowType.cdDotDot:
          if (currentDir != '/') {
            var currentDirParts = currentDir.split('/');
            currentDirParts.removeLast();
            currentDir = currentDirParts.join('/');
          }
          break;
        case RowType.ls:
          break;
        case RowType.dir:
          break;
        case RowType.file:
          String fileName = element.split(' ')[1];
          if (alreadyAddedFiles.contains(currentDir + '/' + fileName)) {
            break;
          }
          int fileSize = int.parse(element.split(' ')[0]);

          dirMap[currentDir] = (dirMap[currentDir] ?? 0) + fileSize;
          var parentDirs = currentDir.split('/');

          for (var i = 0; i < parentDirs.length; i++) {
            var parentDir = parentDirs.sublist(0, i).join('/');
            if (parentDir != '') {
              dirMap[parentDir] = (dirMap[parentDir] ?? 0) + fileSize;
            }
          }

          if (currentDir != '/') {
            dirMap['/'] = (dirMap['/'] ?? 0) + fileSize;
          }
          alreadyAddedFiles.add(currentDir + '/' + fileName);
          break;

        default:
      }
    });

    var sumSizePart1 = 0;
    dirMap.keys.forEach((key) {
      int fileSize = dirMap[key]!;
      if (fileSize <= 100000) {
        sumSizePart1 += fileSize;
      }
    });

    var availableSpace = 70000000 - dirMap['/']!;
    var spaceToDelete = 30000000 - availableSpace;
    addToOutput(outputs, 'Part1: sumSize', sumSizePart1);

    var sortedSizes = dirMap.values.toList();
    sortedSizes.sort();
    var minToDelete =
        sortedSizes.firstWhere((element) => element >= spaceToDelete);
    addToOutput(outputs, 'Part2: minToDelete', minToDelete);

    // Final 3979145
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
