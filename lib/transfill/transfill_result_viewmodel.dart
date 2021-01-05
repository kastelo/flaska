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
      return pressureForGasVolume(totalGas, totalVolume);

    // Two stage filling to twinset. waterVolume is per tank.
    return pressureForGasVolume(
        gasVolumeAtPressure(t1Pressure, to.cylinder.waterVolume) +
            gasVolumeAtPressure(t2Pressure, to.cylinder.waterVolume),
        to.cylinder.totalWaterVolume);
  }

  // Total gas volume when connecting source with T1
  Volume get _t1Volume =>
      gasVolumeAtPressure(from.pressure, from.cylinder.totalWaterVolume) +
      gasVolumeAtPressure(to.pressure, to.cylinder.waterVolume);

  // Resulting pressire when connecting source with T1
  Pressure get t1Pressure => pressureForGasVolume(
      _t1Volume, from.cylinder.totalWaterVolume + to.cylinder.waterVolume);

  // Total gas volume when connecting source with T2, with source now at T1 pressure
  Volume get _t2Volume =>
      gasVolumeAtPressure(t1Pressure, from.cylinder.totalWaterVolume) +
      gasVolumeAtPressure(to.pressure, to.cylinder.waterVolume);

  // Resulting pressire when connecting source with T2
  Pressure get t2Pressure => pressureForGasVolume(
      _t2Volume, from.cylinder.totalWaterVolume + to.cylinder.waterVolume);
}
