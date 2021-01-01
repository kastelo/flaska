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

    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(children: [
          header("Tank", context),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(cvm.description),
          ),
        ]),
        TableRow(children: [
          header("Gas", context),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(cvm.gas),
          ),
        ]),
        TableRow(children: [
          header("Air Time", context),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(cvm.airtime),
          ),
        ]),
        TableRow(children: [header("Buoyancy", context), Text(cvm.buoyancy)]),
      ],
    );
  }
}

Widget header(String text, BuildContext context) => Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.grey),
      ),
    );
