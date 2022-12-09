import 'dart:math';
import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

class Pos {
  Pos({
    required this.x,
    required this.y,
  });
  int x;
  int y;
}

class Head {
  Pos current;

  Head({
    required this.current,
  });
}

class Tail {
  Pos current;
  List<Pos> posHistory = [];
  List<Pos> posHistoryUnique = [];
  int get uniqueCount => posHistoryUnique.length;

  Tail({
    required this.current,
  });
}

class MoveCmd {
  late String direction;
  late int distance;

  MoveCmd(
    this.direction,
    this.distance,
  ) : assert(direction == 'R' ||
            direction == 'L' ||
            direction == 'U' ||
            direction == 'D');
}

class Board {
  Head h;
  Tail t;
  List<MoveCmd> moveHistory = [];
  Board({
    required this.h,
    required this.t,
  });

  void moveHead(MoveCmd move) {
    switch (move.direction) {
      case 'R':
        h.current.x += move.distance;
        break;
      case 'L':
        h.current.x -= move.distance;
        break;
      case 'U':
        h.current.y += move.distance;
        break;
      case 'D':
        h.current.y -= move.distance;
        break;
    }
    moveTailMaybe();
    // Add to history
    moveHistory.add(move);
  }

  void moveTailMaybe() {
    // Check distance to head

    var hX = h.current.x;
    var hY = h.current.y;
    var tX = t.current.x;
    var tY = t.current.y;

    // Distance in grid
    var distX = (hX - tX).abs();
    var distY = (hY - tY).abs();
    var dist = distX + distY;
    print('distX $distX distY $distY dist $dist');

    // If distance is more than 1, move tail like end of rope
  }
}

const day = 9;

class Dec9_2022 extends StatefulWidget {
  const Dec9_2022({super.key});
  @override
  State<Dec9_2022> createState() => _Dec9_2022State();
}

class _Dec9_2022State extends State<Dec9_2022> {
  String sampleStr = "";
  String inputStr = "";
  List<String> moveCmdStrs = [];
  List<MoveCmd> moves = [];

  @override
  void initState() {
    loadAssetFileAsString("2022_${day}_sample.txt").then((value) {
      setState(() {
        sampleStr = value;
        moveCmdStrs = sampleStr.split('\n');
        moves = moveCmdStrs.map((e) {
          var parts = e.split(' ');
          return MoveCmd(parts[0], int.parse(parts[1]));
        }).toList();
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
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2


......
......
......
......
H.....     (H covers T, s)

 */

  void handleMove(MoveCmd cmd, Board board) {
    if (cmd.distance > 1) {
      for (var i = 0; i < cmd.distance; i++) {
        MoveCmd _oneStepMove = MoveCmd(cmd.direction, 1);
        board.moveHead(_oneStepMove);
      }
    } else {
      board.moveHead(cmd);
    }
  }

  int _moveIndex = -1;
  void nextMove() {
    _moveIndex++;
  }

  @override
  Widget build(BuildContext context) {
    var sample = sampleStr;
    var input = inputStr;
    var outputs = <String>[];
    void addToOutput(List<String> list, String varName, dynamic val) {
      list.add('$varName $val');
    }

    if (sample.isEmpty) {
      return const Text('No input');
    }

    /* var moves = moveCmdStrs.map((e) {
      var parts = e.split(' ');
      return MoveCmd(parts[0], int.parse(parts[1]));
    }).toList(); */

    var board = Board(
      h: Head(current: Pos(x: 0, y: 0)),
      t: Tail(current: Pos(x: 0, y: 0)),
    );

    /*   for (var move in moves) {
      if (move.distance > 1) {
        for (var i = 0; i < move.distance; i++) {
          MoveCmd _oneStepMove = MoveCmd(move.direction, 1);
          board.moveHead(_oneStepMove);
        }
      } else {
        board.moveHead(move);
      }
    } */

    // outputs
    board.moveHistory.forEach((element) {
      addToOutput(outputs, 'Movehistory of board:',
          '${element.direction} ${element.distance}');
    });

    outputs.add('Unique positions in trail: ${board.t.uniqueCount}');

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListView(
        children: [
          const Text(
            'Dec $day',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            '🪢',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
          const SizedBox(
            height: 64,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                nextMove();
                handleMove(moves[_moveIndex], board);
              });
            },
            child: const Text('Next move'),
          ),
          ...outputs.map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(e),
              )),
          const SizedBox(
            height: 32,
          ),
          VisualBoard(),
        ],
      ),
    );
  }
}

class VisualBoard extends StatelessWidget {
  const VisualBoard({super.key});

  @override
  Widget build(BuildContext context) {
    double boxSize = 16;
    int gridWidth = 50;
    int gridHeight = gridWidth;
    int boxCount = gridWidth * gridHeight;
    return Stack(children: [
      GridView.count(
        crossAxisCount: gridWidth,
        shrinkWrap: true,
        children: List.generate(boxCount, (index) {
          return GridBox(
              size: boxSize, x: index % gridWidth, y: index ~/ gridWidth);
        }),
      ),
      Marker('H', Colors.blue, boxSize: boxSize, x: 7, y: 0),
      Marker('T', Colors.red, boxSize: boxSize, x: 0, y: 0),
    ]);
  }
}

class Marker extends StatelessWidget {
  const Marker(
    this.text,
    this.color, {
    Key? key,
    required this.boxSize,
    required this.x,
    required this.y,
  }) : super(key: key);

  final String text;
  final Color color;
  final double boxSize;
  final int x;
  final int y;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x * boxSize,
      top: y * boxSize,
      child: Container(
        width: boxSize,
        height: boxSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}

class GridBox extends StatelessWidget {
  const GridBox({
    Key? key,
    required this.size,
    required this.x,
    required this.y,
  }) : super(key: key);

  final double size;
  final x;
  final y;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        //color: Colors.white,
        border: Border.all(
          color: Colors.black38,
          width: 0.5,
        ),
      ),
      child: Text(
        '$x, $y',
        style: TextStyle(
          fontSize: 8,
        ),
      ),
    );
  }
}
