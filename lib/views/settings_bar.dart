import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switchcolor/views/switch_color_state.dart';

class SettingsBar extends StatelessWidget {
  const SettingsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsetsDirectional.all(10),
        padding: const EdgeInsetsDirectional.all(10),
        child: Consumer<SwitchColorState>(builder: (context, state, child) {
          return Column(children: [
            Row(children: [
              Expanded(
                  child: Column(children: [
                Slider(
                  value: state.nextDimension,
                  onChanged: (v) {
                    state.changeDimension(v);
                  },
                  divisions: 25,
                  min: 5,
                  max: 30,
                  label: '${state.nextDimension}',
                ),
                Text('Dimension: ${state.nextDimension}'),
              ])),
              Expanded(
                  child: Column(children: [
                Slider(
                  value: state.nextColors,
                  onChanged: (v) {
                    state.changeColor(v);
                  },
                  divisions: 25,
                  min: 5,
                  max: 30,
                  label: '${state.nextColors}',
                ),
                Text('Colors: ${state.nextColors}'),
              ])),
            ]),
            Row(
              children: [
                const Spacer(),
                Tooltip(
                    message: 'Generate Puzzle',
                    child: ElevatedButton(
                      onPressed: state.run
                          ? null
                          : () {
                              state.generatePlayground();
                            },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                      ),
                      child: const Icon(
                        Icons.build_circle_outlined,
                        color: Colors.blue,
                        size: 24.0,
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Tooltip(
                        message: 'Replay Puzzle',
                        child: ElevatedButton(
                          onPressed: state.run
                              ? null
                              : () {
                                  state.replay();
                                },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(24),
                          ),
                          child: const Icon(
                            Icons.restart_alt_outlined,
                            color: Colors.blue,
                            size: 24.0,
                          ),
                        ))),
                Column(children: [
                  Tooltip(
                      message: 'The DFS algorithm is time boxed on 2 minutes calculation',
                      child: DropdownButton<String>(
                        value: state.algo,
                        items: <String>['Linear', 'DFS'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (v) {
                          state.setAlgo(v);
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: Chip(label: Text('Moves: ${state.countMoves}'))),
                ]),
                Tooltip(
                    message: 'Play',
                    child: ElevatedButton(
                      onPressed: state.run
                          ? null
                          : () {
                              state.play();
                            },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                      ),
                      child: const Icon(
                        Icons.play_arrow_outlined,
                        color: Colors.green,
                        size: 24.0,
                      ),
                    )),
                state.run && state.countMoves == 0 && state.algo == 'DFS'
                    ? const Text('Calculating (max 2 minutes)...')
                    : const SizedBox(),
                const Spacer(),
              ],
            )
          ]);
        }));
  }
}
