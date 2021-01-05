import '../models/compressibility.dart';
import '../models/units.dart';
import 'transfill_bloc.dart';

class TransfillResultViewModel {
  final TransfillCylinderModel from;
  final TransfillCylinderModel to;

  const TransfillResultViewModel({this.from, this.to});

  Volume get totalGas => from.gas + to.gas;
  Volume get totalVolume => from.totalVolume + to.totalVolume;

  Pressure get resultingPressure {
    // Single stage filling to single tank.
    if (!to.cylinder.twinset)
      return apparentPressure(PressureBar(totalGas.l ~/ totalVolume.l));

    // Two stage filling to twinset. waterVolume is per tank.
    return apparentPressure(
        PressureBar((_stage1Pressure.bar + _stage2Pressure.bar) ~/ 2));
  }

  Pressure get t1Pressure => apparentPressure(_stage1Pressure);
  Pressure get t2Pressure => apparentPressure(_stage2Pressure);

  Pressure get _stage1Pressure {
    final t1gasL = from.cylinder.waterVolume.l *
            from.cylinder.twinFactor *
            from.pressure.bar +
        to.cylinder.waterVolume.l * to.pressure.bar;
    return PressureBar(t1gasL ~/
        (from.cylinder.waterVolume.l * from.cylinder.twinFactor +
            to.cylinder.waterVolume.l));
  }

  Pressure get _stage2Pressure {
    final t2gasL = from.cylinder.waterVolume.l *
            from.cylinder.twinFactor *
            _stage1Pressure.bar +
        to.cylinder.waterVolume.l * to.pressure.bar;
    return PressureBar(t2gasL ~/
        (from.cylinder.waterVolume.l * from.cylinder.twinFactor +
            to.cylinder.waterVolume.l));
  }
}
