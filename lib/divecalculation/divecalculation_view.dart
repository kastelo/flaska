import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprintf/sprintf.dart';

import '../cylinderlist/cylinderlist_bloc.dart';
import '../models/cylinder_model.dart';
import '../models/units.dart';
import 'divecalculation_bloc.dart';
import 'divecalculation_cylinder_view.dart';

class DiveCalculationView extends StatefulWidget {
  @override
  _DiveCalculationViewState createState() => _DiveCalculationViewState();
}

class _DiveCalculationViewState extends State<DiveCalculationView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CylinderListBloc, CylinderListState>(
      builder: (_, cylinderListState) =>
          BlocBuilder<DiveCalculationBloc, DiveCalculationState>(
        builder: (_, diveCalculationState) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            sliders(context, diveCalculationState),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                      rockBottom(context, diveCalculationState),
                    ] +
                    cylinderListState.selectedCylinders
                        .map((c) => cylinder(c, diveCalculationState))
                        .toList() +
                    [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            onPressed: () {
                              context
                                  .read<DiveCalculationBloc>()
                                  .add(SetMetric(!diveCalculationState.metric));
                            },
                            child: Text(diveCalculationState.metric
                                ? "Metric"
                                : "Imperial"),
                          ),
                        ],
                      ),
                    ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget cylinder(CylinderModel c, DiveCalculationState s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DiveCalculationCylinderView(
              cylinder: c,
              rockBottom: s.rockBottom,
              pressure: s.tankPressure,
              metric: s.metric,
            ),
          ),
        ),
      );

  Widget sliders(BuildContext context, DiveCalculationState state) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Table(
        columnWidths: {1: IntrinsicColumnWidth()},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          depthSlider(context, state),
          sacSlider(context, state),
          pressureSlider(context, state),
        ],
      ),
    );
  }

  TableRow pressureSlider(BuildContext context, DiveCalculationState state) {
    return TableRow(children: [
      state.metric
          ? Slider(
              value: state.tankPressure.bar.toDouble(),
              min: 0,
              max: 300,
              divisions: 60,
              onChanged: (v) {
                context
                    .read<DiveCalculationBloc>()
                    .add(SetTankPressure(PressureBar(v.toInt())));
              })
          : Slider(
              value: state.tankPressure.psi.toDouble(),
              min: 0,
              max: 4400,
              divisions: 44 * 2,
              onChanged: (v) {
                context
                    .read<DiveCalculationBloc>()
                    .add(SetTankPressure(PressurePsi(v.toInt())));
              }),
      Text(
        state.metric
            ? sprintf("%d bar", [state.tankPressure.bar])
            : sprintf("%d psi", [state.tankPressure.psi]),
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.caption,
      ),
    ]);
  }

  TableRow depthSlider(BuildContext context, DiveCalculationState state) {
    return TableRow(
      children: [
        state.metric
            ? Slider(
                value: state.depth.m,
                min: 0,
                max: 40,
                divisions: 40,
                onChanged: (v) {
                  context
                      .read<DiveCalculationBloc>()
                      .add(SetDepth(DistanceM(v)));
                })
            : Slider(
                value: state.depth.ft,
                min: 0,
                max: 130,
                divisions: 13 * 2,
                onChanged: (v) {
                  context
                      .read<DiveCalculationBloc>()
                      .add(SetDepth(DistanceFt(v)));
                }),
        Text(
          state.metric
              ? sprintf("%.0f m", [state.depth.m])
              : sprintf("%.0f ft", [state.depth.ft]),
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  TableRow sacSlider(BuildContext context, DiveCalculationState state) {
    return TableRow(
      children: [
        state.metric
            ? Slider(
                value: state.sac.liter,
                min: 5,
                max: 30,
                divisions: 25,
                onChanged: (v) {
                  context
                      .read<DiveCalculationBloc>()
                      .add(SetSAC(VolumeLiter(v)));
                })
            : Slider(
                value: state.sac.cuft,
                min: 0,
                max: 1,
                divisions: 10,
                onChanged: (v) {
                  context
                      .read<DiveCalculationBloc>()
                      .add(SetSAC(VolumeCuFt(v)));
                }),
        Text(
          state.metric
              ? sprintf("%.0f L/min", [state.sac.liter])
              : sprintf("%.1f cuft/min", [state.sac.cuft]),
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  Widget rockBottom(BuildContext context, DiveCalculationState state) {
    final rbg = state.metric
        ? sprintf(
            "Rock bottom gas is %.0f L, based on %.0f min at %.0f m followed by ascent at %.0f m/min (both at %.0f L/min SAC) and %.0f min safety stop at %.0f m (at %.0f L/min SAC).",
            [
                state.rockBottom.volume.liter,
                state.rockBottom.troubleSolvingDurationMin,
                state.rockBottom.depth.m,
                state.rockBottom.ascentRatePerMin.m,
                state.rockBottom.sac.liter * 4,
                state.rockBottom.safetyStopDurationMin,
                state.rockBottom.safetyStopDepth.m,
                state.rockBottom.sac.liter * 2,
              ])
        : sprintf(
            "Rock bottom gas is %.0f cuft, based on %.0f min at %.0f ft followed by ascent at %.0f ft/min (both at %.1f cuft/min SAC) and %.0f min safety stop at %.0f ft (at %.1f cuft/min SAC).",
            [
                state.rockBottom.volume.cuft,
                state.rockBottom.troubleSolvingDurationMin,
                state.rockBottom.depth.m,
                state.rockBottom.ascentRatePerMin.ft,
                state.rockBottom.sac.liter * 4,
                state.rockBottom.safetyStopDurationMin,
                state.rockBottom.safetyStopDepth.m,
                state.rockBottom.sac.liter * 2,
              ]);
    return Text(rbg);
  }
}
