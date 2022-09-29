import 'package:switchcolor/game/ai/color_switch_ai_common.dart';

class ColorSwitchAiBasic extends ColorSwitchAiCommon {
  var board = <List<int>>[];

  /// Simple implementation, looking from LEFT to RIGHT
  /// then TOP to DOWN for the next candidate to switch

  ColorSwitchAiBasic(this.board);

  List<int> solve() {
    var colorOrderToPlay = <int>[];
    while (notAllSameColor(board)) {
      var switchToColor = nextColor(board);
      colorOrderToPlay.add(switchToColor);
      board = applySwitchToColor(board, switchToColor);
    }
    return colorOrderToPlay;
  }

  int nextColor(List<List<int>> board) {
    var startColor = board[0][0];
    for (var row in board) {
      for (var colColor in row) {
        if (startColor != colColor) return colColor;
      }
    }
    // Should never be the case
    return 0;
  }
}
