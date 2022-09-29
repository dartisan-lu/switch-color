import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:switchcolor/game/ai/color_switch_ai_common.dart';
import 'package:switchcolor/game/ai/color_switch_ai_deep.dart';

import '../game/ai/color_switch_ai_basic.dart';

class SwitchColorState extends ChangeNotifier {
  double colors = 5;
  double dimension = 5;
  double nextColors = 5;
  double nextDimension = 5;
  var colorList = <Color>[];
  var board = <List<int>>[];
  var bkp = <List<int>>[];
  var run = false;
  var algo = 'DFS';
  int countMoves = 0;

  SwitchColorState() {
    generatePlayground();
  }

  void changeColor(double v) {
    nextColors = v;
    notifyListeners();
  }

  void changeDimension(double v) {
    nextDimension = v;
    notifyListeners();
  }

  void generatePlayground() {
    colors = nextColors;
    dimension = nextDimension;
    var set = <Color>{};
    while (set.length < colors) {
      set.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
    }
    colorList = set.toList();
    board = [];
    for (var y = 0; y < dimension; y++) {
      var row = <int>[];
      for (var x = 0; x < dimension; x++) {
        row.add(math.Random().nextInt(colors.toInt()));
      }
      board.add(row);
    }
    bkp = <List<int>>[];
    for (var l in board) {
      bkp.add(List.of(l));
    }
    notifyListeners();
  }

  Color getColor(int i) {
    return colorList[i];
  }

  Color getGridItem(int x, int y) {
    return getColor(board[y][x]);
  }

  void replay() {
    board = <List<int>>[];
    for (var l in bkp) {
      board.add(List.of(l));
    }
    notifyListeners();
  }

  Future<void> play() async {
    run = true;
    var copy = <List<int>>[];
    countMoves = 0;
    notifyListeners();

    for (var l in board) {
      copy.add(List.of(l));
    }

    var ai = algo == 'DFS' ? ColorSwitchAiDeep(copy) : ColorSwitchAiBasic(copy);
    var moves = await waitMoves(ai);
    run = moves.isNotEmpty;
    notifyListeners();
    for (var i = 0; i < moves.length; i++) {
      board = ai.applySwitchToColor(board, moves[i]);
      run = i != moves.length - 1;
      countMoves++;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<List<int>> waitMoves(ColorSwitchAiCommon ai) async {
    return Future<List<int>>.delayed(const Duration(milliseconds: 5), () => ai.solve());
  }

  void setAlgo(String? v) {
    algo = v ?? 'DFS';
    notifyListeners();
  }
}
