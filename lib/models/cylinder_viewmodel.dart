import 'package:sprintf/sprintf.dart';

import '../divecalculation/ndl.dart';
import '../models/rockbottom_model.dart';
import 'cylinder_model.dart';
import 'units.dart';

class CylinderViewModel {
  final CylinderModel? cylinder;
  final Pressure? pressure;
  final RockBottomModel? rockBottom;
  final bool? metric;
  const CylinderViewModel({this.cylinder, this.pressure, this.rockBottom, this.metric});

  String get description => sprintf("%s (%s)", [cylinder!.name, weight]);

  String get weight => metric! ? sprintf("%.01f kg", [cylinder!.dryWeight(pressure).kg]) : sprintf("%.01f lb", [cylinder!.dryWeight(pressure).lb]);

  String get gas => metric!
      ? sprintf("%d", [
          cylinder!.compressedVolume(pressure).l.toInt().roundDown(5),
        ])
      : sprintf("%.01f", [
          cylinder!.compressedVolume(pressure).cuft,
        ]);

  String get volumeUnit => metric! ? "L" : "ft³";
  String get pressureUnit => metric! ? "bar" : "psi";
  String get weightUnit => metric! ? "kg" : "lb";

  String get airtime => sprintf("~%.0f", [
        rockBottom!.airtimeUntilRB(cylinder!, pressure),
      ]);

  String get airtimeUntilTurn => sprintf("~%.0f", [
        rockBottom!.airtimeUntilTurn(cylinder!, pressure),
      ]);

  String get rbPressure =>
      sprintf("%d", [metric! ? rockBottom!.rockBottomPressure(cylinder!).bar.roundUp(10) : rockBottom!.rockBottomPressure(cylinder!).psi.roundUp(100)]);

  String get buoyancyAtPressure => metric!
      ? sprintf("%+.01f", [
          cylinder!.buoyancy(pressure).kg,
        ])
      : sprintf("%+.01f", [
          cylinder!.buoyancy(pressure).lb,
        ]);

  String get buoyancyAtReserve => metric!
      ? sprintf("%+.01f", [
          cylinder!.buoyancy(rockBottom!.rockBottomPressure(cylinder!)).kg,
        ])
      : sprintf("%+.01f", [
          cylinder!.buoyancy(rockBottom!.rockBottomPressure(cylinder!)).lb,
        ]);

  String get buoyancyEmpty => metric!
      ? sprintf("%+.01f", [
          cylinder!.buoyancy(PressureBar(0)).kg,
        ])
      : sprintf("%+.01f", [
          cylinder!.buoyancy(PressurePsi(0)).lb,
        ]);

  bool get exceedsNDL => rockBottom!.airtimeUntilRB(cylinder!, pressure) > ndlForDepth(rockBottom!.depth.m);

  String get usableVolume => metric!
      ? sprintf("%d", [
          rockBottom!.usableGas(cylinder!).l.toInt().roundDown(5),
        ])
      : sprintf("%.01f", [
          rockBottom!.usableGas(cylinder!).cuft,
        ]);

  String get turnPressure => sprintf("%d", [
        metric! ? rockBottom!.turnPressure(cylinder!).bar.roundUp(10) : rockBottom!.turnPressure(cylinder!).psi.roundUp(100),
      ]);
}
