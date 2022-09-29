import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switchcolor/views/main_scaffold.dart';
import 'package:switchcolor/views/switch_color_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Color Switch',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider(
          create: (context) => SwitchColorState(),
          child: const SelectionArea(
            child: MainScaffold(),
          ),
        ));
  }
}
