import 'compressibility.dart';

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
}

class PressurePsi extends Pressure {
  final int psi;
  int get bar => (psi * barPerPsi).toInt();
  const PressurePsi(this.psi);

  PressurePsi operator +(Pressure other) {
    return PressurePsi(psi + other.psi);
  }
}

abstract class Volume {
  double get liter;
  double get cuft;
  const Volume();

  Volume operator +(Volume other) {
    if (this is VolumeLiter) {
      return this + other;
    }
    if (this is VolumeCuFt) {
      return this + other;
    }
    assert(false, "unknown kind");
  }
}

class VolumeLiter extends Volume {
  final double liter;
  double get cuft => liter * literPerCuft;
  const VolumeLiter(this.liter);
  VolumeLiter.fromPressure(double cuft, int psi)
      : liter =
            VolumeCuFt(cuft).liter / equivalentPressure(PressurePsi(psi)).bar;

  VolumeLiter operator +(Volume other) {
    return VolumeLiter(liter + other.liter);
  }
}

class VolumeCuFt extends Volume {
  final double cuft;
  double get liter => cuft / literPerCuft;
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
