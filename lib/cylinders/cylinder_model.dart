import 'dart:math';

import 'package:flutter_guid/flutter_guid.dart';

import '../proto/proto.dart';
import 'units.dart';

const reservePressure = PressureBar(35);
const valveBuyoancyKg = -0.7;
const troubleSolvingMin = 4.0;

class CylinderModel {
  final Guid id;
  final String name;
  final MeasurementSystem measurements;
  final Metal metal;
  final Pressure workingPressure;
  final Weight weight;
  final Volume userSetVolume;
  final Volume waterVolume;
  final bool selected;

  const CylinderModel.metric(this.id, this.name, this.metal,
      this.workingPressure, this.waterVolume, this.weight, this.selected)
      : measurements = MeasurementSystem.METRIC,
        userSetVolume = waterVolume;

  CylinderModel.imperial(this.id, this.name, this.metal, this.workingPressure,
      this.userSetVolume, this.weight, this.selected)
      : measurements = MeasurementSystem.IMPERIAL,
        waterVolume =
            VolumeLiter.fromPressure(userSetVolume.cuft, workingPressure.psi);

  CylinderModel.fromData(CylinderData d)
      : id = Guid(d.id),
        name = d.name,
        measurements = d.measurements,
        metal = d.metal,
        workingPressure = d.measurements == MeasurementSystem.METRIC
            ? PressureBar(d.workingPressure)
            : PressurePsi(d.workingPressure),
        userSetVolume = d.measurements == MeasurementSystem.METRIC
            ? VolumeLiter(d.volume)
            : VolumeCuFt(d.volume),
        waterVolume = d.measurements == MeasurementSystem.METRIC
            ? VolumeLiter(d.volume)
            : VolumeLiter.fromPressure(d.volume, d.workingPressure.toInt()),
        weight = d.measurements == MeasurementSystem.METRIC
            ? WeightKg(d.weight)
            : WeightLb(d.weight),
        selected = d.selected;

  CylinderData toData() {
    return CylinderData()
      ..id = id.toString()
      ..name = name
      ..measurements = measurements
      ..metal = metal
      ..workingPressure = measurements == MeasurementSystem.METRIC
          ? workingPressure.bar
          : workingPressure.psi
      ..volume = measurements == MeasurementSystem.METRIC
          ? userSetVolume.liter
          : userSetVolume.cuft
      ..weight =
          measurements == MeasurementSystem.METRIC ? weight.kg : weight.lb
      ..selected = selected;
  }

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
