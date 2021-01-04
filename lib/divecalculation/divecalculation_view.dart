import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprintf/sprintf.dart';

import '../cylinderlist/cylinderlist_bloc.dart';
import '../models/cylinder_model.dart';
import '../models/units.dart';
import 'divecalculation_bloc.dart';
import 'divecalculation_cylinder_view.dart';
import 'valueunit.dart';

class DiveCalculationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CylinderListBloc, CylinderListState>(
      builder: (context, cylinderListState) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          sliders(context),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                    rockBottom(context),
                  ] +
                  cylinderListState.selectedCylinders
                      .map((cyl) => cylinder(context, cyl))
                      .toList(),
            ),
          ),
        ]),
      ),
    );
  }

  Widget cylinder(BuildContext context, CylinderModel cylinder) =>
      BlocBuilder<DiveCalculationBloc, DiveCalculationState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: DiveCalculationCylinderView(
            cylinder: cylinder,
            rockBottom: state.rockBottom,
            pressure: state.tankPressure,
            metric: state.metric,
          ),
        ),
      );

  Widget sliders(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: BlocBuilder<DiveCalculationBloc, DiveCalculationState>(
          builder: (context, state) {
        final dvm = DiveCalculationViewModel(state);
        return Table(
          columnWidths: {1: IntrinsicColumnWidth()},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            depthSlider(context, dvm),
            pressureSlider(context, dvm),
          ],
        );
      }),
    );
  }

  TableRow pressureSlider(BuildContext context, DiveCalculationViewModel dvm) {
    return TableRow(children: [
      Slider(
          value: dvm.pressure,
          min: 0,
          max: dvm.maxPressure,
          onChanged: (v) {
            context
                .read<DiveCalculationBloc>()
                .add(SetTankPressure(dvm.toPressure(v)));
          }),
      Text(
        "${dvm.pressureLabel} ${dvm.pressureUnit}",
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.caption,
      ),
    ]);
  }

  TableRow depthSlider(BuildContext context, DiveCalculationViewModel dvm) {
    return TableRow(
      children: [
        Slider(
            value: dvm.depth,
            min: 0,
            max: dvm.maxDepth,
            onChanged: (v) {
              context
                  .read<DiveCalculationBloc>()
                  .add(SetDepth(dvm.toDistance(v)));
            }),
        Text(
          "${dvm.depthLabel} ${dvm.distanceUnit}",
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  Widget rockBottom(BuildContext context) {
    final t = Theme.of(context);
    final h0 = t.textTheme.subtitle1;
    final h1 = t.textTheme.subtitle2.copyWith(color: t.disabledColor);
    return BlocBuilder<DiveCalculationBloc, DiveCalculationState>(
      builder: (context, state) {
        final cvm = DiveCalculationViewModel(state);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("ROCK BOTTOM CALCULATION", style: h0),
                Divider(),
                Text("TROUBLE SOLVING AT DEPTH", style: h1),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueUnit(
                            title: "DEPTH",
                            value: cvm.depthLabel,
                            unit: cvm.distanceUnit),
                      ),
                      Expanded(
                        child: ValueUnit(
                            title: "TIME",
                            value: state.rockBottom.troubleSolvingDurationMin
                                .toString(),
                            unit: "min"),
                      ),
                      Expanded(
                        child: ValueUnit(
                            title: "SAC",
                            value: cvm.troubleSolvingSacLabel,
                            unit: cvm.sacUnit),
                      ),
                      Expanded(
                        child: ValueUnit(
                            title: "VOL",
                            value: cvm.troubleSolvingVolumeLabel,
                            unit: cvm.volumeUnit),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text("ASCENT", style: h1),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueUnit(
                            title: "AVG DEPTH",
                            value: cvm.ascentAverageDepthLabel,
                            unit: cvm.distanceUnit),
                      ),
                      Expanded(
                        child: ValueUnit(
                            title: "TIME",
                            value: cvm.ascentDurationLabel,
                            unit: "min"),
                      ),
                      Expanded(
                        child: ValueUnit(
                            title: "SAC",
                            value: cvm.ascentSacLabel,
                            unit: cvm.sacUnit),
                      ),
                      Expanded(
                        child: ValueUnit(
                            title: "VOL",
                            value: cvm.ascentVolumeLabel,
                            unit: cvm.volumeUnit),
                      ),
                    ],
                  ),
                ),
                if (cvm.safetyStopVolume.liter > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text("SAFETY STOP", style: h1),
                  ),
                if (cvm.safetyStopVolume.liter > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ValueUnit(
                              title: "DEPTH",
                              value: cvm.safetyStopDepthLabel,
                              unit: cvm.distanceUnit),
                        ),
                        Expanded(
                          child: ValueUnit(
                              title: "TIME",
                              value: cvm.safetyStopDurationLabel,
                              unit: "min"),
                        ),
                        Expanded(
                          child: ValueUnit(
                              title: "SAC",
                              value: cvm.safetyStopSacLabel,
                              unit: cvm.sacUnit),
                        ),
                        Expanded(
                          child: ValueUnit(
                              title: "VOL",
                              value: cvm.safetyStopVolumeLabel,
                              unit: cvm.volumeUnit),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text("TOTAL", style: h1),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        child: ValueUnit(
                            title: "TIME",
                            value: cvm.totalDurationLabel,
                            unit: "min"),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        child: ValueUnit(
                            title: "VOL",
                            value: cvm.totalVolumeLabel,
                            unit: cvm.volumeUnit),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

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
      : sprintf("%.1f", [troubleSolvingVolume..cuft]);

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
