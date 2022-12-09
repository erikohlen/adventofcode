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

/*   // @override equal operator
  bool operator ==(Object other) {
    return other is Pos && other.x == x && other.y == y;
  } */
}

class Head {
  Pos current;

  Head({
    required this.current,
  });

  void printPos() {
    print('Head - x: ${current.x}, y: ${current.y}');
  }
}

class Tail {
  Pos current;
  List<Pos> history = [];

  Tail({
    required this.current,
  });

  void printTrail() {
    for (var pos in history) {
      print('History - x: ${pos.x}, y: ${pos.y}');
    }
  }

  void printPos() {
    print('Tail - x: ${current.x}, y: ${current.y}');
  }

  // Count unique positions in trail (unique is same x and y)
  int countUnique() {
    var unique = <Pos>{};
    for (var pos in history) {
      unique.add(pos);
    }
    return unique.length;
  }
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
    h.printPos();
  }

  void moveTailMaybe() {
    // Check distance to head
    var dist = sqrt(
        pow(h.current.x - t.current.x, 2) + pow(h.current.y - t.current.y, 2));
    if (dist > 1) {
      // Move tail
      var dx = h.current.x - t.current.x;
      var dy = h.current.y - t.current.y;
      if (dx.abs() > dy.abs()) {
        if (dx > 0) {
          t.current.x += 1;
        } else {
          t.current.x -= 1;
        }
      } else {
        if (dy > 0) {
          t.current.y += 1;
        } else {
          t.current.y -= 1;
        }
      }
    }
    t.history.add(Pos(x: t.current.x, y: t.current.y));
    t.printPos();
  }

  void printBoard() {
    var board = List.generate(10, (index) => List.filled(10, ' '));
    board[h.current.y][h.current.x] = 'H';
    board[t.current.y][t.current.x] = 'T';
    for (var row in board) {
      print(row);
    }
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

  @override
  Widget build(BuildContext context) {
    var sample = sampleStr;
    var input = inputStr;
    var outputs = <String>[];
    void addToOutput(List<String> list, String varName, dynamic val) {
      list.add('$varName $val');
    }

    var moveCmdStrs = sample.split('\n');

    var moves = moveCmdStrs.map((e) {
      print(e);
      var parts = e.split(' ');
      print(parts);
      return MoveCmd(parts[0], int.parse(parts[1]));
    }).toList();

    var board = Board(
      h: Head(current: Pos(x: 0, y: 0)),
      t: Tail(current: Pos(x: 0, y: 0)),
    );

    for (var move in moves) {
      board.moveHead(move);
      board.moveTailMaybe();
    }

    //board.printBoard();

    // print unique positions in trail
    outputs.add('Unique positions in trail: ${board.t.countUnique()}');

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListView(
        reverse: false,
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
          ...outputs.map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(e),
              )),
        ],
      ),
    );
  }
}
