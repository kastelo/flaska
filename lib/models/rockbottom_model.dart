import 'dart:math';

import '../models/cylinder_model.dart';
import '../proto/proto.dart';
import 'units.dart';

class RockBottomModel {
  final Distance depth;
  final SettingsData settings;

  const RockBottomModel({
    required this.depth,
    required this.settings,
  });

  RockBottomModel.fromSettings(SettingsData settings, Distance depth)
      : settings = settings,
        depth = depth;

  RockBottomModel copyWith({
    Distance? depth,
    SettingsData? settings,
  }) =>
      RockBottomModel(
        depth: depth ?? this.depth,
        settings: settings ?? this.settings,
      );

  double get avgAtm => (10 + depth.m / 2) / 10;
  double get depthAtm => (10 + depth.m) / 10;
  double get safetyStopAtm => (10 + settings.safetyStopDepth.m) / 10;

  Volume get troubleSolvingVolume => VolumeL(settings.troubleSolvingDuration * settings.sacRate.l * settings.troubleSolvingSacMultiplier * depthAtm);

  double get ascentDuration {
    if (settings.principles == Principles.ROCKBOTTOM) return depth.m / settings.ascentRate.m;
    // GUE ascent, 9 m/min to half depth, then 3 m/min
    final initialMinutes = (depth.m / 2 / 9).ceil();
    final secondMinutes = (depth.m / 2 / 3).ceil();
    return (initialMinutes + secondMinutes).toDouble();
  }

  Volume get ascentVolume {
    if (settings.principles == Principles.ROCKBOTTOM)
      return VolumeL(depth.m / settings.ascentRate.m * settings.sacRate.l * settings.ascentSacMultiplier * avgAtm);

    // GUE ascent, 9 m/min to half depth, then 3 m/min
    final initialAtm = (10 + depth.m / 4 * 3) / 10;
    final initialMinutes = (depth.m / 2 / 9).ceil();
    final initialVolume = VolumeL(initialMinutes * settings.sacRate.l * settings.ascentSacMultiplier * initialAtm);
    final secondAtm = (10 + depth.m / 4) / 10;
    final secondMinutes = (depth.m / 2 / 3).ceil();
    final secondVolume = VolumeL(secondMinutes * settings.sacRate.l * settings.ascentSacMultiplier * secondAtm);
    return initialVolume + secondVolume;
  }

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
}
