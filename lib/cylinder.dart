import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

const literPerCuft = 0.0353147;
const barPerPsi = 0.0689476;
const kgPerLbs = 0.453592;
const steelKgPerL = 8.05;
const aluKgPerL = 2.7;
const airKgPerL = 1.2041 / 1000;
const waterPerL = 1.020;
const reservePressure = PressureBar(35);
const valveBuyoancyKg = -0.7;
const troubleSolvingMin = 4.0;

final airZ = [
  [0, 1.0],
  [1, 0.9999],
  [5, 0.9987],
  [10, 0.9974],
  [20, 0.9950],
  [40, 0.9917],
  [60, 0.9901],
  [80, 0.9903],
  [100, 0.9930],
  [150, 1.0074],
  [200, 1.0326],
  [250, 1.0669],
  [300, 1.1089],
  [350, 1.2073],
  [400, 1.3163],
];

Pressure equivalentPressure(Pressure p) {
  for (var pair in airZ.asMap().entries) {
    if (pair.value[0] > p.bar) {
      final x = p.bar;
      final x0 = airZ[pair.key - 1][0];
      final x1 = pair.value[0];
      final y0 = airZ[pair.key - 1][1];
      final y1 = pair.value[1];
      final y = (y0 * (x1 - x) + y1 * (x - x0)) / (x1 - x0);
      return PressureBar(p.bar / y);
    }
  }
  return PressureBar(p.bar / airZ.last[1]);
}

enum Metal { Steel, Aluminium }

abstract class Pressure {
  double get bar;
  double get psi;
  const Pressure();
}

class PressureBar extends Pressure {
  final double bar;
  double get psi => bar / barPerPsi;
  const PressureBar(this.bar);
}

class PressurePsi extends Pressure {
  final double psi;
  double get bar => psi * barPerPsi;
  const PressurePsi(this.psi);
}

abstract class Cylinder {
  final String name;
  final Metal metal;
  final Pressure workingPressure;
  double get volumeLiters;
  double get weightKg;

  const Cylinder(this.name, this.metal, this.workingPressure);

  double get compressedVolumeCuft =>
      compressedVolumeL(workingPressure) * literPerCuft;
  double compressedVolumeL(Pressure p) =>
      volumeLiters * equivalentPressure(p).bar;
  double buoyancyKg(Pressure p) =>
      externalVolume * waterPerL -
      weightKg +
      valveBuyoancyKg -
      equivalentPressure(p).bar * volumeLiters * airKgPerL;

  double get materialDensity {
    switch (metal) {
      case Metal.Steel:
        return steelKgPerL;
      case Metal.Aluminium:
        return aluKgPerL;
    }
    return aluKgPerL;
  }

  double get externalVolume => weightKg / materialDensity + volumeLiters;
  double get buoyancyFull => buoyancyKg(workingPressure);
  double get buoyancyEmpty => buoyancyKg(reservePressure);

  double safeReserveL({double sac, double depth}) {
    // Four minutes at depth, two people, double SAC
    final troubleSolvingL = troubleSolvingMin * sac * 4 * (10 + depth) / 10;
    // Ascent at 10 m/min, double SAC
    final ascentL = depth / 10 * sac * 4 * (10 + depth / 2) / 10;
    // Five minutes safety stop, two people, normal SAC
    final safetyStopL = 5.0 * sac * 2 * (10 + 5) / 10;
    return troubleSolvingL + ascentL + safetyStopL;
  }

  Pressure safeReservePressure({double sac, double depth}) =>
      PressureBar(safeReserveL(sac: sac, depth: depth) / volumeLiters);
}

class MetricCylinder extends Cylinder {
  final double volumeLiters;
  final double weightKg;

  const MetricCylinder(String name, Metal metal, Pressure workingPressure,
      this.volumeLiters, this.weightKg)
      : super(name, metal, workingPressure);
}

class ImperialCylinder extends Cylinder {
  final double compressedVolumeCuft;
  final double weightLb;

  double get volumeLiters =>
      compressedVolumeCuft /
      literPerCuft /
      equivalentPressure(workingPressure).bar;
  double get weightKg => weightLb * kgPerLbs;

  const ImperialCylinder(String name, Metal metal, Pressure workingPressure,
      this.compressedVolumeCuft, this.weightLb)
      : super(name, metal, workingPressure);
}

class CylinderViewMetric extends StatelessWidget {
  final Cylinder cylinder;
  final Pressure pressure;
  final double sac;
  final double avgDepth;

  CylinderViewMetric(
      {@required this.cylinder,
      @required this.pressure,
      @required this.sac,
      @required this.avgDepth});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(children: [
          header("Tank", context),
          Text("%s (%.01f L %.0f bar, %.01f kg)".format([
            cylinder.name,
            cylinder.volumeLiters,
            cylinder.workingPressure.bar,
            cylinder.weightKg
          ])),
        ]),
        TableRow(children: [
          header("Gas", context),
          Text("%.0f L air at %.0f bar".format([
            cylinder.compressedVolumeL(pressure),
            pressure.bar,
          ]))
        ]),
        TableRow(children: [
          header("Air Time", context),
          Text("%.0f min to %.0f bar (%.0f L rock bottom)".format([
            (cylinder.compressedVolumeL(pressure) -
                    cylinder.safeReserveL(sac: sac, depth: avgDepth)) /
                sac /
                (10 + avgDepth) *
                10,
            cylinder.safeReservePressure(sac: sac, depth: avgDepth).bar,
            cylinder.safeReserveL(sac: sac, depth: avgDepth)
          ]))
        ]),
        TableRow(children: [
          header("Buoyancy", context),
          Text("%+.01f kg at %.0f bar (%+.01f kg at %.0f bar)".format([
            cylinder.buoyancyKg(pressure),
            pressure.bar,
            cylinder.buoyancyEmpty,
            reservePressure.bar,
          ]))
        ]),
      ],
    );
  }

  Widget header(String text, BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.grey),
        ),
      );
}

extension StringFormatExtension on String {
  String format(var arguments) => sprintf(this, arguments);
}
