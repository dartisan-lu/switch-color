import 'dart:collection';

import 'package:switchcolor/game/point.dart';

abstract class ColorSwitchAiCommon {
  List<List<int>> applySwitchToColor(List<List<int>> board, int switchToColor) {
    var switchedColorBoard = <List<int>>[];
    for (var l in board) {
      switchedColorBoard.add(List.of(l));
    }

    var oldColor = switchedColorBoard[0][0];
    var toChange = Queue<Point>();
    toChange.add(Point(0, 0));

    while (toChange.isNotEmpty) {
      var point = toChange.removeFirst();
      if (switchedColorBoard[point.y][point.x] == oldColor) {
        switchedColorBoard[point.y][point.x] = switchToColor;
        if (point.x > 0 && switchedColorBoard[point.y][point.x - 1] == oldColor)
          toChange.add(Point(point.x - 1, point.y));
        if (point.y > 0 && switchedColorBoard[point.y - 1][point.x] == oldColor)
          toChange.add(Point(point.x, point.y - 1));
        if (point.x < switchedColorBoard.length - 1 && switchedColorBoard[point.y][point.x + 1] == oldColor)
          toChange.add(Point(point.x + 1, point.y));
        if (point.y < switchedColorBoard.length - 1 && switchedColorBoard[point.y + 1][point.x] == oldColor)
          toChange.add(Point(point.x, point.y + 1));
      }
    }

    return switchedColorBoard;
  }

  List<int> solve();

  bool notAllSameColor(List<List<int>> board) {
    var startColor = board[0][0];
    for (var row in board) {
      for (var colColor in row) {
        if (startColor != colColor) return true;
      }
    }

    return false;
  }
}
