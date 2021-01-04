import 'package:flutter/material.dart';

import '../models/cylinder_model.dart';
import '../models/rockbottom_model.dart';
import '../models/units.dart';

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
    final h0 = t.textTheme.subtitle2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(cvm.cylinder.name, style: h0)),
            Expanded(
                child: Text(
              cvm.weight,
              style: h0.copyWith(color: t.disabledColor),
              textAlign: TextAlign.right,
            )),
          ],
        ),
        Divider(),
        Row(
          children: [
            Expanded(
              child:
                  ValueUnit(title: "GAS", value: cvm.gas, unit: cvm.volumeUnit),
            ),
            Expanded(
              child:
                  ValueUnit(title: "GAS TIME", value: cvm.airtime, unit: "min"),
            ),
            Expanded(
              child: ValueUnit(
                  title: "RB", value: cvm.rbPressure, unit: cvm.pressureUnit),
            ),
          ],
        ),
        Row(
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
      ],
    );
  }
}

class ValueUnit extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const ValueUnit(
      {@required this.title, @required this.value, @required this.unit});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final valueStyle = t.textTheme.headline5;
    final titleStyle = t.textTheme.subtitle2.copyWith(color: t.accentColor);
    final unitStyle = t.textTheme.subtitle1.copyWith(color: t.disabledColor);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: titleStyle,
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                value,
                style: valueStyle,
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(" " + unit, style: unitStyle),
            ),
          ],
        ),
      ],
    );
  }
}
