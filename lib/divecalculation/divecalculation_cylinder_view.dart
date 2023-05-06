import 'package:flutter/material.dart';

import '../models/cylinder_model.dart';
import '../models/rockbottom_model.dart';
import '../models/units.dart';
import 'valueunit.dart';
import 'foldable.dart';

class DiveCalculationCylinderView extends StatelessWidget {
  final CylinderModel cylinder;
  final RockBottomModel rockBottom;
  final Pressure pressure;
  final bool metric;

  DiveCalculationCylinderView({
    required this.cylinder,
    required this.rockBottom,
    required this.pressure,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    final cvm = CylinderViewModel(
      cylinder: cylinder,
      pressure: pressure,
      rockBottom: rockBottom,
      metric: metric,
    );

    final t = Theme.of(context);
    final h0 = t.textTheme.titleMedium;
    final h1 = t.textTheme.titleSmall!.copyWith(color: t.disabledColor);
    return Foldable(
      id: cylinder.id.toString(),
      title: Row(
        children: [
          Expanded(child: Text("${cvm.cylinder!.name} @ ${cvm.cylinder!.pressure(pressure)}", style: h0)),
          if (!metric)
            Text(
              "${cvm.cylinder!.waterVolume.l.toStringAsFixed(1)} L",
              style: h1,
              textAlign: TextAlign.right,
            ),
          if (metric)
            Text(
              "${cvm.cylinder!.nominalVolume.cuft.toStringAsFixed(1)} cuft",
              style: h1,
              textAlign: TextAlign.right,
            ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              cvm.weight!,
              style: h1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: ValueUnit(
                    title: "GAS",
                    value: cvm.gas!,
                    unit: cvm.volumeUnit,
                  ),
                ),
                Expanded(
                  child: ValueUnit(
                    title: "GAS TIME",
                    value: cvm.airtime!,
                    unit: "min",
                  ),
                ),
                Expanded(
                  child: ValueUnit(
                    title: "RB",
                    value: cvm.rbPressure!,
                    unit: cvm.pressureUnit,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: ValueUnit(
                    title: "START",
                    value: cvm.buoyancyAtPressure!,
                    unit: cvm.weightUnit,
                  ),
                ),
                Expanded(
                  child: ValueUnit(
                    title: "EMPTY",
                    value: cvm.buoyancyEmpty!,
                    unit: cvm.weightUnit,
                  ),
                ),
                Expanded(
                  child: ValueUnit(
                    title: "@RB",
                    value: cvm.buoyancyAtReserve!,
                    unit: cvm.weightUnit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
