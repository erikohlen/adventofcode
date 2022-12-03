import 'dart:math';

import 'package:adventofcode/utils/load_utils.dart';
import 'package:flutter/material.dart';

enum Hand { x, y, z }

enum Result { win, lose, draw }

class Dec2_2022 extends StatefulWidget {
  const Dec2_2022({super.key});
  @override
  State<Dec2_2022> createState() => _Dec2_2022State();
}

class _Dec2_2022State extends State<Dec2_2022> {
  String sample = "";
  String input = "";

  @override
  void initState() {
    loadAssetFileAsString("2022_2_sample.txt").then((value) {
      setState(() {
        sample = value;
      });
    });
    loadAssetFileAsString("2022_2_input.txt").then((value) {
      setState(() {
        input = value;
        print('input loaded');
      });
    });
    super.initState();
  }

  Hand stringToHand(String s) {
    switch (s) {
      case "A":
        return Hand.x;
      case "X":
        return Hand.x;
      case "B":
        return Hand.y;
      case "Y":
        return Hand.y;
      case "C":
        return Hand.z;
      case "Z":
        return Hand.z;
      default:
        throw Exception("Invalid hand");
    }
  }

  Result stringToResult(String s) {
    switch (s) {
      case "X":
        return Result.lose;
      case "Y":
        return Result.draw;
      case "Z":
        return Result.win;
      default:
        throw Exception("Invalid result");
    }
  }

  Hand handToGetResult(Hand h1, Result r) {
    switch (r) {
      case Result.lose:
        switch (h1) {
          case Hand.x:
            return Hand.z;
          case Hand.y:
            return Hand.x;
          case Hand.z:
            return Hand.y;
        }
        break;
      case Result.draw:
        return h1;
      case Result.win:
        switch (h1) {
          case Hand.x:
            return Hand.y;
          case Hand.y:
            return Hand.z;
          case Hand.z:
            return Hand.x;
        }
        break;
    }
  }

  int handPoints(Hand h) {
    switch (h) {
      case Hand.x: // Rock, A, X
        return 1;
      case Hand.y: // Paper, B, Y
        return 2;
      case Hand.z: // Scissors, C, Z
        return 3;
      default:
        return 0;
    }
  }

  int resultPoints(Result r) {
    switch (r) {
      case Result.lose:
        return 0;
      case Result.draw:
        return 3;
      case Result.win:
        return 6;
      default:
        return 0;
    }
  }

  Result play(Hand h1, Hand h2) {
    if (h1 == h2) {
      return Result.draw;
    } else if (h1 == Hand.x && h2 == Hand.z) {
      return Result.lose;
    } else if (h1 == Hand.y && h2 == Hand.x) {
      return Result.lose;
    } else if (h1 == Hand.z && h2 == Hand.y) {
      return Result.lose;
    } else {
      return Result.win;
    }
  }

  int roundHandPoints(Hand h) {
    return handPoints(h);
  }

  int roundResultsPoints(Hand h1, Hand h2) {
    return resultPoints(play(h1, h2));
  }

  int roundTotalPoints(Hand h1, Hand h2) {
    return roundResultsPoints(h1, h2) + roundHandPoints(h2);
  }

  // Sum list of numbers
  int sum(List<int> list) {
    int total = 0;
    for (int i = 0; i < list.length; i++) {
      total += list[i];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    var inputHandsStr = input.split('\n').map((e) => e.split(' '));
    List<List> inputHands = inputHandsStr.map((h) {
      return [
        stringToHand(h[0]),
        handToGetResult(stringToHand(h[0]), stringToResult(h[1]))
      ];
    }).toList();

    var resultedSampleHandsRoundTotalPoints =
        inputHands.map((e) => roundTotalPoints(e[0], e[1])).toList();
    var resultedSampleHandsTotalPoitns =
        sum(resultedSampleHandsRoundTotalPoints);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ListView(
        children: [
          Text(
            'Dec 2',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '🪨 📄 ✂️',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
          const SizedBox(
            height: 64,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...resultedSampleHandsTotalPoitns.toString().split("").map((e) {
                // List of colors with different shades of red, green and blue
                List<Color> colors = [
                  Colors.red[100]!,
                  Colors.red[200]!,
                  Colors.red[300]!,
                  Colors.red[400]!,
                  Colors.red[500]!,
                  Colors.red[600]!,
                  Colors.red[700]!,
                  Colors.red[800]!,
                  Colors.red[900]!,
                  Colors.green[100]!,
                  Colors.green[200]!,
                  Colors.green[300]!,
                  Colors.green[400]!,
                  Colors.green[500]!,
                  Colors.green[600]!,
                  Colors.green[700]!,
                  Colors.green[800]!,
                  Colors.green[900]!,
                  Colors.blue[100]!,
                  Colors.blue[200]!,
                  Colors.blue[300]!,
                  Colors.blue[400]!,
                  Colors.blue[500]!,
                  Colors.blue[600]!,
                  Colors.blue[700]!,
                  Colors.blue[800]!,
                  Colors.blue[900]!,
                ];

                // Generate random number between 0 and 3
                int random = Random().nextInt(colors.length);
                return Text(
                  e,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 120, color: colors[random]),
                );
              }).toList(),
            ],
          )
        ],
      ),
    );
  }
}
