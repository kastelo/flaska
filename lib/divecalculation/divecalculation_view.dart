import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprintf/sprintf.dart';

import '../cylinderlist/cylinderlist_bloc.dart';
import '../models/cylinder_model.dart';
import '../models/units.dart';
import 'divecalculation_bloc.dart';
import 'divecalculation_cylinder_view.dart';

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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Theme.of(context).cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DiveCalculationCylinderView(
                cylinder: cylinder,
                rockBottom: state.rockBottom,
                pressure: state.tankPressure,
                metric: state.metric,
              ),
            ),
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
        dvm.pressureLabel,
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
          dvm.depthLabel,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  Widget rockBottom(BuildContext context) {
    return BlocBuilder<DiveCalculationBloc, DiveCalculationState>(
      builder: (context, state) {
        return Text(DiveCalculationViewModel(state).rockBottomLabel);
      },
    );
  }
}

class DiveCalculationViewModel {
  final DiveCalculationState state;
  const DiveCalculationViewModel(this.state);

  double get depth => state.metric ? state.depth.m : state.depth.ft;
  double get pressure =>
      (state.metric ? state.tankPressure.bar : state.tankPressure.psi)
          .toDouble();
  double get sac => state.metric ? state.sac.liter : state.sac.cuft;

  String get depthLabel => state.metric
      ? sprintf("%.0f m", [state.depth.m])
      : sprintf("%.0f ft", [state.depth.ft]);
  String get pressureLabel => state.metric
      ? sprintf("%d bar", [state.tankPressure.bar])
      : sprintf("%d psi", [state.tankPressure.psi]);
  String get sacLabel => state.metric
      ? sprintf("%.0f L/min", [state.sac.liter])
      : sprintf("%.1f cuft/min", [state.sac.cuft]);

  String get rockBottomLabel => state.metric
      ? sprintf(
          "Rock bottom gas is %.0f L, based on %.0f min at %.0f m (SAC: %.0f L/min) followed by ascent at %.0f m/min (SAC: %.0f L/min) and %.0f min safety stop at %.0f m (SAC: %.0f L/min).",
          [
              state.rockBottom.volume.liter,
              state.rockBottom.troubleSolvingDurationMin,
              state.rockBottom.depth.m,
              state.rockBottom.sac.liter *
                  state.rockBottom.troubleSolvingSacMultiplier,
              state.rockBottom.ascentRatePerMin.m,
              state.rockBottom.sac.liter * state.rockBottom.ascentSacMultiplier,
              state.rockBottom.safetyStopDurationMin,
              state.rockBottom.safetyStopDepth.m,
              state.rockBottom.sac.liter *
                  state.rockBottom.safetyStopSacMultiplier,
            ])
      : sprintf(
          "Rock bottom gas is %.0f cuft, based on %.0f min at %.0f ft (SAC: %.1f cuft/minC) followed by ascent at %.0f ft/min (SAC: %.1f cuft/min) and %.0f min safety stop at %.0f ft (SAC: %.1f cuft/min).",
          [
              state.rockBottom.volume.cuft,
              state.rockBottom.troubleSolvingDurationMin,
              state.rockBottom.depth.m,
              state.rockBottom.sac.cuft *
                  state.rockBottom.troubleSolvingSacMultiplier,
              state.rockBottom.ascentRatePerMin.ft,
              state.rockBottom.sac.cuft * state.rockBottom.ascentSacMultiplier,
              state.rockBottom.safetyStopDurationMin,
              state.rockBottom.safetyStopDepth.m,
              state.rockBottom.sac.cuft *
                  state.rockBottom.safetyStopSacMultiplier,
            ]);

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
