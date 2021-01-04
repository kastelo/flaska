import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

import '../models/units.dart';
import '../proto/proto.dart';
import '../services/service_locator.dart';
import '../services/settings_service.dart';

class SettingsState {
  final SettingsData settings;
  const SettingsState(this.settings);
}

class SettingsEvent {
  const SettingsEvent();
}

class _NewSettingsEvent extends SettingsEvent {
  final SettingsData settings;
  const _NewSettingsEvent(this.settings);
}

class SetMeasurementSystem extends SettingsEvent {
  final MeasurementSystem measurements;
  const SetMeasurementSystem(this.measurements);
}

class UpdateSettings extends SettingsEvent {
  final SettingsData Function(SettingsData) fn;
  const UpdateSettings(this.fn);
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final settingsService = serviceLocator<SettingsService>();

  SettingsBloc() : super(SettingsState(SettingsData())) {
    loadData();
  }

  void loadData() async {
    final s = await settingsService.getSettings();
    add(_NewSettingsEvent(s));
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is _NewSettingsEvent) {
      yield SettingsState(event.settings.deepCopy());
    }
    if (event is SetMeasurementSystem) {
      final newSettings = state.settings.deepCopy()
        ..measurements = event.measurements;
      await settingsService.saveSettings(newSettings);
      yield SettingsState(newSettings);
    }
    if (event is UpdateSettings) {
      final newSettings = event.fn(state.settings.deepCopy());
      await settingsService.saveSettings(newSettings);
      yield SettingsState(newSettings);
    }
  }
}

extension SettingsModel on SettingsData {
  bool get isMetric => measurements == MeasurementSystem.METRIC;

  Volume get sacRate =>
      isMetric ? VolumeLiter(metric.sacRate) : VolumeCuFt(imperial.sacRate);
  set sacRate(Volume v) {
    if (measurements == MeasurementSystem.METRIC)
      metric.sacRate = v.liter;
    else
      imperial.sacRate = v.cuft;
  }

  Distance get ascentRate =>
      isMetric ? DistanceM(metric.ascentRate) : DistanceFt(imperial.ascentRate);
  set ascentRate(Distance v) {
    if (measurements == MeasurementSystem.METRIC)
      metric.ascentRate = v.m;
    else
      imperial.ascentRate = v.ft;
  }

  Distance get safetyStopDepth => isMetric
      ? DistanceM(metric.safetyStopDepth)
      : DistanceFt(imperial.safetyStopDepth);
  set safetyStopDepth(Distance v) {
    if (measurements == MeasurementSystem.METRIC)
      metric.safetyStopDepth = v.m;
    else
      imperial.safetyStopDepth = v.ft;
  }
}
