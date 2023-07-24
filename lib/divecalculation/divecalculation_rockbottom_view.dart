import 'package:flaska/divecalculation/divecalculation_cylinder_view.dart';
import 'package:flaska/proto/proto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'divecalculation_bloc.dart';
import '../models/divecalculation_viewmodel.dart';
import 'valueunit.dart';
import 'foldable.dart';

class RockBottomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final h0 = t.textTheme.titleMedium;
    final h1 = t.textTheme.titleSmall!.copyWith(color: t.disabledColor);
    return BlocBuilder<DiveCalculationBloc, DiveCalculationState>(
      builder: (context, state) {
        final dcvm = DiveCalculationViewModel(state);
        return Foldable(
          id: 'rockbottom',
          title: state.settings.principles == Principles.MINGAS ? Text("MIN GAS CALCULATION", style: h0) : Text("ROCK BOTTOM CALCULATION", style: h0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (dcvm.troubleSolvingVolume.l > 0) Text("TROUBLE SOLVING AT DEPTH", style: h1),
              if (dcvm.troubleSolvingVolume.l > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueUnit(title: "TIME", value: shortNumber(state.settings.troubleSolvingDuration), unit: "min"),
                      ),
                      Expanded(
                        child: ValueUnit(title: "SAC", value: dcvm.troubleSolvingSacLabel, unit: dcvm.sacUnit),
                      ),
                      Expanded(
                        child: ValueUnit(title: "GAS", value: dcvm.troubleSolvingVolumeLabel, unit: dcvm.volumeUnit),
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
                      child: ValueUnit(title: "TIME", value: dcvm.ascentDurationLabel, unit: "min"),
                    ),
                    Expanded(
                      child: ValueUnit(title: "SAC", value: dcvm.ascentSacLabel, unit: dcvm.sacUnit),
                    ),
                    Expanded(
                      child: ValueUnit(title: "GAS", value: dcvm.ascentVolumeLabel, unit: dcvm.volumeUnit),
                    ),
                  ],
                ),
              ),
              if (dcvm.safetyStopVolume.l > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text("SAFETY STOP", style: h1),
                ),
              if (dcvm.safetyStopVolume.l > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueUnit(title: "TIME", value: dcvm.safetyStopDurationLabel, unit: "min"),
                      ),
                      Expanded(
                        child: ValueUnit(title: "SAC", value: dcvm.safetyStopSacLabel, unit: dcvm.sacUnit),
                      ),
                      Expanded(
                        child: ValueUnit(title: "GAS", value: dcvm.safetyStopVolumeLabel, unit: dcvm.volumeUnit),
                      ),
                    ],
                  ),
                ),
              if (dcvm.troubleSolvingVolume.l > 0 || dcvm.safetyStopVolume.l > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text("TOTAL", style: h1),
                ),
              if (dcvm.troubleSolvingVolume.l > 0 || dcvm.safetyStopVolume.l > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueUnit(title: "TIME", value: dcvm.totalDurationLabel, unit: "min"),
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        child: ValueUnit(title: "GAS", value: dcvm.totalVolumeLabel, unit: dcvm.volumeUnit),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
