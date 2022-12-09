import 'dart:math';
import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

enum OutputType { general, tailMove, headMove, tailSubMove, headSubMove }

enum MoveType { head, tail }

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
  List<Pos> trail = [];
  List<Pos> trailUnique = [];
  int get uniqueCount => trailUnique.length;

  Tail({
    required this.current,
  });
}

class MoveCmd {
  final String direction;
  final int distance;
  final bool isSubMove;
  final MoveType type;

  MoveCmd(this.direction, this.distance,
      {this.isSubMove = false, required this.type})
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
    t.trail.add(Pos(x: t.current.x, y: t.current.y));
    t.trailUnique = t.trail.toSet().toList();
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
      tailMoves.moves.add(MoveCmd('R', 1, type: MoveType.tail));
    } else if (xDist < -1) {
      tailMoves.moves.add(MoveCmd('L', 1, type: MoveType.tail));
    }
    if (yDist > 1) {
      tailMoves.moves.add(MoveCmd('D', 1, type: MoveType.tail));
    } else if (yDist < -1) {
      tailMoves.moves.add(MoveCmd('U', 1, type: MoveType.tail));
    }

    return tailMoves;
  }
}

const day = 9;
const kHeadColor = Colors.green;
const kTailColor = Colors.red;

class Dec9_2022 extends StatefulWidget {
  const Dec9_2022({super.key});
  @override
  State<Dec9_2022> createState() => _Dec9_2022State();
}

class _Dec9_2022State extends State<Dec9_2022> {
  String sampleStr = "";
  String inputStr = "";
  List<Widget> headOutputs = <Widget>[];
  List<Widget> tailOutputs = <Widget>[];
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
          return MoveCmd(parts[0], int.parse(parts[1]), type: MoveType.head);
        }).toList();
        board = Board(
          h: Head(current: Pos(x: startX, y: startY)),
          t: Tail(current: Pos(x: startX, y: startY)),
        );
        board.t.trail = [Pos(x: startX, y: startY)];
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

    switch (move.type) {
      case MoveType.head:
        switch (move.isSubMove) {
          case false:
            for (var i = 0; i < move.distance; i++) {
              MoveCmd _oneStepMove = MoveCmd(move.direction, 1,
                  type: MoveType.head, isSubMove: true);
              // Insert moves after current move in list
              moves.insert(_moveIndex + 1, _oneStepMove);
            }
            addToOutput(move.direction, move.distance,
                type: OutputType.headMove);
            break;
          case true:
            board.moveHead(move);
            final tailMoves = board.getTailMoves();
            for (var tailMove in tailMoves.moves) {
              moves.insert(_moveIndex + 1, tailMove);
            }
            addToOutput('    ${move.direction}', move.distance,
                type: OutputType.headSubMove);

            break;
        }
        break;
      case MoveType.tail:
        board.moveTail(move);
        addToOutput(move.direction, move.distance, type: OutputType.tailMove);

        break;
    }
    // If next move in list is a tail move, schedule it after a delay
    /*   if (moves[_moveIndex + 1].type == MoveType.tail) {
      Future.delayed(const Duration(milliseconds: 500), () {
        handleMove(moves[_moveIndex + 1], board);
      });
    } */

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
        return MoveCmd(parts[0], int.parse(parts[1]), type: MoveType.head);
      }).toList();
      headOutputs = [];
      tailOutputs = [];
      board.t.trail = [Pos(x: startX, y: startY)];
    });
  }

  void addToOutput(String varName, dynamic val,
      {OutputType type = OutputType.general}) {
    setState(() {
      switch (type) {
        case OutputType.general:
          // _output = Text('$varName: $val');
          break;
        case OutputType.headMove:
          headOutputs.add(Text('$varName: $val',
              style: const TextStyle(color: kHeadColor)));
          break;
        case OutputType.headSubMove:
          headOutputs.add(Text('  $varName: $val',
              style: const TextStyle(color: kHeadColor)));
          break;
        case OutputType.tailMove:
          tailOutputs.add(Text('$varName: $val',
              style: const TextStyle(color: kTailColor)));
          break;

        case OutputType.tailSubMove:
          tailOutputs.add(Text('$varName: $val',
              style: const TextStyle(color: kTailColor)));
          break;
      }
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

    double _outputListHeights = MediaQuery.of(context).size.height * 0.5;
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Container(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0, top: 64),
              child: Column(
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
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: _outputListHeights,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Text('Queue: '),
                              ...moves.map((e) => Text(
                                  '${e.type.name[0]} - ${e.direction}: ${e.distance}',
                                  style: TextStyle(
                                    fontWeight: _moveIndex > 0 &&
                                            e == moves[_moveIndex - 1]
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: _moveIndex > 0 &&
                                            e == moves[_moveIndex - 1]
                                        ? Colors.white
                                        : Colors.grey,
                                  ))),
                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: _outputListHeights,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Text('Head:'),
                              ...headOutputs,
                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: _outputListHeights,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Text('Tail:'),
                              ...tailOutputs,
                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: _outputListHeights,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Text('Trail:'),
                              ...board.t.trail.map(
                                (e) => Text(
                                  'x${e.x} y${e.y}',
                                  style: TextStyle(
                                    fontWeight: board.t.current.x == e.x &&
                                            board.t.current.y == e.y
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: board.t.current.x == e.x &&
                                            board.t.current.y == e.y
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
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
                  startX: startX,
                  startY: startY,
                  trail: board.t.trailUnique,
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

  final int startX;
  final int startY;

  final List<Pos> trail;

  const VisualBoard({
    Key? key,
    this.tX = 0,
    this.tY = 0,
    this.hX = 0,
    this.hY = 0,
    this.startX = 0,
    this.startY = 0,
    required this.trail,
  }) : super(key: key);

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
        kTailColor,
        boxSize: markerSize,
        x: tX,
        y: tY,
        opacity: markerOpacity,
      ),
      Marker(
        'H',
        kHeadColor,
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
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
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
