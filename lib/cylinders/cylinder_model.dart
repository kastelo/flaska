import 'dart:math';

import '../proto/proto.dart';
import 'units.dart';

const reservePressure = PressureBar(35);
const valveBuyoancyKg = -0.7;
const troubleSolvingMin = 4.0;

class CylinderModel {
  final String name;
  final Metal metal;
  final Pressure workingPressure;
  final Weight weight;
  final Volume waterVolume;
  final bool selected;

  const CylinderModel(this.name, this.metal, this.workingPressure,
      this.waterVolume, this.weight, this.selected);

  CylinderModel.fromData(CylinderData d)
      : name = d.name,
        metal = d.metal,
        workingPressure = d.measurements == MeasurementSystem.METRIC
            ? PressureBar(d.workingPressure.toInt())
            : PressurePsi(d.workingPressure.toInt()),
        waterVolume = d.measurements == MeasurementSystem.METRIC
            ? VolumeLiter(d.volume)
            : VolumeLiter.fromPressure(d.volume, d.workingPressure.toInt()),
        weight = d.measurements == MeasurementSystem.METRIC
            ? WeightKg(d.weight)
            : WeightLb(d.weight),
        selected = d.selected;

  double get materialDensity {
    switch (metal) {
      case Metal.STEEL:
        return steelKgPerL;
      case Metal.ALUMINIUM:
        return aluKgPerL;
    }
    return aluKgPerL;
  }

  Volume compressedVolume(Pressure p) =>
      VolumeLiter(waterVolume.liter * equivalentPressure(p).bar);

  Weight buoyancy(Pressure p) => WeightKg(externalVolume.liter * waterPerL -
      weight.kg +
      valveBuyoancyKg -
      equivalentPressure(p).bar * waterVolume.liter * airKgPerL);

  Volume get externalVolume =>
      VolumeLiter(weight.kg / materialDensity + waterVolume.liter);

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
