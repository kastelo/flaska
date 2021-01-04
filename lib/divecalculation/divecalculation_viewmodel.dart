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
  double get pressure =>
      (state.metric ? state.tankPressure.bar : state.tankPressure.psi)
          .toDouble();
  double get sac => state.metric ? state.sac.liter : state.sac.cuft;

  String get troubleSolvingSacLabel => state.metric
      ? sprintf("%.0f",
          [state.rockBottom.troubleSolvingSacMultiplier * state.sac.liter])
      : sprintf("%.1f",
          [state.rockBottom.troubleSolvingSacMultiplier * state.sac.cuft]);

  Volume get troubleSolvingVolume =>
      VolumeLiter(state.rockBottom.troubleSolvingDurationMin *
          state.rockBottom.troubleSolvingSacMultiplier *
          state.sac.liter *
          (state.depth.m + 10) /
          10);
  String get troubleSolvingVolumeLabel => state.metric
      ? sprintf("%.0f", [troubleSolvingVolume.liter])
      : sprintf("%.1f", [troubleSolvingVolume.cuft]);

  String get depthLabel => state.metric
      ? sprintf("%.0f", [state.depth.m])
      : sprintf("%.0f", [state.depth.ft]);

  Distance get ascentAverageDepth => DistanceM(state.depth.m / 2);
  String get ascentAverageDepthLabel => state.metric
      ? sprintf("%.0f", [ascentAverageDepth.m])
      : sprintf("%.0f", [ascentAverageDepth.ft]);

  double get ascentDuration =>
      state.depth.m / state.rockBottom.ascentRatePerMin.m;
  String get ascentDurationLabel => sprintf("%.1f", [ascentDuration]);

  Volume get ascentSac =>
      VolumeLiter(state.rockBottom.ascentSacMultiplier * state.sac.liter);
  String get ascentSacLabel => state.metric
      ? sprintf("%.0f", [ascentSac.liter])
      : sprintf("%.1f", [ascentSac.cuft]);

  Volume get ascentVolume => VolumeLiter(state.depth.m /
      state.rockBottom.ascentRatePerMin.m *
      state.rockBottom.ascentSacMultiplier *
      state.sac.liter *
      (state.depth.m / 2 + 10) /
      10);
  String get ascentVolumeLabel => state.metric
      ? sprintf("%.0f", [ascentVolume.liter])
      : sprintf("%.1f", [ascentVolume.cuft]);

  String get safetyStopDepthLabel => state.metric
      ? sprintf("%.0f", [state.rockBottom.safetyStopDepth.m])
      : sprintf("%.0f", [state.rockBottom.safetyStopDepth.ft]);

  String get safetyStopDurationLabel =>
      sprintf("%.1f", [state.rockBottom.safetyStopDurationMin]);

  Volume get safetyStopSac =>
      VolumeLiter(state.rockBottom.safetyStopSacMultiplier * state.sac.liter);
  String get safetyStopSacLabel => state.metric
      ? sprintf("%.0f", [safetyStopSac.liter])
      : sprintf("%.1f", [safetyStopSac.cuft]);

  Volume get safetyStopVolume =>
      VolumeLiter(state.rockBottom.safetyStopDurationMin *
          state.rockBottom.ascentSacMultiplier *
          state.sac.liter *
          (state.rockBottom.safetyStopDepth.m / 2 + 10) /
          10);
  String get safetyStopVolumeLabel => state.metric
      ? sprintf("%.0f", [safetyStopVolume.liter])
      : sprintf("%.1f", [safetyStopVolume.cuft]);

  double get totalDuration =>
      state.rockBottom.troubleSolvingDurationMin +
      state.rockBottom.safetyStopDurationMin +
      state.depth.m / state.rockBottom.ascentRatePerMin.m;
  String get totalDurationLabel => sprintf("%.1f", [totalDuration]);

  Volume get totalVolume => VolumeLiter(
      troubleSolvingVolume.liter + ascentVolume.liter + safetyStopVolume.liter);
  String get totalVolumeLabel => state.metric
      ? sprintf("%.0f", [totalVolume.liter])
      : sprintf("%.1f", [totalVolume.cuft]);

  String get pressureLabel => state.metric
      ? sprintf("%d", [state.tankPressure.bar])
      : sprintf("%d", [state.tankPressure.psi]);
  String get sacLabel => state.metric
      ? sprintf("%.0f", [state.sac.liter])
      : sprintf("%.1f", [state.sac.cuft]);

  double get maxDepth => state.metric ? 40 : 130;
  double get maxPressure => state.metric ? 300 : 4000;
  double get maxSAC => state.metric ? 30 : 1;

  Distance toDistance(double value) =>
      state.metric ? DistanceM(value) : DistanceFt(value);
  Pressure toPressure(double value) =>
      state.metric ? PressureBar(value.toInt()) : PressurePsi(value.toInt());
  Volume toVolume(double value) =>
      state.metric ? VolumeLiter(value) : VolumeCuFt(value);
}
