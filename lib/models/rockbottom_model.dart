import 'dart:math';

import 'package:flutter/material.dart';

import '../models/cylinder_model.dart';
import 'units.dart';

class RockBottomModel {
  final Distance depth;
  final Volume sac;
  final Distance ascentRatePerMin;
  final double ascentSacMultiplier;
  final double troubleSolvingDurationMin;
  final double troubleSolvingSacMultiplier;
  final Distance safetyStopDepth;
  final double safetyStopDurationMin;
  final double safetyStopSacMultiplier;

  const RockBottomModel({
    @required this.depth,
    @required this.sac,
    @required this.ascentRatePerMin,
    @required this.ascentSacMultiplier,
    @required this.troubleSolvingDurationMin,
    @required this.troubleSolvingSacMultiplier,
    @required this.safetyStopDepth,
    @required this.safetyStopDurationMin,
    @required this.safetyStopSacMultiplier,
  });

  RockBottomModel copyWith({
    Distance depth,
    Volume sac,
    Distance ascentRatePerMin,
    double ascentSacMultiplier,
    double troubleSolvingDurationMin,
    double troubleSolvingSacMultiplier,
    Distance safetyStopDepth,
    double safetyStopDurationMin,
    double safetyStopSacMultiplier,
  }) =>
      RockBottomModel(
        depth: depth ?? this.depth,
        sac: sac ?? this.sac,
        ascentRatePerMin: ascentRatePerMin ?? this.ascentRatePerMin,
        ascentSacMultiplier: ascentSacMultiplier ?? this.ascentSacMultiplier,
        troubleSolvingDurationMin:
            troubleSolvingDurationMin ?? this.troubleSolvingDurationMin,
        troubleSolvingSacMultiplier:
            troubleSolvingSacMultiplier ?? this.troubleSolvingSacMultiplier,
        safetyStopDepth: safetyStopDepth ?? this.safetyStopDepth,
        safetyStopDurationMin:
            safetyStopDurationMin ?? this.safetyStopDurationMin,
        safetyStopSacMultiplier:
            safetyStopSacMultiplier ?? this.safetyStopSacMultiplier,
      );

  bool get valid =>
      this.depth != null &&
      this.sac != null &&
      this.ascentRatePerMin != null &&
      this.sac.liter > 0 &&
      this.ascentRatePerMin.m > 0;

  double get avgAtm => (10 + depth.m / 2) / 10;

  Volume get volume {
    final depthAtm = (10 + depth.m) / 10;
    final safetyStopAtm = (10 + safetyStopDepth.m) / 10;
    final troubleSolvingL = troubleSolvingDurationMin *
        sac.liter *
        troubleSolvingSacMultiplier *
        depthAtm;
    final ascentL =
        depth.m / ascentRatePerMin.m * sac.liter * ascentSacMultiplier * avgAtm;
    final safetyStopL = safetyStopDurationMin *
        sac.liter *
        safetyStopSacMultiplier *
        safetyStopAtm;
    return VolumeLiter(troubleSolvingL + ascentL + safetyStopL);
  }

  double airtimeUntilRB(CylinderModel cylinder, Pressure pressure) {
    return max(
        0,
        (cylinder.compressedVolume(pressure).liter - volume.liter) /
            sac.liter /
            avgAtm);
  }

  Pressure rockBottomPressure(CylinderModel cylinder) {
    return PressureBar(volume.liter ~/ cylinder.totalWaterVolume.liter);
  }
}
