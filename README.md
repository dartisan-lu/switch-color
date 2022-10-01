# Switch Color

Challenge is based on the Algo Battle (Color-It)
https://www.youtube.com/watch?v=-L8J7NQvqhU from SFEIR.

## Strategy

As the information based for the challenge had been limited on behavior, size and time limit, I choose a classic DFS (
Deep First Search) as base. This guarantees already a result in 2 Minutes or earlier as in the first walk it finds a
result, even when not the best.

Couple of actions done to optimize the following executions.

* Shortest Path: each time, we arrive in coloring all in the same color, we keep the number of steps, and limit the
  following branches to not pass this limit.

* Memorise Visited: each color table is hashed and stored with the number of steps reached to it. This limit to not
  repeatedly calculate same pattern, except when reached with lesser steps.

* Ordered Steps: to choose the next color, I count all colors currently next to the main color, sort them, and choose
  preferably the color most present as starting calculated.

* Border extension: for reducing the calculation amounts, specially in the later stage when the main color has extended
  more and more, I keep track of the border points, and calculate on the next recursive branch only from these. (Only
  interesting in large boards)

As the current implementation always generate the points with random color, there was no recognizable pattern in
grouping points to forms, and compute the groups in global and not individual points.

## Implementation

There a 3 classes in: /lib/game/ai

* color_switch_ai_common.dart: A common abstract class containing the methods for validating the current table if the
  same color and switching the colors of the table to the next color.
* color_switch_ai_basic.dart: A simple linear implementation, choosing a color based on LEFT -> RIGHT, TOP -> DOWN. This
  mainly for having a reference on counting the steps.
* color_switch_ai_deep.dart: The AI put to challenge, containing the maon algorithm.

The shell executable to read and write the CSV files and executing the AI under /bin

A Flutter UI implementation for showcase how the Algo will operate can be found under /view running on Android, IOS,
Desktop (Tested Android + Web)

## Code

````dart
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
````

## Execution

For best execution time, the compiled version is preferable.

### Compiled

Installing Flutter:
https://docs.flutter.dev/get-started/install

Compiling executable:

Inside the folder containing pubspec.yaml (root):

````
flutter pub get
dart compile exe bin/color-it.dart -o color-it.sh
````

Execute:

````
./color-it.sh ./demofiles/sample.csv ./demofiles/sample-result.csv
````

### Docker

If you have Docker installed, and don't want to install Flutter on your station, this is an alternative.

The dockerfile contain the files for input/output

````
ENTRYPOINT ["bin/color-it.sh", "/demofiles/sample.csv", "/demofiles/sample-result.csv"]
````

and need to referred on execution as absolute path:

````
docker build -t colot-it-dart .
docker run -v [[absolute path]]/demofiles:/demofiles colot-it-dart
````

Result file in /demofiles/sample-result.csv:

````
[2022-10-01 17:18:17.819518] Starting import file [demofiles/sample.csv]...
[2022-10-01 17:18:17.837607] Converting import...
[2022-10-01 17:18:17.838972] Starting AI calculation, limited 2 Minutes...
[2022-10-01 17:20:17.838993] Preparing CSV Output under [demofiles/sample.csv]...
[2022-10-01 17:20:17.840975] Done. Thanks, have a nice day :-)
````
