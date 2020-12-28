import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'cylinder_model.dart';
import 'units.dart';

class CylinderViewMetric extends StatelessWidget {
  final CylinderModel cylinder;
  final Pressure pressure;
  final Volume sac;
  final Distance depth;

  CylinderViewMetric(
      {@required this.cylinder,
      @required this.pressure,
      @required this.sac,
      @required this.depth});

  @override
  Widget build(BuildContext context) {
    TextStyle pressureStyle;
    if (pressure.bar > cylinder.workingPressure.bar * 1.15) {
      pressureStyle = errorStyle(context);
    } else if (pressure.bar > cylinder.workingPressure.bar) {
      pressureStyle = warningStyle(context);
    }

    final airTimeMin =
        cylinder.airTimeMin(pressure: pressure, sac: sac, depth: depth);
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
              "%s (%.01f L %d bar, %.01f kg)".format([
                cylinder.name,
                cylinder.waterVolume.liter,
                cylinder.workingPressure.bar,
                cylinder.weight.kg
              ]),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ]),
        TableRow(children: [
          header("Gas", context),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: RichText(
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
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText2,
                children: [
                  TextSpan(
                    text: "%.0f min".format([airTimeMin]),
                    style: airTimeStyle,
                  ),
                  TextSpan(
                    text: " to %d bar (%.0f L rock bottom)".format([
                      cylinder
                          .rockBottomPressure(sac: sac, depth: depth)
                          .bar
                          .roundi(5),
                      cylinder.rockBottom(sac: sac, depth: depth).liter
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
            "%+.01f kg at %d bar (%+.01f kg at %d bar)".format([
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

class CylinderViewImperial extends StatelessWidget {
  final CylinderModel cylinder;
  final Pressure pressure;
  final Volume sac;
  final Distance depth;

  CylinderViewImperial(
      {@required this.cylinder,
      @required this.pressure,
      @required this.sac,
      @required this.depth});

  @override
  Widget build(BuildContext context) {
    TextStyle pressureStyle;
    if (pressure.bar > cylinder.workingPressure.bar * 1.15) {
      pressureStyle = errorStyle(context);
    } else if (pressure.bar > cylinder.workingPressure.bar) {
      pressureStyle = warningStyle(context);
    }

    final airTimeMin =
        cylinder.airTimeMin(pressure: pressure, sac: sac, depth: depth);
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
              text: TextSpan(
                text: "%.1f ft³ air at ".format([
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
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText2,
                children: [
                  TextSpan(
                    text: "%.0f min".format([airTimeMin]),
                    style: airTimeStyle,
                  ),
                  TextSpan(
                    text: " to %d psi (%.1f ft³ rock bottom)".format([
                      cylinder
                          .rockBottomPressure(sac: sac, depth: depth)
                          .psi
                          .roundi(100),
                      cylinder.rockBottom(sac: sac, depth: depth).cuft
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ]),
        TableRow(children: [
          header("Buoyancy", context),
          Text("%+.01f lb at %d psi (%+.01f lb at %d psi)".format([
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
