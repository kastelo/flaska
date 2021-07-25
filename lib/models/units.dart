import 'compressibility.dart';
import '../proto/proto.dart';

const barPerPsi = 0.0689476;
const literPerCuft = 0.0353147;
const kgPerLbs = 0.453592;
const mPerFt = 0.3048;
const steelKgPerL = 8.05;
const aluKgPerL = 2.7;
const airKgPerL = 1.2041 / 1000;
const waterPerL = 1.020;

abstract class Pressure {
  int get bar;
  int get psi;
  const Pressure();

  Pressure operator +(Pressure other) {
    if (this is PressureBar) {
      return this + other;
    }
    if (this is PressurePsi) {
      return this + other;
    }
    assert(false, "unknown kind");
  }
}

class PressureBar extends Pressure {
  final int bar;
  int get psi => bar ~/ barPerPsi;
  const PressureBar(this.bar);

  PressureBar operator +(Pressure other) {
    return PressureBar(bar + other.bar);
  }

  String toString() => "$bar bar";
}

class PressurePsi extends Pressure {
  final int psi;
  int get bar => (psi * barPerPsi).toInt();
  const PressurePsi(this.psi);

  PressurePsi operator +(Pressure other) {
    return PressurePsi(psi + other.psi);
  }

  String toString() => "$psi psi";
}

abstract class Volume {
  double get l;
  double get cuft;
  const Volume();

  Volume operator +(Volume other) {
    if (this is VolumeL) {
      return this + other;
    }
    if (this is VolumeCuFt) {
      return this + other;
    }
    assert(false, "unknown kind");
  }
}

class VolumeL extends Volume {
  final double l;
  double get cuft => l * literPerCuft;
  const VolumeL(this.l);
  VolumeL.fromPressure(double cuft, int psi) : l = VolumeCuFt(cuft).l / gasVolumeAtPressure(PressurePsi(psi), VolumeL(1)).l;

  VolumeL operator +(Volume other) {
    return VolumeL(l + other.l);
  }
}

class VolumeCuFt extends Volume {
  final double cuft;
  double get l => cuft / literPerCuft;
  const VolumeCuFt(this.cuft);

  VolumeCuFt operator +(Volume other) {
    return VolumeCuFt(cuft + other.cuft);
  }
}

abstract class Distance {
  double get m;
  double get ft;
  const Distance();
}

class DistanceM extends Distance {
  final double m;
  double get ft => m / mPerFt;
  const DistanceM(this.m);
}

class DistanceFt extends Distance {
  final double ft;
  double get m => ft * mPerFt;
  const DistanceFt(this.ft);
}

abstract class Weight {
  double get kg;
  double get lb;
  const Weight();
}

class WeightKg extends Weight {
  final double kg;
  double get lb => kg / kgPerLbs;
  const WeightKg(this.kg);
}

class WeightLb extends Weight {
  final double lb;
  double get kg => lb * kgPerLbs;
  const WeightLb(this.lb);
}

extension Rounding on int {
  int roundi(int intv) {
    return (this + intv / 2) ~/ intv * intv;
  }
}

extension SettingsModel on SettingsData {
  bool get valid => measurements != null;
  bool get isMetric => measurements == MeasurementSystem.METRIC;

  Volume get sacRate => isMetric ? VolumeL(metric.sacRate) : VolumeCuFt(imperial.sacRate);
  set sacRate(Volume v) {
    if (measurements == MeasurementSystem.METRIC)
      metric.sacRate = v.l;
    else
      imperial.sacRate = v.cuft;
  }

  Distance get ascentRate => isMetric ? DistanceM(metric.ascentRate) : DistanceFt(imperial.ascentRate);
  set ascentRate(Distance v) {
    if (measurements == MeasurementSystem.METRIC)
      metric.ascentRate = v.m;
    else
      imperial.ascentRate = v.ft;
  }

  Distance get safetyStopDepth => isMetric ? DistanceM(metric.safetyStopDepth) : DistanceFt(imperial.safetyStopDepth);
  set safetyStopDepth(Distance v) {
    if (measurements == MeasurementSystem.METRIC)
      metric.safetyStopDepth = v.m;
    else
      imperial.safetyStopDepth = v.ft;
  }

  Pressure get minPressure => isMetric ? PressureBar(metric.minPressure) : PressurePsi(imperial.minPressure);
  set minPressure(Pressure p) {
    if (measurements == MeasurementSystem.METRIC)
      metric.minPressure = p.bar;
    else
      imperial.minPressure = p.bar;
  }

  Pressure get maxPressure => isMetric ? PressureBar(metric.maxPressure) : PressurePsi(imperial.maxPressure);
  set maxPressure(Pressure p) {
    if (measurements == MeasurementSystem.METRIC)
      metric.maxPressure = p.bar;
    else
      imperial.maxPressure = p.bar;
  }

  Pressure get pressureStep => isMetric ? PressureBar(metric.pressureStep) : PressurePsi(imperial.pressureStep);
  set pressureStep(Pressure p) {
    if (measurements == MeasurementSystem.METRIC)
      metric.pressureStep = p.bar;
    else
      imperial.pressureStep = p.bar;
  }

  Distance get minDepth => isMetric ? DistanceM(metric.minDepth.toDouble()) : DistanceFt(imperial.minDepth.toDouble());
  set minDepth(Distance d) {
    if (measurements == MeasurementSystem.METRIC)
      metric.minDepth = d.m.toInt();
    else
      imperial.minDepth = d.ft.toInt();
  }

  Distance get maxDepth => isMetric ? DistanceM(metric.maxDepth.toDouble()) : DistanceFt(imperial.maxDepth.toDouble());
  set maxDepth(Distance d) {
    if (measurements == MeasurementSystem.METRIC)
      metric.maxDepth = d.m.toInt();
    else
      imperial.maxDepth = d.ft.toInt();
  }
}
