import 'dart:io';
import 'dart:math';
import 'package:adventofcode/utils/load_utils.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

enum Direction { TopDown, BottomUp, LeftRight, RightLeft }

const day = 8;

class Tree {
  Tree({
    required this.x,
    required this.y,
    required this.isOuter,
    this.treeHeight = 0,
    this.isVisible = false,
  });
  int x;
  int y;
  int treeHeight;
  bool isOuter;
  bool isVisible;
  int top = 0;
  int down = 0;
  int left = 0;
  int right = 0;
  int get totalView => top * down * left * right;
}

class Dec8_2022 extends StatefulWidget {
  const Dec8_2022({super.key});
  @override
  State<Dec8_2022> createState() => _Dec8_2022State();
}

class _Dec8_2022State extends State<Dec8_2022> {
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
    var input = inputStr;
    var outputs = <String>[];
    void addToOutput(List<String> list, String varName, dynamic val) {
      list.add('$varName $val');
    }

    var rows = input.split('\n');
    var gridHeight = rows.length;
    var gridWidth = rows[0].length;
    var cols = List.generate(gridWidth, (index) => '');

    for (var row in rows) {
      for (var i = 0; i < row.length; i++) {
        cols[i] += row[i];
      }
    }

    List<Tree> trees = [];
    // Add trees
    for (var i = 0; i < rows.length; i++) {
      for (var j = 0; j < cols.length; j++) {
        bool isOuter =
            i == 0 || j == 0 || i == rows.length - 1 || j == cols.length - 1;
        trees.add(Tree(x: j, y: i, isOuter: isOuter, isVisible: isOuter));
      }
    }

    List<int> strToListInts(String str) {
      return str.split('').map((e) => int.parse(e)).toList();
    }

    //! PART 1
    void traverseTreeGrid() {
      // ROWS
      for (var iy = 0; iy < gridHeight; iy++) {
        var row = rows[iy];
        var rowInts = strToListInts(row);
        var treeRow = [];
        for (var ix = 0; ix < gridWidth; ix++) {
          var tree =
              trees.firstWhere((element) => element.x == ix && element.y == iy);
          // Get previous ints in _rowInts to sublist
          List<int> subList = rowInts.sublist(0, ix);
          // Check if all of previous ints is lower than current
          bool allPrevTreeeisLower =
              subList.where((element) => element < rowInts[ix]).length ==
                  subList.length;

          if (allPrevTreeeisLower) {
            tree.isVisible = true;
          }
          treeRow[iy].add(tree);
        }
        // Reverse row
        rowInts = rowInts.reversed.toList();
        for (var ix = 0; ix < gridWidth; ix++) {
          var revX = gridWidth - ix - 1;
          var tree = trees
              .firstWhere((element) => element.x == revX && element.y == iy);
          // Get previous ints in _rowInts to sublist
          List<int> subList = rowInts.sublist(0, ix);
          // Check if all of previous ints is lower than current
          bool allPrevTreeeisLower =
              subList.where((element) => element < rowInts[ix]).length ==
                  subList.length;

          if (allPrevTreeeisLower) {
            tree.isVisible = true;
          }
        }
      }
      // COLS
      for (var ix = 0; ix < gridWidth; ix++) {
        var col = cols[ix];
        var colInts = strToListInts(col);
        for (var iy = 0; iy < gridHeight; iy++) {
          var tree =
              trees.firstWhere((element) => element.x == ix && element.y == iy);
          // Get previous ints in _rowInts to sublist
          List<int> subList = colInts.sublist(0, iy);
          // Check if all of previous ints is lower than current
          bool allPrevTreeeisLower =
              subList.where((element) => element < colInts[iy]).length ==
                  subList.length;

          if (allPrevTreeeisLower) {
            tree.isVisible = true;
          }
        }
        // Reverse row
        colInts = colInts.reversed.toList();

        for (var iy = 0; iy < gridHeight; iy++) {
          var revY = gridHeight - iy - 1;
          var tree = trees
              .firstWhere((element) => element.x == ix && element.y == revY);
          // Get previous ints in _rowInts to sublist
          List<int> subList = colInts.sublist(0, iy);
          // Check if any of previous ints is lower than current
          bool allPrevTreeeisLower =
              subList.where((element) => element < colInts[iy]).length ==
                  subList.length;
          if (allPrevTreeeisLower) {
            tree.isVisible = true;
          }
        }
      }
    }

    // traverseTreeGrid();

    //! PART 2
    List<List<Tree>> treeGrid = [];
    void getMaxScenic() {
      // TREE BY TREE
      for (var iy = 0; iy < gridHeight; iy++) {
        treeGrid.add([]);
        for (var ix = 0; ix < gridWidth; ix++) {
          int iTreeHeight = int.parse(rows[iy][ix]);
          var tree =
              trees.firstWhere((element) => element.x == ix && element.y == iy);
          tree.treeHeight = iTreeHeight;
          // Check top
          var topCol = strToListInts(cols[ix]).sublist(0, iy);
          topCol = topCol.reversed.toList();
          var topViewIndex =
              topCol.indexWhere((element) => element >= iTreeHeight);
          tree.top = topViewIndex == -1 ? topCol.length : topViewIndex + 1;

          // Check down
          var downCol = strToListInts(cols[ix]).sublist(iy + 1, gridHeight);
          var downViewIndex =
              downCol.indexWhere((element) => element >= iTreeHeight);
          tree.down = downViewIndex == -1 ? downCol.length : downViewIndex + 1;
          // Check left
          var leftRow = strToListInts(rows[iy]).sublist(0, ix);
          leftRow = leftRow.reversed.toList();
          var leftViewIndex =
              leftRow.indexWhere((element) => element >= iTreeHeight);
          tree.left = leftViewIndex == -1 ? leftRow.length : leftViewIndex + 1;

          // Check right

          var rightRow = strToListInts(rows[iy]).sublist(ix + 1, gridWidth);
          var rightViewIndex =
              rightRow.indexWhere((element) => element >= iTreeHeight);
          tree.right =
              rightViewIndex == -1 ? rightRow.length : rightViewIndex + 1;
          treeGrid[iy].add(tree);
        }
      }
    }

    getMaxScenic();

    //traverseTreeGrid();
    addToOutput(outputs, 'width', gridWidth);
    addToOutput(outputs, 'height', gridHeight);

    // Count visible trees
    int visibleTrees = trees.where((element) => element.isVisible).length;
    addToOutput(outputs, 'visibleTrees', visibleTrees);

    // Find max view among trees
    int maxTotalView = trees.map((Tree e) => e.totalView).toList().reduce(max);
    addToOutput(outputs, 'maxTotalView', maxTotalView);

    // OUTPUT TO CSV

    List<List<int>> treeGridInts =
        treeGrid.map((e) => e.map((e) => e.treeHeight).toList()).toList();
    String csv = const ListToCsvConverter().convert(treeGridInts);

    void _saveCSV() async {
      await Clipboard.setData(ClipboardData(text: csv));
      /* final directory = await getApplicationDocumentsDirectory();
      final pathOfTheFileToWrite = directory.path + "/myCsvFile.csv";
      File file = await File(pathOfTheFileToWrite);
      file.writeAsString(csv); */
    }

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListView(
        reverse: false,
        children: [
          const Text(
            'Dec 8',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            '🎄',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
          OutlinedButton(onPressed: _saveCSV, child: Text('Save CSV')),
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
