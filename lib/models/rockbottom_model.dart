import 'dart:math';

import '../proto/proto.dart';
import '../settings/settings_bloc.dart';
import 'package:flutter/material.dart';

import '../models/cylinder_model.dart';
import 'units.dart';

class RockBottomModel {
  final Distance depth;
  final SettingsData settings;

  const RockBottomModel({
    @required this.depth,
    @required this.settings,
  });

  RockBottomModel.fromSettings(SettingsData settings, Distance depth)
      : settings = settings,
        depth = depth;

  RockBottomModel copyWith({
    Distance depth,
    SettingsData settings,
  }) =>
      RockBottomModel(
        depth: depth ?? this.depth,
        settings: settings ?? this.settings,
      );

  bool get valid => this.depth != null && this.settings != null;

  double get avgAtm => (10 + depth.m / 2) / 10;

  Volume get volume {
    final depthAtm = (10 + depth.m) / 10;
    final safetyStopAtm = (10 + settings.safetyStopDepth.m) / 10;
    final troubleSolvingL = settings.troubleSolvingDuration *
        settings.sacRate.liter *
        settings.troubleSolvingSacMultiplier *
        depthAtm;
    final ascentL = depth.m /
        settings.ascentRate.m *
        settings.sacRate.liter *
        settings.ascentSacMultiplier *
        avgAtm;
    final safetyStopL = settings.safetyStopDuration *
        settings.sacRate.liter *
        settings.safetyStopSacMultiplier *
        safetyStopAtm;
    return VolumeLiter(troubleSolvingL + ascentL + safetyStopL);
  }

  double airtimeUntilRB(CylinderModel cylinder, Pressure pressure) {
    return max(
        0,
        (cylinder.compressedVolume(pressure).liter - volume.liter) /
            settings.sacRate.liter /
            avgAtm);
  }

  Pressure rockBottomPressure(CylinderModel cylinder) {
    return PressureBar(volume.liter ~/ cylinder.totalWaterVolume.liter);
  }
}
