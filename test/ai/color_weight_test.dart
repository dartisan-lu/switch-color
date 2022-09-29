import 'package:switchcolor/game/weight_color.dart';

void main() {
  var arr = <WeightColor>[];
  arr.add(WeightColor(1, 3));
  arr.add(WeightColor(2, 7));
  arr.add(WeightColor(3, 1));
  arr.sort();
  print(arr.map((e) => e.color).toList());
}
