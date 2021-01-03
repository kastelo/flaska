export 'flaska.pb.dart';
export 'flaska.pbenum.dart';

import 'package:flaska/proto/flaska.pbserver.dart';

extension SettingsExtension on SettingsData {
  double get sacRate => measurements == MeasurementSystem.METRIC
      ? metric.sacRate
      : imperial.sacRate;
  set sacRate(double v) {
    if (measurements == MeasurementSystem.METRIC)
      metric.sacRate = v;
    else
      imperial.sacRate = v;
  }

  double get ascentRate => measurements == MeasurementSystem.METRIC
      ? metric.ascentRate
      : imperial.ascentRate;
  set ascentRate(double v) {
    if (measurements == MeasurementSystem.METRIC)
      metric.ascentRate = v;
    else
      imperial.ascentRate = v;
  }

  double get safetyStopDepth => measurements == MeasurementSystem.METRIC
      ? metric.safetyStopDepth
      : imperial.safetyStopDepth;
  set safetyStopDepth(double v) {
    if (measurements == MeasurementSystem.METRIC)
      metric.safetyStopDepth = v;
    else
      imperial.safetyStopDepth = v;
  }
}
