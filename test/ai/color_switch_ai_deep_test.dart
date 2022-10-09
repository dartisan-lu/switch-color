import 'dart:math';

import 'package:switchcolor/game/ai/color_switch_ai_deep.dart';

void main() {
  // Parameters
  var dimension = 5;
  var nbrColors = 5;

  // Generate Random Board
  var rng = Random();

  var board = <List<int>>[];
  for (var y = 0; y < dimension; y++) {
    board.add([]);
    for (var x = 0; x < dimension; x++) {
      board[y].add(rng.nextInt(nbrColors));
    }
  }

  // Init + Test AI
  var ai = ColorSwitchAiDeep(board);
  var moves = ai.solve();

  print('Colors to use in order: $moves');
}
