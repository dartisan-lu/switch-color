import 'package:flutter/material.dart';
import 'package:switchcolor/views/playground.dart';
import 'package:switchcolor/views/settings_bar.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var screenWidth = mediaQueryData.size.width;
    var screenHeight = mediaQueryData.size.height;
    return Scaffold(
      body: Container(
          margin: const EdgeInsetsDirectional.all(10),
          padding: const EdgeInsetsDirectional.all(10),
          child: Column(children: [
            screenHeight / screenWidth < 1.22
                ? const Expanded(child: FractionallySizedBox(widthFactor: 0.4, child: Playground()))
                : const Expanded(child: Playground()),
            const SettingsBar(),
          ])),
    );
  }
}
