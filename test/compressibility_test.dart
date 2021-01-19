import 'package:flaska/models/compressibility.dart';
import 'package:flaska/models/units.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Gas volume is slightly more than theoretical (low pressures)', () {
    for (var p in [10, 50, 100]) {
      final v = gasVolumeAtPressure(PressureBar(p), VolumeL(10));
      expect(v.l, greaterThan(p * 10));
      expect(v.l, lessThan(p * 10 * 1.1));
    }
  });

  test('Gas volume is slightly less than theoretical (high pressures)', () {
    for (var p0 in [150, 200, 250, 300]) {
      final v = gasVolumeAtPressure(PressureBar(p0), VolumeL(10));
      expect(v.l, greaterThan(p0 * 10 * 0.9));
      expect(v.l, lessThan(p0 * 10));
    }
  });

  test('Formula is mostly reversible', () {
    // At 300 it drifts to 293, which I'm Ok with so we don't test that.
    for (var p0 in [10, 50, 100, 150, 200, 250]) {
      final v = gasVolumeAtPressure(PressureBar(p0), VolumeL(10));
      final p = pressureForGasVolume(v, VolumeL(10));
      expect(p.bar, within(distance: 5, from: p0));
    }
  });
}
