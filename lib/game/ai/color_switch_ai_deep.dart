import 'package:switchcolor/game/point.dart';
import 'package:switchcolor/game/weight_color.dart';

import 'color_switch_ai_common.dart';

/// A DFS Algorithm containing the following restrictions:
/// - Time boxed 2 minutes max
/// - Reduce the path to the minimum of color switches
/// - Hash table to track visited color pattern
/// - Order steps by number of same colors bordered to the main

class ColorSwitchAiDeep extends ColorSwitchAiCommon {
  var board = <List<int>>[];
  var shortestRoadCount = 9999999999999;
  var shortestRoad = <int>[];
  late DateTime endTime;
  var visited = {};

  ColorSwitchAiDeep(this.board) {
    endTime = DateTime.now().add(const Duration(minutes: 2));
  }

  List<int> solve() {
    nextStep(board, <int>[]);
    return shortestRoad;
  }

  void nextStep(List<List<int>> board, List<int> steps) {
    if (DateTime.now().isAfter(endTime)) {
      return;
    }

    var hash = Object.hashAll(board);
    if (visited.containsKey(hash) && visited[hash] >= steps.length) {
      return;
    }

    if (!notAllSameColor(board)) {
      if (steps.length < shortestRoadCount) {
        shortestRoadCount = steps.length;
        shortestRoad = List.of(steps);
      }
      return;
    }

    var colorList = getWeightColors(board);

    for (var color in colorList) {
      var stepsPlusOne = List.of(steps);
      stepsPlusOne.add(color);
      nextStep(applySwitchToColor(board, color), stepsPlusOne);
    }
  }

  List<int> getWeightColors(List<List<int>> board) {
    var oldColor = board[0][0];
    var colors = <WeightColor>[];
    var visited = <Point>{};

    check(Point point) {
      if (visited.contains(point)) {
        return;
      }
      visited.add(point);
      if (board[point.y][point.x] == oldColor) {
        if (point.x > 0) check(Point(point.x - 1, point.y));
        if (point.y > 0) check(Point(point.x, point.y - 1));
        if (point.x < board.length - 1) check(Point(point.x + 1, point.y));
        if (point.y < board.length - 1) check(Point(point.x, point.y + 1));
      } else {
        if (colors.contains(WeightColor(board[point.y][point.x], 0))) {
          colors.firstWhere((e) => e.color == board[point.y][point.x]).inc();
        } else {
          colors.add(WeightColor(board[point.y][point.x], 0));
        }
      }
    }

    check(Point(0, 0));
    colors.sort();
    return colors.map((e) => e.color).toList();
  }
}
