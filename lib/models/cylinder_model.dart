import 'dart:math';

import 'package:uuid/uuid.dart';

import '../proto/proto.dart';
import 'compressibility.dart';
import 'units.dart';

const valveBuyoancyKg = -0.7;
const twinBuyoancyKg = -0.5;
const valveWeightKg = 0.8; // a single valve
const twinWeightKg = 0.6 + 0.8; // manifold and bands

class CylinderModel {
  UuidValue id;
  String name;
  MeasurementSystem measurements;
  Metal metal;
  Pressure workingPressure;
  Weight weight;
  Volume userSetVolume;
  Volume waterVolume;
  bool twinset;
  bool selected;
  bool overfill;

  CylinderModel.metric(this.id, this.name, this.metal, this.workingPressure, this.waterVolume, this.weight, this.twinset, this.selected, this.overfill)
      : measurements = MeasurementSystem.METRIC,
        userSetVolume = waterVolume;

  CylinderModel.imperial(this.id, this.name, this.metal, this.workingPressure, this.userSetVolume, this.weight, this.twinset, this.selected, this.overfill)
      : measurements = MeasurementSystem.IMPERIAL,
        waterVolume = VolumeL.fromPressure(userSetVolume.cuft, workingPressure.psi);

  CylinderModel.fromData(CylinderData d)
      : id = UuidValue(d.id),
        name = d.name,
        measurements = d.measurements,
        metal = d.metal,
        workingPressure = d.measurements == MeasurementSystem.METRIC ? PressureBar(d.workingPressure) : PressurePsi(d.workingPressure),
        userSetVolume = d.measurements == MeasurementSystem.METRIC ? VolumeL(d.volume) : VolumeCuFt(d.volume),
        waterVolume = d.measurements == MeasurementSystem.METRIC ? VolumeL(d.volume) : VolumeL.fromPressure(d.volume, d.workingPressure.toInt()),
        weight = d.measurements == MeasurementSystem.METRIC ? WeightKg(d.weight) : WeightLb(d.weight),
        twinset = d.twinset,
        selected = d.selected,
        overfill = d.overfill;

  CylinderData toData() {
    return CylinderData()
      ..id = id.toString()
      ..name = name
      ..measurements = measurements
      ..metal = metal
      ..workingPressure = measurements == MeasurementSystem.METRIC ? workingPressure.bar : workingPressure.psi
      ..volume = measurements == MeasurementSystem.METRIC ? userSetVolume.l : userSetVolume.cuft
      ..weight = measurements == MeasurementSystem.METRIC ? weight.kg : weight.lb
      ..twinset = twinset
      ..selected = selected
      ..overfill = overfill;
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

  double get twinFactor => twinset ? 2 : 1;

  Volume get totalWaterVolume => VolumeL(twinFactor * waterVolume.l);

  Pressure? pressure(Pressure? p) {
    if (overfill) return p;
    if (measurements == MeasurementSystem.METRIC) return PressureBar(min(p!.bar, workingPressure.bar));
    return PressurePsi(min(p!.psi, workingPressure.psi));
  }

  Volume compressedVolume(Pressure? p) => VolumeL(twinFactor * gasVolumeAtPressure(pressure(p)!, waterVolume).l);
  Volume get nominalVolume => gasVolumeAtPressure(pressure(workingPressure)!, waterVolume);

  Weight buoyancy(Pressure? p) => WeightKg(
        twinFactor * _externalVolume.l * waterPerL -
            twinFactor * weight.kg +
            twinFactor * valveBuyoancyKg +
            twinBuyoancyKg * (twinFactor - 1) -
            compressedVolume(pressure(p)).l * airKgPerL,
      );

  Weight dryWeight(Pressure? p) => WeightKg(
        twinFactor * weight.kg + twinFactor * valveWeightKg + twinWeightKg * (twinFactor - 1) + compressedVolume(pressure(p)).l * airKgPerL,
      );

  Volume get _externalVolume => VolumeL(weight.kg / materialDensity + waterVolume.l);
}
