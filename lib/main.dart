import 'package:flutter/material.dart';

import 'cylinder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Tank Buddy"),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final cylinders = [
    MetricCylinder("12x232", Metal.Steel, PressureBar(232), 12.0, 14.7),
    MetricCylinder("8x300", Metal.Steel, PressureBar(300), 8.0, 14.7),
    ImperialCylinder("AL80", Metal.Aluminium, PressurePsi(3000), 77.4, 31.9),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: cylinders
          .map((c) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: CylinderViewMetric(
                    cylinder: c,
                    pressure: PressureBar(200),
                    sac: 13.0,
                    avgDepth: 10.0),
              ))
          .toList(),
    );
  }
}
