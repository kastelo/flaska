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
    Cylinder("12x232", Metal.Steel, PressureBar(232), VolumeLiter(12.0),
        WeightKg(14.7)),
    Cylinder("8x300", Metal.Steel, PressureBar(300), VolumeLiter(8.0),
        WeightKg(14.7)),
    Cylinder("AL80", Metal.Aluminium, PressurePsi(3000),
        VolumeLiter.fromPressure(77.4, 3000), WeightLb(31.9)),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: cylinders
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CylinderViewMetric(
                    cylinder: c,
                    pressure: PressureBar(200),
                    sac: VolumeLiter(13.0),
                    depth: DistanceM(10.0),
                  ),
                ),
              )
              .toList() +
          cylinders
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CylinderViewImperial(
                    cylinder: c,
                    pressure: PressurePsi(3000),
                    sac: VolumeCuFt(0.5),
                    depth: DistanceFt(30.0),
                  ),
                ),
              )
              .toList(),
    );
  }
}
