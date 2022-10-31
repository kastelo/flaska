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

  Volume get ascentVolume => VolumeL(depth.m / settings.ascentRate.m * settings.sacRate.l * settings.ascentSacMultiplier * avgAtm);

  Volume get safetyStopVolume => VolumeL(settings.safetyStopDuration * settings.sacRate.l * settings.safetyStopSacMultiplier * safetyStopAtm);

  Volume get volume => troubleSolvingVolume + ascentVolume + safetyStopVolume;

  double airtimeUntilRB(CylinderModel cylinder, Pressure? pressure) {
    return max(0, (cylinder.compressedVolume(pressure).l - volume.l) / settings.sacRate.l / avgAtm);
  }

  Pressure rockBottomPressure(CylinderModel cylinder) {
    return PressureBar(volume.l ~/ cylinder.totalWaterVolume.l);
  }
}
