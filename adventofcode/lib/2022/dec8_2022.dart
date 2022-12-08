import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

const day = 8;

class Tree {
  Tree({
    required this.x,
    required this.y,
    required this.isOuter,
    this.isVisible = false,
  });
  int x;
  int y;
  bool isOuter;
  bool isVisible;
  int top = 0;
  int down = 0;
  int left = 0;
  int right = 0;
}

enum Direction { TopDown, BottomUp, LeftRight, RightLeft }

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

/* 
30373
25512
65332
33549
35390 
*/

  @override
  Widget build(BuildContext context) {
    var sample = sampleStr;
    var input = inputStr;
    var outputs = <String>[];
    void addToOutput(List<String> list, String varName, dynamic val) {
      list.add('$varName $val');
    }

    var rows = sample.split('\n');
    var gridHeight = rows.length;
    var gridWidth = rows[0].length;
    var cols = List.generate(gridWidth, (index) => '');

    for (var row in rows) {
      for (var i = 0; i < row.length; i++) {
        cols[i] += row[i];
      }
    }

    //addToOutput(outputs, 'rows', rows);
    //addToOutput(outputs, 'cols', cols);

    List<Tree> trees = [];
    // Add trees
    for (var i = 0; i < rows.length; i++) {
      for (var j = 0; j < cols.length; j++) {
        bool isOuter =
            i == 0 || j == 0 || i == rows.length - 1 || j == cols.length - 1;
        trees.add(Tree(x: j, y: i, isOuter: isOuter, isVisible: isOuter));
      }
    }
    // Print trees orgs
    trees.forEach((element) {
      var x = element.x;
      var y = element.y;
      ////addToOutput(outputs, 'x', x);
      //addToOutput(outputs, 'y', y);
    });

    List<int> strToListInts(String str) {
      return str.split('').map((e) => int.parse(e)).toList();
    }

    //! PART 1
    // Traverse rows/cols and set set visible to true
    var maxScenic = 0;

    List<List<Tree>> _treeGrid = [];
    void getMaxScenic() {
      // TREE BY TREE
      for (var iy = 0; iy < gridHeight; iy++) {
        _treeGrid.add([]);
        for (var ix = 0; ix < gridWidth; ix++) {
          int iTreeHeight = int.parse(rows[iy][ix]);
          var tree =
              trees.firstWhere((element) => element.x == ix && element.y == iy);

          // Check top
          var topCol = strToListInts(cols[ix]).sublist(0, iy);
          topCol = topCol.reversed.toList();
          var numTreesView =
              topCol.indexWhere((element) => element >= iTreeHeight);
          tree.top = numTreesView == -1 ? topCol.length : numTreesView;
          // Check right
          // Check down
          // Check left

          _treeGrid[iy].add(tree);
        }
      }
    }

    getMaxScenic();

    void traverseTreeGrid() {
      // ROWS
      for (var iy = 0; iy < gridHeight; iy++) {
        var row = rows[iy];
        var _rowInts = strToListInts(row);
        var _treeRow = [];
        for (var ix = 0; ix < gridWidth; ix++) {
          var tree =
              trees.firstWhere((element) => element.x == ix && element.y == iy);
          // Get previous ints in _rowInts to sublist
          List<int> _subList = _rowInts.sublist(0, ix);
          // Check if all of previous ints is lower than current
          bool _allPrevTreeeisLower =
              _subList.where((element) => element < _rowInts[ix]).length ==
                  _subList.length;

          if (_allPrevTreeeisLower) {
            tree.isVisible = true;
          }
          _treeRow[iy].add(tree);
        }
        // Reverse row
        _rowInts = _rowInts.reversed.toList();
        for (var ix = 0; ix < gridWidth; ix++) {
          var revX = gridWidth - ix - 1;
          var tree = trees
              .firstWhere((element) => element.x == revX && element.y == iy);
          // Get previous ints in _rowInts to sublist
          List<int> _subList = _rowInts.sublist(0, ix);
          // Check if all of previous ints is lower than current
          bool _allPrevTreeeisLower =
              _subList.where((element) => element < _rowInts[ix]).length ==
                  _subList.length;

          if (_allPrevTreeeisLower) {
            tree.isVisible = true;
          }
        }
      }
      // COLS
      for (var ix = 0; ix < gridWidth; ix++) {
        var col = cols[ix];
        var _colInts = strToListInts(col);
        for (var iy = 0; iy < gridHeight; iy++) {
          var tree =
              trees.firstWhere((element) => element.x == ix && element.y == iy);
          // Get previous ints in _rowInts to sublist
          List<int> _subList = _colInts.sublist(0, iy);
          // Check if all of previous ints is lower than current
          bool _allPrevTreeeisLower =
              _subList.where((element) => element < _colInts[iy]).length ==
                  _subList.length;

          if (_allPrevTreeeisLower) {
            tree.isVisible = true;
          }
        }
        // Reverse row
        _colInts = _colInts.reversed.toList();

        for (var iy = 0; iy < gridHeight; iy++) {
          var revY = gridHeight - iy - 1;
          var tree = trees
              .firstWhere((element) => element.x == ix && element.y == revY);
          // Get previous ints in _rowInts to sublist
          List<int> _subList = _colInts.sublist(0, iy);
          // Check if any of previous ints is lower than current
          bool _allPrevTreeeisLower =
              _subList.where((element) => element < _colInts[iy]).length ==
                  _subList.length;
          if (_allPrevTreeeisLower) {
            tree.isVisible = true;
          }
        }
      }
    }

    //! PART 2

    //traverseTreeGrid();
    addToOutput(outputs, 'width', gridWidth);
    addToOutput(outputs, 'height', gridHeight);
/* 

    
 */
    // Display grid
    _treeGrid.forEach((row) {
      addToOutput(outputs, '', [...row.map((Tree e) => '${e.top}')]);
    });

    // Count visible trees
    int visibleTrees = trees.where((element) => element.isVisible).length;

    addToOutput(outputs, 'visibleTrees', visibleTrees);

    // First guess - 1792 is too high. But right for someone else

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
