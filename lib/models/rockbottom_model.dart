import 'package:flaska/models/cylinder_model.dart';

import 'units.dart';

class RockBottomModel {
  Volume sac;
  Distance depth;
  Distance safetyStopDepth;
  Distance ascentRatePerMin;
  double safetyStopDurationMin;
  double troubleSolvingDurationMin;

  RockBottomModel({
    this.depth,
    this.sac,
    this.ascentRatePerMin,
    this.troubleSolvingDurationMin,
    this.safetyStopDepth,
    this.safetyStopDurationMin,
  });

  double get avgAtm => (10 + depth.m / 2) / 10;

  Volume get volume {
    final depthAtm = (10 + depth.m) / 10;
    final safetyStopAtm = (10 + safetyStopDepth.m) / 10;
    final troubleSolvingL =
        troubleSolvingDurationMin * sac.liter * 4 * depthAtm;
    final ascentL = depth.m / ascentRatePerMin.m * sac.liter * 4 * avgAtm;
    final safetyStopL = safetyStopDurationMin * sac.liter * 2 * safetyStopAtm;
    return VolumeLiter(troubleSolvingL + ascentL + safetyStopL);
  }

  double airtimeUntilRB(CylinderModel cylinder, Pressure pressure) {
    return cylinder.compressedVolume(pressure).liter / sac.liter / avgAtm;
  }

  Pressure rockBottomPressure(CylinderModel cylinder) {
    return PressureBar(volume.liter ~/ cylinder.waterVolume.liter);
  }
}
