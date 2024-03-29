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
    return PressureBar(0);
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
    return VolumeL(0);
  }

  Volume operator -(Volume other) {
    if (this is VolumeL) {
      return this - other;
    }
    if (this is VolumeCuFt) {
      return this - other;
    }
    return VolumeL(0);
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

  VolumeL operator -(Volume other) {
    return VolumeL(l - other.l);
  }

  @override
  bool operator ==(Object other) => other is VolumeL && l == other.l;

  @override
  int get hashCode => l.hashCode;
}

class VolumeCuFt extends Volume {
  final double cuft;
  double get l => cuft / literPerCuft;
  const VolumeCuFt(this.cuft);

  VolumeCuFt operator +(Volume other) {
    return VolumeCuFt(cuft + other.cuft);
  }

  VolumeCuFt operator -(Volume other) {
    return VolumeCuFt(cuft - other.cuft);
  }

  @override
  bool operator ==(Object other) => other is VolumeCuFt && cuft == other.cuft;

  @override
  int get hashCode => cuft.hashCode;
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
  int roundEven(int intv) {
    return (this + intv / 2) ~/ intv * intv;
  }

  int roundDown(int intv) {
    return this ~/ intv * intv;
  }

  int roundUp(int intv) {
    if (this % intv == 0) return this;
    return (this ~/ intv + 1) * intv;
  }
}

extension SettingsModel on SettingsData {
  bool get isMetric => measurements == MeasurementSystem.METRIC;

  Volume get sacRate => isMetric ? VolumeL(metric.sacRate) : VolumeCuFt(imperial.sacRate);
  set sacRate(Volume v) {
    if (measurements == MeasurementSystem.METRIC)
      metric.sacRate = v.l;
    else
      imperial.sacRate = v.cuft;
  }

  Distance get ascentRate => principles == Principles.ROCKBOTTOM
      ? isMetric
          ? DistanceM(9)
          : DistanceFt(30)
      : isMetric
          ? DistanceM(3)
          : DistanceFt(9);
  Distance get safetyStopDepth => isMetric ? DistanceM(5) : DistanceFt(15);
  Pressure get minPressure => isMetric ? PressureBar(30) : PressurePsi(300);
  Pressure get maxPressure => isMetric ? PressureBar(350) : PressurePsi(4000);
  Pressure get pressureStep => isMetric ? PressureBar(5) : PressurePsi(100);
  Distance get minDepth => isMetric ? DistanceM(2) : DistanceFt(10);
  Distance get maxDepth => isMetric ? DistanceM(40) : DistanceFt(140);
}
