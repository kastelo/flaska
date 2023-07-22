import 'dart:math';

import '../models/cylinder_model.dart';
import '../proto/proto.dart';
import 'units.dart';

class RockBottomModel {
  final Distance depth;
  final SettingsData settings;
  final Pressure tankPressure;

  const RockBottomModel({
    required this.depth,
    required this.settings,
    required this.tankPressure,
  });

  RockBottomModel.fromSettings(SettingsData settings, Distance depth, Pressure tankPressure)
      : settings = settings,
        depth = depth,
        tankPressure = tankPressure;

  RockBottomModel copyWith({
    Distance? depth,
    SettingsData? settings,
    Pressure? tankPressure,
  }) =>
      RockBottomModel(
        depth: depth ?? this.depth,
        settings: settings ?? this.settings,
        tankPressure: tankPressure ?? this.tankPressure,
      );

  double get avgAtm => (10 + depth.m / 2) / 10;
  double get depthAtm => (10 + depth.m) / 10;
  double get safetyStopAtm => (10 + settings.safetyStopDepth.m) / 10;

  Volume get troubleSolvingVolume {
    // Min gas trouble solving is calculated at the average depth for simplicity.
    if (settings.principles == Principles.MINGAS) {
      return VolumeL(settings.troubleSolvingDuration * settings.sacRate.l * settings.troubleSolvingSacMultiplier * avgAtm);
    }
    return VolumeL(settings.troubleSolvingDuration * settings.sacRate.l * settings.troubleSolvingSacMultiplier * depthAtm);
  }

  double get ascentDuration => (depth.m / settings.ascentRate.m).ceilToDouble();

  Volume get ascentVolume => VolumeL(ascentDuration * settings.sacRate.l * settings.ascentSacMultiplier * avgAtm);

  Volume get safetyStopVolume => VolumeL(settings.safetyStopDuration * settings.sacRate.l * settings.safetyStopSacMultiplier * safetyStopAtm);

  Volume get volume => troubleSolvingVolume + ascentVolume + safetyStopVolume;

  double airtimeUntilRB(CylinderModel cylinder, Pressure? pressure) {
    // The rock bottom pressue may be rounded and not below a certain
    // minimum, so we use this to calculate the actual volume.
    final volL = rockBottomPressure(cylinder).bar * cylinder.totalWaterVolume.l;
    return max(0, (cylinder.compressedVolume(pressure).l - volL) / settings.sacRate.l / depthAtm);
  }

  Pressure rockBottomPressure(CylinderModel cylinder) {
    var pBar = volume.l ~/ cylinder.totalWaterVolume.l;
    if (settings.principles == Principles.MINGAS && pBar < 40) pBar = 40;
    return PressureBar(pBar);
  }

  Volume usableGas(CylinderModel cylinder) {
    return cylinder.compressedVolume(tankPressure) - volume;
  }

  Volume turnVolume(CylinderModel cylinder) {
    var usable = usableGas(cylinder);
    switch (settings.usableGas) {
      case UsableGas.ALL_USABLE:
        break;
      case UsableGas.HALVES:
        usable = VolumeL(usable.l / 2);
        break;
      case UsableGas.THIRDS:
        usable = VolumeL(usable.l / 3);
        break;
    }
    return cylinder.compressedVolume(tankPressure) - usable;
  }

  Pressure turnPressure(CylinderModel cylinder) {
    return PressureBar(turnVolume(cylinder).l ~/ cylinder.totalWaterVolume.l);
  }

  double airtimeUntilTurn(CylinderModel cylinder, Pressure? pressure) {
    return max(0, (cylinder.compressedVolume(pressure).l - turnVolume(cylinder).l) / settings.sacRate.l / depthAtm);
  }
}
