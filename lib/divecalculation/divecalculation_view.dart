import 'dart:math';

import 'package:flaska/divecalculation/pressureslider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cylinderlist/cylinderlist_bloc.dart';
import '../models/cylinder_model.dart';
import 'divecalculation_bloc.dart';
import 'divecalculation_cylinder_view.dart';
import 'divecalculation_viewmodel.dart';
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
                  child: _PressureSlider(),
                  preferredSize: Size.fromHeight(48),
                )),
            SliverList(
              delegate: SliverChildListDelegate([
                _DepthSlider(),
                RockBottomView(),
              ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate(cylinderListState
                  .selectedCylinders
                  .map((cyl) => cylinder(context, cyl))
                  .toList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget cylinder(BuildContext context, CylinderModel cylinder) =>
      BlocBuilder<DiveCalculationBloc, DiveCalculationState>(
        builder: (context, state) => state.valid
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: DiveCalculationCylinderView(
                  cylinder: cylinder,
                  rockBottom: state.rockBottom,
                  pressure: state.tankPressure,
                  metric: state.metric,
                ),
              )
            : Container(),
      );
}

class _PressureSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiveCalculationBloc, DiveCalculationState>(
        builder: (context, state) {
      if (!state.valid) {
        return Container();
      }
      return PressureSlider(
        value: state.tankPressure,
        withMin: true,
        metric: state.metric,
        onChanged: (pressure) =>
            context.read<DiveCalculationBloc>().add(SetTankPressure(pressure)),
      );
    });
  }
}

class _DepthSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiveCalculationBloc, DiveCalculationState>(
        builder: (context, state) {
      if (!state.valid) {
        return Container();
      }
      final dcvm = DiveCalculationViewModel(state);
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Slider(
                  value: min(dcvm.depth, dcvm.maxDepth),
                  min: 0,
                  max: dcvm.maxDepth,
                  onChanged: (v) {
                    context
                        .read<DiveCalculationBloc>()
                        .add(SetDepth(dcvm.toDistance(v)));
                  }),
            ),
            Text(
              "${dcvm.depthLabel} ${dcvm.distanceUnit}",
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    });
  }
}
