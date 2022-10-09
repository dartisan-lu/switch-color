import 'dart:collection';

import 'package:switchcolor/game/border_colors.dart';
import 'package:switchcolor/game/point.dart';
import 'package:switchcolor/game/weight_color.dart';

import 'color_switch_ai_common.dart';

/// A DFS Algorithm containing the following restrictions:
/// - Time boxed 2 minutes max
/// - Reduce the path to the minimum of color switches
/// - Hash table to track visited color pattern
/// - Order steps by number of same colors bordered to the main
/// - Reduce Search array to external bordered points

class ColorSwitchAiDeep extends ColorSwitchAiCommon {
  var board = <List<int>>[];

  // Count steps for shortest path
  var shortestRoadCount = 9999999999999;

  // Colors to activate for shortest path
  var shortestRoad = <int>[];

  // Deadline (T+2 minutes)
  late DateTime endTime;

  // Memorize of visited board patterns
  var visited = {};

  // Constructor
  ColorSwitchAiDeep(this.board) {
    endTime = DateTime.now().add(const Duration(minutes: 2));
  }

  // Start DFS Recursive instructions
  List<int> solve() {
    nextStep(board, <int>[], [Point(0, 0)]);
    return shortestRoad;
  }

  void nextStep(List<List<int>> board, List<int> steps, List<Point> borders) {
    // Early Exit, Deadline reached !!!
    if (DateTime.now().isAfter(endTime)) {
      return;
    }

    // Check for visited
    var hash = Object.hashAll(board);
    if (visited.containsKey(hash) && visited[hash] >= steps.length) {
      return;
    }

    // Jackpot, we finalized a way, check if it is the shortest
    if (!notAllSameColor(board)) {
      if (steps.length < shortestRoadCount) {
        if(shortestRoadCount >= 9999999999999) {
          print('[${DateTime.now()}] First result: [${steps.length}]');
        } else {
          print('[${DateTime.now()}] Next result: [${steps.length}]');
        }
        shortestRoadCount = steps.length;
        shortestRoad = List.of(steps);
      }
      return;
    }

    // Prepare next recursive instruction, get colors and border points
    var pathfinder = getWeightColors(board, borders);

    // Switch to each color and calculate next recursive iteration
    for (var color in pathfinder.sortedColors) {
      var stepsPlusOne = List.of(steps);
      stepsPlusOne.add(color);
      nextStep(applySwitchToColor(board, color), stepsPlusOne, pathfinder.borders);
    }
  }

  // Search for colors next to apply. Use last border points as offset
  BorderColors getWeightColors(List<List<int>> board, List<Point> lastBorders) {
    var oldColor = board[0][0];
    var colors = <WeightColor>[];
    var borders = <Point>[];
    var visited = <Point>{};
    var toCheck = Queue<Point>();
    toCheck.addAll(lastBorders);

    while (toCheck.isNotEmpty) {
      var point = toCheck.removeFirst();
      if (!visited.contains(point)) {
        visited.add(point);
        // Check if we are still on main color or need crossed border and have a switch color
        if (board[point.y][point.x] == oldColor) {
          // Still in main color
          if (point.x > 0) toCheck.add(Point(point.x - 1, point.y));
          if (point.y > 0) toCheck.add(Point(point.x, point.y - 1));
          if (point.x < board.length - 1) toCheck.add(Point(point.x + 1, point.y));
          if (point.y < board.length - 1) toCheck.add(Point(point.x, point.y + 1));
        } else {
          // Add border color
          borders.add(point);
          if (colors.contains(WeightColor(board[point.y][point.x], 0))) {
            colors.firstWhere((e) => e.color == board[point.y][point.x]).inc();
          } else {
            colors.add(WeightColor(board[point.y][point.x], 0));
          }
        }
      }
    }

    // Sort colors DESC
    colors.sort();
    return BorderColors(colors.map((e) => e.color).toList(), borders);
  }
}
