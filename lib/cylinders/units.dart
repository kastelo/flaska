const barPerPsi = 0.0689476;
const literPerCuft = 0.0353147;
const kgPerLbs = 0.453592;
const mPerFt = 0.3048;
const steelKgPerL = 8.05;
const aluKgPerL = 2.7;
const airKgPerL = 1.2041 / 1000;
const waterPerL = 1.020;

final airZ = [
  [0, 1.0],
  [1, 0.9999],
  [5, 0.9987],
  [10, 0.9974],
  [20, 0.9950],
  [40, 0.9917],
  [60, 0.9901],
  [80, 0.9903],
  [100, 0.9930],
  [150, 1.0074],
  [200, 1.0326],
  [250, 1.0669],
  [300, 1.1089],
  [350, 1.2073],
  [400, 1.3163],
];

abstract class Pressure {
  int get bar;
  int get psi;
  const Pressure();
}

class PressureBar extends Pressure {
  final int bar;
  int get psi => bar ~/ barPerPsi;
  const PressureBar(this.bar);
}

class PressurePsi extends Pressure {
  final int psi;
  int get bar => (psi * barPerPsi).toInt();
  const PressurePsi(this.psi);
}

Pressure equivalentPressure(Pressure p) {
  for (var pair in airZ.asMap().entries) {
    if (pair.value[0] > p.bar) {
      final x = p.bar;
      final x0 = airZ[pair.key - 1][0];
      final x1 = pair.value[0];
      final y0 = airZ[pair.key - 1][1];
      final y1 = pair.value[1];
      final y = (y0 * (x1 - x) + y1 * (x - x0)) / (x1 - x0);
      return PressureBar(p.bar ~/ y);
    }
  }
  return PressureBar(p.bar ~/ airZ.last[1]);
}

abstract class Volume {
  double get liter;
  double get cuft;
  const Volume();
}

class VolumeLiter extends Volume {
  final double liter;
  double get cuft => liter * literPerCuft;
  const VolumeLiter(this.liter);
  VolumeLiter.fromPressure(double cuft, int psi)
      : liter =
            VolumeCuFt(cuft).liter / equivalentPressure(PressurePsi(psi)).bar;
}

class VolumeCuFt extends Volume {
  final double cuft;
  double get liter => cuft / literPerCuft;
  const VolumeCuFt(this.cuft);
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
