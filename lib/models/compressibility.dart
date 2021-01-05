import 'units.dart';

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

Pressure apparentPressure(Pressure p) {
  for (var pair in airZ.asMap().entries) {
    if (pair.value[0] > p.bar) {
      final x = p.bar;
      final x0 = airZ[pair.key - 1][0];
      final x1 = pair.value[0];
      final y0 = airZ[pair.key - 1][1];
      final y1 = pair.value[1];
      final y = (y0 * (x1 - x) + y1 * (x - x0)) / (x1 - x0);
      return PressureBar((p.bar * y).toInt());
    }
  }
  return PressureBar((p.bar * airZ.last[1]).toInt());
}
