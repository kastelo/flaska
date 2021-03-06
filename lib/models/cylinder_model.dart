import 'package:flutter_guid/flutter_guid.dart';
import 'package:sprintf/sprintf.dart';

import '../models/rockbottom_model.dart';
import '../proto/proto.dart';
import 'units.dart';
import 'compressibility.dart';

const valveBuyoancyKg = -0.7;
const twinBuyoancyKg = -0.5;

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
            VolumeL.fromPressure(userSetVolume.cuft, workingPressure.psi);

  CylinderModel.fromData(CylinderData d)
      : id = Guid(d.id),
        name = d.name,
        measurements = d.measurements,
        metal = d.metal,
        workingPressure = d.measurements == MeasurementSystem.METRIC
            ? PressureBar(d.workingPressure)
            : PressurePsi(d.workingPressure),
        userSetVolume = d.measurements == MeasurementSystem.METRIC
            ? VolumeL(d.volume)
            : VolumeCuFt(d.volume),
        waterVolume = d.measurements == MeasurementSystem.METRIC
            ? VolumeL(d.volume)
            : VolumeL.fromPressure(d.volume, d.workingPressure.toInt()),
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
          ? userSetVolume.l
          : userSetVolume.cuft
      ..weight =
          measurements == MeasurementSystem.METRIC ? weight.kg : weight.lb
      ..twinset = twinset
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

  double get twinFactor => twinset ? 2 : 1;

  Volume get totalWaterVolume => VolumeL(twinFactor * waterVolume.l);

  Volume compressedVolume(Pressure p) =>
      VolumeL(twinFactor * gasVolumeAtPressure(p, waterVolume).l);

  Weight buoyancy(Pressure p) => WeightKg(
        twinFactor * _externalVolume.l * waterPerL -
            twinFactor * weight.kg +
            twinFactor * valveBuyoancyKg +
            twinBuyoancyKg * (twinFactor - 1) -
            compressedVolume(p).l * airKgPerL,
      );

  Volume get _externalVolume =>
      VolumeL(weight.kg / materialDensity + waterVolume.l);
}

class CylinderViewModel {
  final CylinderModel cylinder;
  final Pressure pressure;
  final RockBottomModel rockBottom;
  final bool metric;
  const CylinderViewModel(
      {this.cylinder, this.pressure, this.rockBottom, this.metric});

  String get description => metric
      ? sprintf("%s (%.01f kg)",
          [cylinder.name, cylinder.twinFactor * cylinder.weight.kg])
      : sprintf("%s (%.01f lb)", [
          cylinder.name,
          cylinder.twinFactor * cylinder.weight.lb,
        ]);

  String get weight => metric
      ? sprintf("%.01f kg", [cylinder.twinFactor * cylinder.weight.kg])
      : sprintf("%.01f lb", [
          cylinder.twinFactor * cylinder.weight.lb,
        ]);

  String get gas => metric
      ? sprintf("%.0f", [
          cylinder.compressedVolume(pressure).l,
        ])
      : sprintf("%.1f", [
          cylinder.compressedVolume(pressure).cuft,
        ]);

  String get volumeUnit => metric ? "L" : "cuft";
  String get pressureUnit => metric ? "bar" : "psi";
  String get weightUnit => metric ? "kg" : "lb";

  String get airtime => sprintf("%.0f", [
        rockBottom.airtimeUntilRB(cylinder, pressure),
      ]);

  String get rbPressure => sprintf("%d", [
        metric
            ? rockBottom.rockBottomPressure(cylinder).bar.roundi(5)
            : rockBottom.rockBottomPressure(cylinder).psi.roundi(100)
      ]);

  String get buoyancyAtPressure => metric
      ? sprintf("%+.01f", [
          cylinder.buoyancy(pressure).kg,
        ])
      : sprintf("%+.01f", [
          cylinder.buoyancy(pressure).lb,
        ]);

  String get buoyancyAtReserve => metric
      ? sprintf("%+.01f", [
          cylinder.buoyancy(rockBottom.rockBottomPressure(cylinder)).kg,
        ])
      : sprintf("%+.01f", [
          cylinder.buoyancy(rockBottom.rockBottomPressure(cylinder)).lb,
        ]);

  String get buoyancyEmpty => metric
      ? sprintf("%+.01f", [
          cylinder.buoyancy(PressureBar(0)).kg,
        ])
      : sprintf("%+.01f", [
          cylinder.buoyancy(PressurePsi(0)).lb,
        ]);
}
