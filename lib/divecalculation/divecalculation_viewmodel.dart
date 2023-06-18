import 'package:sprintf/sprintf.dart';

import '../models/units.dart';
import 'divecalculation_bloc.dart';

class DiveCalculationViewModel {
  final DiveCalculationState state;
  const DiveCalculationViewModel(this.state);

  String get distanceUnit => state.metric ? "m" : "ft";
  String get sacUnit => state.metric ? "L/min" : "cuft/min";
  String get volumeUnit => state.metric ? "L" : "cuft";
  String get pressureUnit => state.metric ? "bar" : "psi";

  double get depth => state.metric ? state.depth.m : state.depth.ft;
  double get pressure => (state.metric ? state.tankPressure.bar : state.tankPressure.psi).toDouble();
  double get sac => state.metric ? state.settings.sacRate.l : state.settings.sacRate.cuft;

  String get troubleSolvingSacLabel => state.metric
      ? sprintf("%.0f", [state.settings.troubleSolvingSacMultiplier * state.settings.sacRate.l])
      : sprintf("%.1f", [state.settings.troubleSolvingSacMultiplier * state.settings.sacRate.cuft]);

  Volume get troubleSolvingVolume => state.rockBottom.troubleSolvingVolume;
  String get troubleSolvingVolumeLabel => state.metric ? sprintf("%.0f", [troubleSolvingVolume.l]) : sprintf("%.1f", [troubleSolvingVolume.cuft]);

  String get depthLabel => state.metric ? sprintf("%.0f", [state.depth.m]) : sprintf("%.0f", [state.depth.ft]);

  Distance get ascentAverageDepth => DistanceM(state.depth.m / 2);
  String get ascentAverageDepthLabel => state.metric ? sprintf("%.0f", [ascentAverageDepth.m]) : sprintf("%.0f", [ascentAverageDepth.ft]);

  String get ascentDurationLabel => sprintf("%.1f", [state.rockBottom.ascentDuration]);

  Volume get ascentSac => VolumeL(state.settings.ascentSacMultiplier * state.settings.sacRate.l);
  String get ascentSacLabel => state.metric ? sprintf("%.0f", [ascentSac.l]) : sprintf("%.1f", [ascentSac.cuft]);

  Volume get ascentVolume => state.rockBottom.ascentVolume;
  String get ascentVolumeLabel => state.metric ? sprintf("%.0f", [ascentVolume.l]) : sprintf("%.1f", [ascentVolume.cuft]);

  String get safetyStopDepthLabel => state.metric ? sprintf("%.0f", [state.settings.safetyStopDepth.m]) : sprintf("%.0f", [state.settings.safetyStopDepth.ft]);

  String get safetyStopDurationLabel => sprintf("%.1f", [state.settings.safetyStopDuration]);

  Volume get safetyStopSac => VolumeL(state.settings.safetyStopSacMultiplier * state.settings.sacRate.l);
  String get safetyStopSacLabel => state.metric ? sprintf("%.0f", [safetyStopSac.l]) : sprintf("%.1f", [safetyStopSac.cuft]);

  Volume get safetyStopVolume => state.rockBottom.safetyStopVolume;
  String get safetyStopVolumeLabel => state.metric ? sprintf("%.0f", [safetyStopVolume.l]) : sprintf("%.1f", [safetyStopVolume.cuft]);

  double get totalDuration =>
      state.settings.ascentRate.m == 0 ? 0 : state.settings.troubleSolvingDuration + state.settings.safetyStopDuration + state.rockBottom.ascentDuration;
  String get totalDurationLabel => sprintf("%.1f", [totalDuration]);

  Volume get totalVolume => state.rockBottom.volume;
  String get totalVolumeLabel => state.metric ? sprintf("%.0f", [totalVolume.l]) : sprintf("%.1f", [totalVolume.cuft]);

  String get pressureLabel => state.metric ? sprintf("%d", [state.tankPressure.bar]) : sprintf("%d", [state.tankPressure.psi]);
  String get sacLabel => state.metric ? sprintf("%.0f", [state.settings.sacRate.l]) : sprintf("%.1f", [state.settings.sacRate.cuft]);

  double get maxSAC => state.metric ? 30 : 1;

  Distance toDistance(double value) => state.metric ? DistanceM(value) : DistanceFt(value);
  Pressure toPressure(double value) => state.metric ? PressureBar(value.toInt()) : PressurePsi(value.toInt());
  Volume toVolume(double value) => state.metric ? VolumeL(value) : VolumeCuFt(value);
}
