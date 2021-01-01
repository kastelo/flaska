import 'package:flaska/models/rockbottom_model.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:sprintf/sprintf.dart';

import '../proto/proto.dart';
import 'units.dart';

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

  double get _twinFactor => twinset ? 2 : 1;

  Volume get totalWaterVolume => VolumeLiter(_twinFactor * waterVolume.liter);

  Volume compressedVolume(Pressure p) =>
      VolumeLiter(_twinFactor * waterVolume.liter * equivalentPressure(p).bar);

  Weight buoyancy(Pressure p) => WeightKg(externalVolume.liter * waterPerL -
      weight.kg +
      valveBuyoancyKg +
      twinBuyoancyKg * (_twinFactor - 1) -
      equivalentPressure(p).bar * waterVolume.liter * airKgPerL);

  Volume get externalVolume =>
      VolumeLiter(weight.kg / materialDensity + waterVolume.liter);
}

class CylinderViewModel {
  final CylinderModel cylinder;
  final Pressure pressure;
  final RockBottomModel rockBottom;
  final bool metric;
  const CylinderViewModel(
      {this.cylinder, this.pressure, this.rockBottom, this.metric});

  String get description => metric
      ? sprintf("%s (%.01f kg)", [cylinder.name, cylinder.weight.kg])
      : sprintf("%s (%.01f lb)", [
          cylinder.name,
          cylinder.weight.lb,
        ]);

  String get gas => metric
      ? sprintf("%.0f L air at %d bar", [
          cylinder.compressedVolume(pressure).liter,
          pressure.bar,
        ])
      : sprintf("%.1f cuft air at %d psi", [
          cylinder.compressedVolume(pressure).cuft,
          pressure.psi,
        ]);

  String get airtime => metric
      ? sprintf("%.0f min to %d bar (RB)", [
          rockBottom.airtimeUntilRB(cylinder, pressure),
          rockBottom.rockBottomPressure(cylinder).bar.roundi(5)
        ])
      : sprintf("%.0f min to %d psi (RB)", [
          rockBottom.airtimeUntilRB(cylinder, pressure),
          rockBottom.rockBottomPressure(cylinder).psi.roundi(100)
        ]);

  String get buoyancy => metric
      ? sprintf("%+.01f kg at %d bar\n(%+.01f kg empty)", [
          cylinder.buoyancy(pressure).kg,
          pressure.bar,
          cylinder.buoyancy(PressureBar(0)).kg,
        ])
      : sprintf("%+.01f lb at %d psi\n(%+.01f lb empty)", [
          cylinder.buoyancy(pressure).lb,
          pressure.psi,
          cylinder.buoyancy(PressurePsi(0)).lb,
        ]);
}

extension Rounding on int {
  int roundi(int intv) {
    return (this + intv - 1) ~/ intv * intv;
  }
}
