import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cylinderlist/cylinderlist_bloc.dart';
import '../divecalculation/pressureslider.dart';
import '../models/cylinder_model.dart';
import '../models/units.dart';
import 'depthslider.dart';
import 'divecalculation_bloc.dart';
import 'divecalculation_cylinder_view.dart';
import 'divecalculation_rockbottom_view.dart';

class DiveCalculationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CylinderListBloc, CylinderListState>(
      builder: (context, cylinderListState) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
                title: Text("Dive Calculator"),
                pinned: true,
                floating: true,
                bottom: PreferredSize(
                  child: Column(
                    children: [
                      _PressureSlider(),
                      _DepthSlider(),
                    ],
                  ),
                  preferredSize: Size.fromHeight(96),
                )),
            SliverList(
              delegate: SliverChildListDelegate([RockBottomView()]),
            ),
            SliverList(
              delegate: SliverChildListDelegate(cylinderListState.selectedCylinders.map((cyl) => cylinder(context, cyl)).toList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget cylinder(BuildContext context, CylinderModel cylinder) => BlocBuilder<DiveCalculationBloc, DiveCalculationState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: DiveCalculationCylinderView(
            principles: state.settings.principles,
            cylinder: cylinder,
            rockBottom: state.rockBottom,
            pressure: state.tankPressure,
            metric: state.metric,
            hideNDLNotice: state.settings.hideNdlNotice,
            usableGas: state.settings.usableGas,
          ),
        ),
      );
}

class _PressureSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiveCalculationBloc, DiveCalculationState>(builder: (context, state) {
      return PressureSlider(
        value: state.tankPressure,
        minValue: state.settings.minPressure,
        maxValue: state.settings.maxPressure,
        step: state.settings.pressureStep,
        metric: state.metric,
        onChanged: (pressure) => context.read<DiveCalculationBloc>().add(SetTankPressure(pressure)),
      );
    });
  }
}

class _DepthSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiveCalculationBloc, DiveCalculationState>(builder: (context, state) {
      return DepthSlider(
        value: state.depth,
        metric: state.metric,
        onChanged: (depth) => context.read<DiveCalculationBloc>().add(SetDepth(depth)),
        minValue: state.settings.minDepth,
        maxValue: state.settings.maxDepth,
        gradual: true,
      );
    });
  }
}
