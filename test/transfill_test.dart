import 'package:flaska/models/cylinder_model.dart';
import 'package:flaska/models/units.dart';
import 'package:flaska/proto/flaska.pbserver.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flaska/transfill/transfill_result_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final c0 = CylinderModel.metric(Guid.newGuid, "c0", Metal.STEEL, PressureBar(300), VolumeL(8), WeightKg(0), false, false, false);
  final c1 = CylinderModel.metric(Guid.newGuid, "c1", Metal.STEEL, PressureBar(200), VolumeL(12), WeightKg(0), false, false, false);

  test('Transfill should improve situation (200/300)', () {
    final m0 = TransfillCylinderModel(cylinder: c0, pressure: PressureBar(300));
    expect(m0.gas.l, greaterThan(250 * 8));
    expect(m0.gas.l, lessThan(300 * 8));
    expect(m0.totalVolume.l, 8);

    final m1 = TransfillCylinderModel(cylinder: c1, pressure: PressureBar(200));
    expect(m1.gas.l, greaterThan(180 * 12));
    expect(m1.gas.l, lessThan(200 * 12));
    expect(m1.totalVolume.l, 12);

    final res = TransfillResultViewModel(from: m0, to: m1);

    expect(res.resultingPressure.bar, greaterThan(200));
    expect(res.resultingPressure.bar, lessThan(300));
  });

  test('Transfill should improve situation (250/300)', () {
    final m0 = TransfillCylinderModel(cylinder: c0, pressure: PressureBar(300));
    expect(m0.gas.l, greaterThan(250 * 8));
    expect(m0.gas.l, lessThan(300 * 8));
    expect(m0.totalVolume.l, 8);

    final m1 = TransfillCylinderModel(cylinder: c1, pressure: PressureBar(250));
    expect(m1.gas.l, greaterThan(230 * 12));
    expect(m1.gas.l, lessThan(250 * 12));
    expect(m1.totalVolume.l, 12);

    final res = TransfillResultViewModel(from: m0, to: m1);

    expect(res.resultingPressure.bar, greaterThan(250));
    expect(res.resultingPressure.bar, lessThan(300));
  });
}
