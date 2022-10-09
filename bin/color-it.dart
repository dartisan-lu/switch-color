import 'dart:io';

import 'package:switchcolor/game/ai/color_switch_ai_deep.dart';

String readFileAsString(String fileName) {
  return File(fileName).readAsStringSync();
}

List<String> readFileAsList(String fileName) {
  return readFileAsString(fileName).split('\n').where((e) => e.isNotEmpty).toList();
}

void main(List<String> args) {
  print('[${DateTime.now()}] Arguments given: $args');

  var inputFile = args.isNotEmpty ? File(args[0]) : File('demofiles/sample.csv');
  var outputFile = args.length > 0 ? File(args[1]) : File('demofiles/sample-result.csv');

  /// INPUT
  print('[${DateTime.now()}] Starting import file [$inputFile]...');
  var inputList = inputFile.readAsStringSync().split('\n').where((e) => e.isNotEmpty).toList();
  print('[${DateTime.now()}] Converting import...');
  var csv = <List<int>>[];
  for (var line in inputList) {
    csv.add(line.split(',').map((e) => int.parse(e)).toList());
  }

  /// CALCULATE
  var ai = ColorSwitchAiDeep(csv);
  print('[${DateTime.now()}] Starting AI calculation, limited 2 Minutes...');
  var result = ai.solve();

  /// OUTPUT
  print('[${DateTime.now()}] Preparing CSV Output under [$outputFile]...');
  outputFile.writeAsStringSync(result.join('\n'));
  print('[${DateTime.now()}] Done. Thanks, have a nice day :-)');
}
