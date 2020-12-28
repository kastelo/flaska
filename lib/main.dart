import 'package:flutter/material.dart';

import 'cylinder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tank Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.15),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.15),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Tank Buddy"),
        ),
        body: MyHomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cylinders = [
    Cylinder("ECS 12x232", Metal.Steel, PressureBar(232), VolumeLiter(12.0),
        WeightKg(14.5)),
    Cylinder("Faber 8x300", Metal.Steel, PressureBar(300), VolumeLiter(8.0),
        WeightKg(12.0)),
    Cylinder("ECS 10x300", Metal.Steel, PressureBar(300), VolumeLiter(10),
        WeightKg(15.6)),
    Cylinder("AL80", Metal.Aluminium, PressurePsi(3000),
        VolumeLiter.fromPressure(77.4, 3000), WeightLb(31.9)),
  ];

  Pressure pressure = PressureBar(200);
  Distance depth = DistanceM(10);
  Volume sac = VolumeLiter(13);
  bool metric = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: <Widget>[
        sliders(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: cylinders.map(cylinder).toList() +
                [
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        metric = !metric;
                      });
                    },
                    child: Text(metric ? "Metric" : "Imperial"),
                  ),
                ],
          ),
        ),
      ]),
    );
  }

  Widget cylinder(Cylinder c) {
    if (metric) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CylinderViewMetric(
              cylinder: c,
              pressure: pressure,
              sac: sac,
              depth: depth,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CylinderViewImperial(
              cylinder: c,
              pressure: pressure,
              sac: sac,
              depth: depth,
            ),
          ),
        ),
      );
    }
  }

  Widget sliders() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Table(
        columnWidths: {1: IntrinsicColumnWidth()},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          pressureSlider(),
          depthSlider(),
          sacSlider(),
        ],
      ),
    );
  }

  TableRow pressureSlider() {
    return TableRow(children: [
      metric
          ? Slider(
              value: pressure.bar.toDouble(),
              min: 0,
              max: 300,
              divisions: 60,
              onChanged: (v) {
                setState(() {
                  pressure = PressureBar(v.toInt());
                });
              })
          : Slider(
              value: pressure.psi.toDouble(),
              min: 0,
              max: 4400,
              divisions: 44 * 2,
              onChanged: (v) {
                setState(() {
                  pressure = PressurePsi(v.toInt());
                });
              }),
      Text(
          metric
              ? "%d bar".format([pressure.bar])
              : "%d psi".format([pressure.psi]),
          textAlign: TextAlign.right),
    ]);
  }

  TableRow depthSlider() {
    return TableRow(
      children: [
        metric
            ? Slider(
                value: depth.m,
                min: 0,
                max: 40,
                divisions: 40,
                onChanged: (v) {
                  setState(() {
                    depth = DistanceM(v);
                  });
                })
            : Slider(
                value: depth.ft,
                min: 0,
                max: 130,
                divisions: 13 * 2,
                onChanged: (v) {
                  setState(() {
                    depth = DistanceFt(v);
                  });
                }),
        Text(metric ? "%.0f m".format([depth.m]) : "%.0f ft".format([depth.ft]),
            textAlign: TextAlign.right),
      ],
    );
  }

  TableRow sacSlider() {
    return TableRow(
      children: [
        metric
            ? Slider(
                value: sac.liter,
                min: 5,
                max: 30,
                divisions: 25,
                onChanged: (v) {
                  setState(() {
                    sac = VolumeLiter(v);
                  });
                })
            : Slider(
                value: sac.cuft,
                min: 0,
                max: 1,
                divisions: 10,
                onChanged: (v) {
                  setState(() {
                    sac = VolumeCuFt(v);
                  });
                }),
        Text(
            metric
                ? "%.0f L/min".format([sac.liter])
                : "%.1f ft³/min".format([sac.cuft]),
            textAlign: TextAlign.right),
      ],
    );
  }
}
