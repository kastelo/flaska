import 'dart:math';

import 'package:flutter_guid/flutter_guid.dart';

import '../proto/proto.dart';
import 'units.dart';

const reservePressure = PressureBar(35);
const valveBuyoancyKg = -0.7;
const troubleSolvingMin = 4.0;
const safetyStopDepth = DistanceM(5.0);
const safetyStopDurationMin = 5.0;

class CylinderModel {
  Guid id;
  String name;
  MeasurementSystem measurements;
  Metal metal;
  Pressure workingPressure;
  Weight weight;
  Volume userSetVolume;
  Volume waterVolume;
  bool twinset;
  bool selected;

  CylinderModel.metric(this.id, this.name, this.metal, this.workingPressure,
      this.waterVolume, this.weight, this.twinset, this.selected)
      : measurements = MeasurementSystem.METRIC,
        userSetVolume = waterVolume;

  CylinderModel.imperial(this.id, this.name, this.metal, this.workingPressure,
      this.userSetVolume, this.weight, this.twinset, this.selected)
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
        twinset = d.twinset,
        selected = d.selected;

  CylinderData toData() {
    return CylinderData()
      ..id = id?.toString() ?? ""
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
    final safetyStopL =
        safetyStopDurationMin * sac.liter * 2 * (10 + safetyStopDepth.m) / 10;
    return VolumeLiter(troubleSolvingL + ascentL + safetyStopL);
  }

  Pressure rockBottomPressure({Volume sac, Distance depth}) => PressureBar(
      rockBottom(sac: sac, depth: depth).liter ~/ waterVolume.liter);
}
