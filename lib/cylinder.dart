import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

const literPerCuft = 0.0353147;
const barPerPsi = 0.0689476;
const kgPerLbs = 0.453592;
const mPerFt = 0.3048;
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
      return PressureBar(p.bar ~/ y);
    }
  }
  return PressureBar(p.bar ~/ airZ.last[1]);
}

enum Metal { Steel, Aluminium }

abstract class Pressure {
  int get bar;
  int get psi;
  const Pressure();
}

class PressureBar extends Pressure {
  final int bar;
  int get psi => bar ~/ barPerPsi;
  const PressureBar(this.bar);
}

class PressurePsi extends Pressure {
  final int psi;
  int get bar => (psi * barPerPsi).toInt();
  const PressurePsi(this.psi);
}

abstract class Volume {
  double get liter;
  double get cuft;
  const Volume();
}

class VolumeLiter extends Volume {
  final double liter;
  double get cuft => liter * literPerCuft;
  const VolumeLiter(this.liter);
  VolumeLiter.fromPressure(double cuft, int psi)
      : liter =
            VolumeCuFt(cuft).liter / equivalentPressure(PressurePsi(psi)).bar;
}

class VolumeCuFt extends Volume {
  final double cuft;
  double get liter => cuft / literPerCuft;
  const VolumeCuFt(this.cuft);
}

abstract class Distance {
  double get m;
  double get ft;
  const Distance();
}

class DistanceM extends Distance {
  final double m;
  double get ft => m / mPerFt;
  const DistanceM(this.m);
}

class DistanceFt extends Distance {
  final double ft;
  double get m => ft * mPerFt;
  const DistanceFt(this.ft);
}

abstract class Weight {
  double get kg;
  double get lb;
  const Weight();
}

class WeightKg extends Weight {
  final double kg;
  double get lb => kg / kgPerLbs;
  const WeightKg(this.kg);
}

class WeightLb extends Weight {
  final double lb;
  double get kg => lb * kgPerLbs;
  const WeightLb(this.lb);
}

class Cylinder {
  final String name;
  final Metal metal;
  final Pressure workingPressure;
  final Weight weight;
  final Volume waterVolume;

  const Cylinder(this.name, this.metal, this.workingPressure, this.waterVolume,
      this.weight);

  Volume compressedVolume(Pressure p) =>
      VolumeLiter(waterVolume.liter * equivalentPressure(p).bar);

  Weight buoyancy(Pressure p) => WeightKg(externalVolume.liter * waterPerL -
      weight.kg +
      valveBuyoancyKg -
      equivalentPressure(p).bar * waterVolume.liter * airKgPerL);

  double get materialDensity {
    switch (metal) {
      case Metal.Steel:
        return steelKgPerL;
      case Metal.Aluminium:
        return aluKgPerL;
    }
    return aluKgPerL;
  }

  Volume get externalVolume =>
      VolumeLiter(weight.kg / materialDensity + waterVolume.liter);
  Weight get buoyancyFull => buoyancy(workingPressure);
  Weight get buoyancyEmpty => buoyancy(reservePressure);

  double airTimeMin({Pressure pressure, Volume sac, Distance depth}) => max(
      0,
      (compressedVolume(pressure).liter -
              rockBottom(sac: sac, depth: depth).liter) /
          sac.liter /
          (10 + depth.m) *
          10);

  Volume rockBottom({Volume sac, Distance depth}) {
    // Four minutes at depth, two people, double SAC
    final troubleSolvingL =
        troubleSolvingMin * sac.liter * 4 * (10 + depth.m) / 10;
    // Ascent at 10 m/min, double SAC
    final ascentL = depth.m / 10 * sac.liter * 4 * (10 + depth.m / 2) / 10;
    // Five minutes safety stop, two people, normal SAC
    final safetyStopL = 5.0 * sac.liter * 2 * (10 + 5) / 10;
    return VolumeLiter(troubleSolvingL + ascentL + safetyStopL);
  }

  Pressure rockBottomPressure({Volume sac, Distance depth}) => PressureBar(
      rockBottom(sac: sac, depth: depth).liter ~/ waterVolume.liter);
}

abstract class CylinderView extends StatelessWidget {
  Cylinder get cylinder;
  Pressure get pressure;
  Volume get sac;
  Distance get depth;

  const CylinderView();
}

class CylinderViewMetric extends CylinderView {
  final Cylinder cylinder;
  final Pressure pressure;
  final Volume sac;
  final Distance depth;

  CylinderViewMetric(
      {@required this.cylinder,
      @required this.pressure,
      @required this.sac,
      @required this.depth});

  @override
  Widget build(BuildContext context) {
    TextStyle pressureStyle;
    if (pressure.bar > cylinder.workingPressure.bar * 1.15) {
      pressureStyle = errorStyle(context);
    } else if (pressure.bar > cylinder.workingPressure.bar) {
      pressureStyle = warningStyle(context);
    }

    final airTimeMin =
        cylinder.airTimeMin(pressure: pressure, sac: sac, depth: depth);
    TextStyle airTimeStyle;
    if (airTimeMin <= 5) {
      airTimeStyle = errorStyle(context);
    } else if (airTimeMin <= 15) {
      airTimeStyle = warningStyle(context);
    }

    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(children: [
          header("Tank", context),
          Text("%s (%.01f L %d bar, %.01f kg)".format([
            cylinder.name,
            cylinder.waterVolume.liter,
            cylinder.workingPressure.bar,
            cylinder.weight.kg
          ])),
        ]),
        TableRow(children: [
          header("Gas", context),
          Row(
            children: [
              Text("%.0f L air at ".format([
                cylinder.compressedVolume(pressure).liter,
              ])),
              Text(
                "%d bar".format([
                  pressure.bar,
                ]),
                style: pressureStyle,
              ),
            ],
          ),
        ]),
        TableRow(children: [
          header("Air Time", context),
          Row(
            children: [
              Text("%.0f min".format([airTimeMin]), style: airTimeStyle),
              Text(" to %d bar (%.0f L rock bottom)".format([
                cylinder
                    .rockBottomPressure(sac: sac, depth: depth)
                    .bar
                    .roundi(5),
                cylinder.rockBottom(sac: sac, depth: depth).liter
              ])),
            ],
          )
        ]),
        TableRow(children: [
          header("Buoyancy", context),
          Text("%+.01f kg at %d bar (%+.01f kg at %d bar)".format([
            cylinder.buoyancy(pressure).kg,
            pressure.bar,
            cylinder.buoyancyEmpty.kg,
            reservePressure.bar,
          ]))
        ]),
      ],
    );
  }
}

class CylinderViewImperial extends CylinderView {
  final Cylinder cylinder;
  final Pressure pressure;
  final Volume sac;
  final Distance depth;

  CylinderViewImperial(
      {@required this.cylinder,
      @required this.pressure,
      @required this.sac,
      @required this.depth});

  @override
  Widget build(BuildContext context) {
    TextStyle pressureStyle;
    if (pressure.bar > cylinder.workingPressure.bar * 1.15) {
      pressureStyle = errorStyle(context);
    } else if (pressure.bar > cylinder.workingPressure.bar) {
      pressureStyle = warningStyle(context);
    }

    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(children: [
          header("Tank", context),
          Text("%s (%.01f lb)".format([
            cylinder.name,
            cylinder.weight.lb,
          ])),
        ]),
        TableRow(children: [
          header("Gas", context),
          Row(
            children: [
              Text("%.1f ft³ air at ".format([
                cylinder.compressedVolume(pressure).cuft,
              ])),
              Text(
                "%d psi".format([
                  pressure.psi,
                ]),
                style: pressureStyle,
              ),
            ],
          ),
        ]),
        TableRow(children: [
          header("Air Time", context),
          Text("%.0f min to %d psi (%.1f ft³ rock bottom)".format([
            cylinder.airTimeMin(pressure: pressure, sac: sac, depth: depth),
            cylinder.rockBottomPressure(sac: sac, depth: depth).psi.roundi(100),
            cylinder.rockBottom(sac: sac, depth: depth).cuft
          ]))
        ]),
        TableRow(children: [
          header("Buoyancy", context),
          Text("%+.01f lb at %d psi (%+.01f lb at %d psi)".format([
            cylinder.buoyancy(pressure).lb,
            pressure.psi,
            cylinder.buoyancyEmpty.lb,
            reservePressure.psi,
          ]))
        ]),
      ],
    );
  }
}

extension Rounding on int {
  int roundi(int intv) {
    return (this + intv - 1) ~/ intv * intv;
  }
}

Widget header(String text, BuildContext context) => Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.grey),
      ),
    );

extension StringFormatExtension on String {
  String format(var arguments) => sprintf(this, arguments);
}

TextStyle warningStyle(BuildContext context) => Theme.of(context)
    .textTheme
    .bodyText2
    .copyWith(color: Colors.yellowAccent, fontWeight: FontWeight.bold);

TextStyle errorStyle(BuildContext context) => Theme.of(context)
    .textTheme
    .bodyText2
    .copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold);
