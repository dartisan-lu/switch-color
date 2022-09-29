import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switchcolor/views/switch_color_state.dart';

class Playground extends StatelessWidget {
  const Playground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GridTile> generateItems() {
      var state = context.read<SwitchColorState>();
      var rtn = <GridTile>[];

      for (var y = 0; y < state.dimension; y++) {
        for (var x = 0; x < state.dimension; x++) {
          rtn.add(GridTile(child: Container(color: state.getGridItem(x, y))));
        }
      }
      return rtn;
    }

    return Container(
        padding: EdgeInsets.all(10),
        child: Consumer<SwitchColorState>(builder: (context, state, child) {
          return GridView.count(
              crossAxisCount: state.dimension.toInt(),
              childAspectRatio: 1.0,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              children: generateItems());
        }));
  }
}
