import 'dart:math';
import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

enum OutputKind { general, tailMove, headMove, tailMoveSub, headMoveSub }

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
  final String direction;
  final int distance;
  final bool isSubMove;
  final bool isTailMove;

  MoveCmd(this.direction, this.distance,
      {this.isSubMove = false, this.isTailMove = false})
      : assert(direction == 'R' ||
            direction == 'L' ||
            direction == 'U' ||
            direction == 'D');
}

class TailMoves {
  final List<MoveCmd> moves = [];
}

class Board {
  Head h;
  Tail t;
  List<MoveCmd> headMoveHistory = [];
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
        h.current.y -= move.distance;
        break;
      case 'D':
        h.current.y += move.distance;
        break;
    }

    // Add to history
    headMoveHistory.add(move);
  }

  void moveTail(MoveCmd move) {
    switch (move.direction) {
      case 'R':
        t.current.x += move.distance;
        break;
      case 'L':
        t.current.x -= move.distance;
        break;
      case 'U':
        t.current.y -= move.distance;
        break;
      case 'D':
        t.current.y += move.distance;
        break;
    }

    // Add to history
    t.posHistory.add(t.current);
    t.posHistoryUnique = t.posHistory.toSet().toList();
  }

  TailMoves getTailMoves() {
    // Check distance to head

    int hX = h.current.x;
    int hY = h.current.y;
    int tX = t.current.x;
    int tY = t.current.y;

    // Distance in grid
    int xDist = hX - tX;
    int yDist = hY - tY;

    // Tail move logic
    TailMoves tailMoves = TailMoves();
    if (xDist > 1) {
      tailMoves.moves.add(MoveCmd('L', xDist - 1, isTailMove: true));
    } else if (xDist < -1) {
      tailMoves.moves.add(MoveCmd('R', -xDist - 1, isTailMove: true));
    }

    if (yDist > 1) {
      tailMoves.moves.add(MoveCmd('D', yDist - 1, isTailMove: true));
    } else if (yDist < -1) {
      tailMoves.moves.add(MoveCmd('U', -yDist - 1, isTailMove: true));
    }

    return tailMoves;
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
  List<Widget> outputs = <Widget>[];
  List<String> moveCmdStrs = [];
  List<MoveCmd> moves = [];
  int startX = 25;
  int startY = 25;
  late Board board;

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
        board = Board(
          h: Head(current: Pos(x: startX, y: startY)),
          t: Tail(current: Pos(x: startX, y: startY)),
        );
      });
    });

    loadAssetFileAsString("2022_${day}_input.txt").then((value) {
      setState(() {
        inputStr = value;
      });
    });
    super.initState();
  }

  void handleMove(MoveCmd move, Board board) {
    if (_moveIndex >= moves.length - 1) return;

    switch (move.distance == 1) {
      case true:
        switch (move.isTailMove) {
          case false:
            board.moveHead(move);
            final tailMoves = board.getTailMoves();
            for (var tailMove in tailMoves.moves) {
              moves.insert(_moveIndex + 1, tailMove);
            }
            if (!move.isSubMove)
              addToOutput(move.direction, move.distance,
                  type: OutputKind.headMove);
            if (move.isSubMove)
              addToOutput('    ${move.direction}', move.distance,
                  type: OutputKind.headMove);
            break;
          case true:
            board.moveTail(move);
            if (move.isSubMove)
              addToOutput('    ${move.direction}', move.distance);
            break;
        }
        break;
      case false:
        for (var i = 0; i < move.distance; i++) {
          MoveCmd _oneStepMove = MoveCmd(move.direction, 1, isSubMove: true);
          // Insert moves after current move in list
          moves.insert(_moveIndex + 1, _oneStepMove);
        }
        break;
    }
    setState(() {
      _moveIndex++;
    });
  }

  int _moveIndex = 0;

  void restart() {
    setState(() {
      _moveIndex = 0;
      moves = moveCmdStrs.map((e) {
        var parts = e.split(' ');
        return MoveCmd(parts[0], int.parse(parts[1]));
      }).toList();
      outputs = [];
    });
  }

  void addToOutput(String varName, dynamic val,
      {OutputKind type = OutputKind.general}) {
    setState(() {
      Widget _output = Text('$varName: $val');

      outputs.add(_output);
    });
  }

  @override
  Widget build(BuildContext context) {
    var sample = sampleStr;
    var input = inputStr;

    if (sample.isEmpty) {
      return const Text('No input');
    }

    /* var moves = moveCmdStrs.map((e) {
      var parts = e.split(' ');
      return MoveCmd(parts[0], int.parse(parts[1]));
    }).toList(); */

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
    /* board.moveHistory.forEach((element) {
      addToOutput(
          'Movehistory of board:', '${element.direction} ${element.distance}');
    }); */

    bool _isGameStarted = _moveIndex > 0;
    bool _isEndOfGame = _moveIndex >= moves.length - 1;
    // outputs.add('Unique positions in trail: ${board.t.uniqueCount}');
    if (_isEndOfGame) {
      addToOutput('Done', '');
    }
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Container(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0, top: 64),
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
                      handleMove(moves[_moveIndex], board);
                    },
                    child: const Text('Next move'),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                    onPressed: !_isGameStarted
                        ? null
                        : () {
                            setState(() {
                              restart();
                              board = Board(
                                h: Head(current: Pos(x: startX, y: startY)),
                                t: Tail(current: Pos(x: startX, y: startY)),
                              );
                            });
                          },
                    child: Text(
                      'Restart',
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      ...outputs,
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 64.0),
                child: VisualBoard(
                  tX: board.t.current.x,
                  tY: board.t.current.y,
                  hX: board.h.current.x,
                  hY: board.h.current.y,
                  sX: startX,
                  sY: startY,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VisualBoard extends StatelessWidget {
  final int tX;
  final int tY;
  final int hX;
  final int hY;
  final int sY;
  final int sX;
  final int startX;
  final int startY;

  const VisualBoard(
      {Key? key,
      this.tX = 0,
      this.tY = 0,
      this.hX = 0,
      this.hY = 0,
      this.sX = 0,
      this.sY = 0,
      this.startX = 0,
      this.startY = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double brdWidth = MediaQuery.of(context).size.width - 64 - 300;
    int xSquareCount = 50;
    int ySquareCount = xSquareCount;
    double squareSize = brdWidth / xSquareCount;
    double markerSize = squareSize;
    int gridWidth = 50;
    int gridHeight = gridWidth;
    int boxCount = xSquareCount * ySquareCount;
    double markerOpacity = 1;
    return Stack(children: [
      GridView.count(
        crossAxisCount: xSquareCount,
        shrinkWrap: true,
        children: List.generate(boxCount, (index) {
          int x = index % gridWidth;
          int y = index ~/ gridWidth;
          return GridSquare(
              size: squareSize,
              x: x,
              y: y,
              isStart: x == startX && y == startY);
        }),
      ),
      Marker(
        'T',
        Colors.blue,
        boxSize: markerSize,
        x: tX,
        y: tY,
        opacity: markerOpacity,
      ),
      Marker(
        'H',
        Colors.red,
        boxSize: markerSize,
        x: hX,
        y: hY,
        opacity: markerOpacity,
      ),
      /*   Marker(
        's',
        Colors.transparent,
        boxSize: markerSize,
        x: tX,
        y: tY,
        opacity: 0.5,
      ), */

      /* ...List.generate(
        gridWidth,
        (index) {
          return Marker(
            index.toString(),
            Colors.blue,
            boxSize: markerSize,
            x: index,
            y: 3,
            opacity: 0.2,
          );
        },
      ), */
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
    this.opacity = 1,
  }) : super(key: key);

  final String text;
  final Color color;
  final double boxSize;
  final int x;
  final int y;
  final double opacity;

  static const double padding = 2;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x * boxSize,
      top: y * boxSize,
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Container(
          width: boxSize - padding * 2,
          height: boxSize - padding * 2,
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 8),
            ),
          ),
        ),
      ),
    );
  }
}

class GridSquare extends StatelessWidget {
  const GridSquare({
    Key? key,
    required this.size,
    required this.x,
    required this.y,
    this.isStart = false,
  }) : super(key: key);

  final double size;
  final int x;
  final int y;
  final bool isStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        //color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 0.05,
        ),
      ),
      child: isStart ? const Center(child: Text('S')) : const SizedBox(),
    );
  }
}
