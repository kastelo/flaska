import 'package:flaska/models/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';

import '../proto/proto.dart';
import '../services/service_locator.dart';
import '../services/settings_service.dart';

class SettingsState {
  final SettingsData settings;
  SettingsState.empty() : settings = SettingsData();
  const SettingsState(this.settings);

  Color get themeColor {
    switch (settings.themeColor) {
      case ThemeColor.BLUE:
        return const Color.fromRGBO(64, 224, 255, 1);
      case ThemeColor.PINK:
        return Color.fromARGB(255, 255, 64, 204);
      case ThemeColor.GREEN:
        return Color.fromARGB(255, 64, 255, 74);
      case ThemeColor.ORANGE:
        return Color.fromARGB(255, 255, 166, 64);
      case ThemeColor.PURPLE:
        return Color.fromARGB(255, 191, 64, 255);
      default:
        return const Color.fromRGBO(64, 224, 255, 1);
    }
  }
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

class SetPrinciples extends SettingsEvent {
  final Principles principles;
  const SetPrinciples(this.principles);
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
      final SettingsData newSettings = state.settings.deepCopy()..measurements = event.measurements;
      await settingsService!.saveSettings(newSettings);
      emit(SettingsState(newSettings));
    });

    on<SetPrinciples>((event, emit) async {
      final SettingsData newSettings = state.settings.deepCopy()..principles = event.principles;
      if (event.principles == Principles.GUE) {
        if (newSettings.isMetric && newSettings.sacRate.l < 15) newSettings.sacRate = VolumeL(15);
        if (!newSettings.isMetric && newSettings.sacRate.cuft < 0.6) newSettings.sacRate = VolumeL(0.6);
        newSettings.troubleSolvingDuration = 1;
        newSettings.troubleSolvingSacMultiplier = 4;
        newSettings.ascentSacMultiplier = 4;
        newSettings.safetyStopDuration = 0;
        newSettings.safetyStopSacMultiplier = 0;
        newSettings.hideNdlNotice = true;
      }
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
