import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

import '../proto/proto.dart';
import '../services/service_locator.dart';
import '../services/settings_service.dart';

class SettingsState {
  final SettingsData settings;
  SettingsState.empty() : settings = SettingsData();
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
  final MeasurementSystem? measurements;
  const SetMeasurementSystem(this.measurements);
}

class UpdateSettings extends SettingsEvent {
  final SettingsData Function(SettingsData) fn;
  const UpdateSettings(this.fn);
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService? settingsService = serviceLocator<SettingsService>();

  SettingsBloc() : super(SettingsState.empty()) {
    on<_NewSettingsEvent>((event, emit) => emit(SettingsState(event.settings.deepCopy())));

    on<SetMeasurementSystem>((event, emit) async {
      final SettingsData newSettings = state.settings.deepCopy()..measurements = event.measurements!;
      await settingsService!.saveSettings(newSettings);
      emit(SettingsState(newSettings));
    });

    on<UpdateSettings>((event, emit) async {
      final newSettings = event.fn(state.settings.deepCopy());
      await settingsService!.saveSettings(newSettings);
      emit(SettingsState(newSettings));
    });

    loadData();
  }

  void loadData() async {
    final s = await settingsService!.getSettings();
    add(_NewSettingsEvent(s));
  }
}
