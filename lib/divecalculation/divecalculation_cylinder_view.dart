import 'package:flutter/material.dart';

import '../models/cylinder_model.dart';
import '../models/rockbottom_model.dart';
import '../models/units.dart';
import 'valueunit.dart';

class DiveCalculationCylinderView extends StatelessWidget {
  final CylinderModel cylinder;
  final RockBottomModel rockBottom;
  final Pressure pressure;
  final bool metric;

  DiveCalculationCylinderView({
    @required this.cylinder,
    @required this.rockBottom,
    @required this.pressure,
    @required this.metric,
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
    final h0 = t.textTheme.subtitle1;
    final h1 = t.textTheme.subtitle2.copyWith(color: t.disabledColor);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(cvm.cylinder.name, style: h0)),
                Expanded(
                    child: Text(
                  cvm.weight,
                  style: h1,
                  textAlign: TextAlign.right,
                )),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ValueUnit(
                        title: "GAS", value: cvm.gas, unit: cvm.volumeUnit),
                  ),
                  Expanded(
                    child: ValueUnit(
                        title: "GAS TIME", value: cvm.airtime, unit: "min"),
                  ),
                  Expanded(
                    child: ValueUnit(
                        title: "RB",
                        value: cvm.rbPressure,
                        unit: cvm.pressureUnit),
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
                        value: cvm.buoyancyAtPressure,
                        unit: cvm.weightUnit),
                  ),
                  Expanded(
                    child: ValueUnit(
                        title: "EMPTY",
                        value: cvm.buoyancyEmpty,
                        unit: cvm.weightUnit),
                  ),
                  Expanded(
                    child: ValueUnit(
                        title: "@RB",
                        value: cvm.buoyancyAtReserve,
                        unit: cvm.weightUnit),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
