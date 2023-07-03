import 'package:flaska/models/cylinder_viewmodel.dart';
import 'package:flaska/proto/flaska.pbserver.dart';
import 'package:flutter/material.dart';

import '../models/cylinder_model.dart';
import '../models/rockbottom_model.dart';
import '../models/units.dart';
import 'valueunit.dart';
import 'foldable.dart';

class DiveCalculationCylinderView extends StatelessWidget {
  final Principles principles;
  final CylinderModel cylinder;
  final RockBottomModel rockBottom;
  final Pressure pressure;
  final bool metric;
  final bool hideNDLNotice;
  final UsableGas usableGas;

  DiveCalculationCylinderView({
    required this.principles,
    required this.cylinder,
    required this.rockBottom,
    required this.pressure,
    required this.metric,
    required this.hideNDLNotice,
    required this.usableGas,
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
              (cvm.cylinder!.twinset ? "2×" : "") + "${shortNumber(cvm.cylinder!.waterVolume.l)} L",
              style: h1,
              textAlign: TextAlign.right,
            ),
          if (metric)
            Text(
              (cvm.cylinder!.twinset ? "2×" : "") + "${shortNumber(cvm.cylinder!.nominalVolume.cuft)} cuft",
              style: h1,
              textAlign: TextAlign.right,
            ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              cvm.weight,
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
                    title: "TOTAL",
                    value: cvm.gas,
                    unit: cvm.volumeUnit,
                  ),
                ),
                Expanded(
                  child: ValueUnit(
                    title: principles == Principles.MINGAS ? "MIN GAS" : "ROCK BOT",
                    value: cvm.rbPressure,
                    unit: cvm.pressureUnit,
                  ),
                ),
                Expanded(
                  child: ValueUnit(
                    title: "GAS TIME",
                    value: cvm.airtime,
                    unit: "min",
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
                    title: "USABLE",
                    value: cvm.usableVolume,
                    unit: cvm.volumeUnit,
                  ),
                ),
                Expanded(
                  child: usableGas == UsableGas.ALL_USABLE
                      ? Container()
                      : ValueUnit(
                          title: "TURN",
                          value: cvm.turnPressure,
                          unit: cvm.pressureUnit,
                        ),
                ),
                Expanded(
                  child: usableGas == UsableGas.ALL_USABLE
                      ? Container()
                      : ValueUnit(
                          title: "TURN TIME",
                          value: cvm.airtimeUntilTurn,
                          unit: "min",
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
                    title: "@START",
                    value: cvm.buoyancyAtPressure,
                    unit: cvm.weightUnit,
                  ),
                ),
                Expanded(
                  child: ValueUnit(
                    title: principles == Principles.MINGAS ? "@MIN GAS" : "@ROCK BOT",
                    value: cvm.buoyancyAtReserve,
                    unit: cvm.weightUnit,
                  ),
                ),
                Expanded(
                  child: ValueUnit(
                    title: "@EMPTY",
                    value: cvm.buoyancyEmpty,
                    unit: cvm.weightUnit,
                  ),
                ),
              ],
            ),
          ),
          if (!hideNDLNotice && cvm.exceedsNDL)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.warning, color: Theme.of(context).colorScheme.primary),
                  ),
                  Expanded(child: Text("Gas time may exceed NDL for a square profile. Rock bottom calculation does not include deco!")),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

String shortNumber(double value) {
  if (value >= 100) return value.toStringAsFixed(0);
  var s = value.toStringAsFixed(1);
  if (s.endsWith(".0")) s = s.substring(0, s.length - 2);
  return s;
}
