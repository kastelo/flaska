import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import '../models/cylinder_model.dart';
import '../models/rockbottom_model.dart';
import '../models/units.dart';

class MetricCylinderSimulationView extends StatelessWidget {
  final CylinderModel cylinder;
  final RockBottomModel rockBottom;
  final Pressure pressure;

  MetricCylinderSimulationView({
    @required this.cylinder,
    @required this.rockBottom,
    @required this.pressure,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle pressureStyle;
    if (pressure.bar > cylinder.workingPressure.bar * 1.15) {
      pressureStyle = errorStyle(context);
    } else if (pressure.bar > cylinder.workingPressure.bar) {
      pressureStyle = warningStyle(context);
    }

    final airTimeMin = rockBottom.airtimeUntilRB(cylinder, pressure);
    TextStyle airTimeStyle;
    if (airTimeMin <= 5) {
      airTimeStyle = errorStyle(context);
    } else if (airTimeMin <= 15) {
      airTimeStyle = warningStyle(context);
    }

    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(children: [
          header("Tank", context),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              "%s (%.01f kg)".format([cylinder.name, cylinder.weight.kg]),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ]),
        TableRow(children: [
          header("Gas", context),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                text: "%.0f L air at ".format([
                  cylinder.compressedVolume(pressure).liter,
                ]),
                style: Theme.of(context).textTheme.bodyText2,
                children: [
                  TextSpan(
                    text: "%d bar".format([
                      pressure.bar,
                    ]),
                    style: pressureStyle,
                  ),
                ],
              ),
            ),
          ),
        ]),
        TableRow(children: [
          header("Air Time", context),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText2,
                children: [
                  TextSpan(
                    text: "%.0f min".format([airTimeMin]),
                    style: airTimeStyle,
                  ),
                  TextSpan(
                    text: " to %d bar (RB)".format([
                      rockBottom.rockBottomPressure(cylinder).bar.roundi(5),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ]),
        TableRow(children: [
          header("Buoyancy", context),
          Text(
            "%+.01f kg at %d bar\n(%+.01f kg at %d bar)".format([
              cylinder.buoyancy(pressure).kg,
              pressure.bar,
              cylinder.buoyancy(PressureBar(0)).kg,
              reservePressure.bar,
            ]),
            style: Theme.of(context).textTheme.bodyText2,
          )
        ]),
      ],
    );
  }
}

class ImperialCylinderSimulationView extends StatelessWidget {
  final CylinderModel cylinder;
  final RockBottomModel rockBottom;
  final Pressure pressure;

  ImperialCylinderSimulationView({
    @required this.cylinder,
    @required this.rockBottom,
    @required this.pressure,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle pressureStyle;
    if (pressure.bar > cylinder.workingPressure.bar * 1.15) {
      pressureStyle = errorStyle(context);
    } else if (pressure.bar > cylinder.workingPressure.bar) {
      pressureStyle = warningStyle(context);
    }

    final airTimeMin = rockBottom.airtimeUntilRB(cylinder, pressure);
    TextStyle airTimeStyle;
    if (airTimeMin <= 5) {
      airTimeStyle = errorStyle(context);
    } else if (airTimeMin <= 15) {
      airTimeStyle = warningStyle(context);
    }

    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(children: [
          header("Tank", context),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text("%s (%.01f lb)".format([
              cylinder.name,
              cylinder.weight.lb,
            ])),
          ),
        ]),
        TableRow(children: [
          header("Gas", context),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                text: "%.1f cuft air at ".format([
                  cylinder.compressedVolume(pressure).cuft,
                ]),
                style: Theme.of(context).textTheme.bodyText2,
                children: [
                  TextSpan(
                    text: "%d psi".format([
                      pressure.psi,
                    ]),
                    style: pressureStyle,
                  ),
                ],
              ),
            ),
          ),
        ]),
        TableRow(children: [
          header("Air Time", context),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText2,
                children: [
                  TextSpan(
                    text: "%.0f min".format([airTimeMin]),
                    style: airTimeStyle,
                  ),
                  TextSpan(
                    text: " to %d psi (RB)".format([
                      rockBottom.rockBottomPressure(cylinder).psi.roundi(100),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ]),
        TableRow(children: [
          header("Buoyancy", context),
          Text("%+.01f lb at %d psi\n(%+.01f lb at %d psi)".format([
            cylinder.buoyancy(pressure).lb,
            pressure.psi,
            cylinder.buoyancy(PressurePsi(0)).lb,
            reservePressure.psi,
          ]))
        ]),
      ],
    );
  }
}

extension Rounding on int {
  int roundi(int intv) {
    return (this + intv - 1) ~/ intv * intv;
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

extension StringFormatExtension on String {
  String format(var arguments) => sprintf(this, arguments);
}

TextStyle warningStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyText2.copyWith(
        color: Theme.of(context).accentColor, fontWeight: FontWeight.bold);

TextStyle errorStyle(BuildContext context) => Theme.of(context)
    .textTheme
    .bodyText2
    .copyWith(color: Theme.of(context).errorColor, fontWeight: FontWeight.bold);
