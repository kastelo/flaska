import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/rockbottom_model.dart';
import '../models/units.dart';
import '../proto/proto.dart';
import '../settings/settings_bloc.dart';

class DiveCalculationState {
  final SettingsData settings;
  final Distance depth;
  final Pressure tankPressure;
  final Set<String> foldedClosed;

  bool get valid => settings != null && settings.valid && depth != null && tankPressure != null;
  bool get metric => settings.measurements == MeasurementSystem.METRIC;
  RockBottomModel get rockBottom => RockBottomModel.fromSettings(settings, depth);

  bool foldedOpen(String id) => !(foldedClosed ?? {}).contains(id);

  const DiveCalculationState({
    this.settings,
    this.depth,
    this.tankPressure,
    this.foldedClosed,
  });

  const DiveCalculationState.empty()
      : settings = null,
        depth = null,
        tankPressure = null,
        foldedClosed = null;

  DiveCalculationState copyWith({
    SettingsData settings,
    Distance depth,
    Pressure tankPressure,
    Set<String> foldedClosed,
  }) =>
      DiveCalculationState(
        settings: settings ?? this.settings,
        depth: depth ?? this.depth,
        tankPressure: tankPressure ?? this.tankPressure,
        foldedClosed: foldedClosed ?? this.foldedClosed,
      );
}

class DiveCalculationEvent {
  const DiveCalculationEvent();
}

class SetDepth extends DiveCalculationEvent {
  final Distance depth;
  const SetDepth(this.depth);
}

class SetTankPressure extends DiveCalculationEvent {
  final Pressure pressure;
  const SetTankPressure(this.pressure);
}

class _NewSettings extends DiveCalculationEvent {
  final SettingsData settings;
  const _NewSettings(this.settings);
}

class _NewClosed extends DiveCalculationEvent {
  final Set<String> foldedClosed;
  const _NewClosed(this.foldedClosed);
}

class ToggleFolding extends DiveCalculationEvent {
  final String id;
  const ToggleFolding(this.id);
}

class DiveCalculationBloc extends Bloc<DiveCalculationEvent, DiveCalculationState> {
  StreamSubscription settingsSub;
  SharedPreferences preferences;

  DiveCalculationBloc(SettingsBloc settingsBloc) : super(DiveCalculationState.empty()) {
    this.add(_NewSettings(settingsBloc.state.settings));
    settingsSub = settingsBloc.stream.listen((settingsState) {
      this.add(_NewSettings(settingsState.settings));
    });
  }

  @override
  Future<void> close() {
    settingsSub.cancel();
    return super.close();
  }

  @override
  Stream<DiveCalculationState> mapEventToState(DiveCalculationEvent event) async* {
    if (event is _NewSettings) {
      final newState = state.copyWith(settings: event.settings);
      if (newState.settings != null && newState.settings.valid) {
        if (preferences == null) {
          await loadPreferences();
        } else if (newState.metric != state.metric) {
          add(SetTankPressure(newState.tankPressure));
          add(SetDepth(newState.depth));
        }
      }
      yield newState;
    }

    if (event is SetDepth) {
      var depth = event.depth;
      if (state.metric) {
        depth = DistanceM(depth.m.round().toDouble());
        if (preferences != null) {
          preferences.setDouble('depth', depth.m);
          preferences.setBool('metric', true);
        }
      } else {
        depth = DistanceFt(depth.ft.round().roundi(10).toDouble());
        if (preferences != null) {
          preferences.setDouble('depth', depth.ft);
          preferences.setBool('metric', false);
        }
      }
      yield state.copyWith(depth: depth);
    }

    if (event is SetTankPressure) {
      var pressure = event.pressure;
      if (state.metric) {
        pressure = PressureBar(pressure.bar.round().roundi(5));
        if (preferences != null) {
          preferences.setInt('pressure', pressure.bar);
          preferences.setBool('metric', true);
        }
      } else {
        pressure = PressurePsi(pressure.psi.round().roundi(100));
        if (preferences != null) {
          preferences.setInt('pressure', pressure.psi);
          preferences.setBool('metric', false);
        }
      }
      yield state.copyWith(tankPressure: pressure);
    }

    if (event is _NewClosed) {
      yield state.copyWith(foldedClosed: event.foldedClosed);
    }

    if (event is ToggleFolding) {
      final foldedClosed = state.foldedClosed ?? {};
      if (foldedClosed.contains(event.id)) {
        foldedClosed.remove(event.id);
      } else {
        foldedClosed.add(event.id);
      }
      yield state.copyWith(foldedClosed: foldedClosed);
      await preferences.setStringList('foldedClosed', foldedClosed.toList());
    }
  }

  Future loadPreferences() async {
    preferences = await SharedPreferences.getInstance();
    final metric = preferences.getBool('metric') ?? true;
    final pres = preferences.getInt('pressure') ?? 200;
    add(SetTankPressure(metric ? PressureBar(pres) : PressurePsi(pres)));

    final dep = preferences.getDouble('depth') ?? 15;
    add(SetDepth(metric ? DistanceM(dep) : DistanceFt(dep)));

    final closed = (preferences.getStringList('foldedClosed') ?? ['rockbottom']).toSet();
    add(_NewClosed(closed));
  }
}
