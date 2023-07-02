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

  bool get metric => settings.measurements == MeasurementSystem.METRIC;
  RockBottomModel get rockBottom => RockBottomModel.fromSettings(settings, depth);

  bool foldedOpen(String id) => !foldedClosed.contains(id);

  const DiveCalculationState({
    required this.settings,
    required this.depth,
    required this.tankPressure,
    required this.foldedClosed,
  });

  DiveCalculationState.empty()
      : settings = SettingsData(),
        depth = const DistanceM(10),
        tankPressure = const PressureBar(200),
        foldedClosed = const {};

  DiveCalculationState copyWith({
    SettingsData? settings,
    Distance? depth,
    Pressure? tankPressure,
    Set<String>? foldedClosed,
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
  late StreamSubscription settingsSub;
  SharedPreferences? preferences;

  DiveCalculationBloc(SettingsBloc settingsBloc) : super(DiveCalculationState.empty()) {
    on<_NewSettings>((event, emit) async {
      final newState = state.copyWith(settings: event.settings);
      if (preferences == null) {
        await loadPreferences();
      } else if (newState.metric != state.metric) {
        add(SetTankPressure(newState.tankPressure));
        add(SetDepth(newState.depth));
      }
      emit(newState);
    });

    on<SetDepth>((event, emit) async {
      var depth = event.depth;
      if (state.metric) {
        depth = DistanceM(depth.m.round().toDouble());
        if (preferences != null) {
          preferences!.setDouble('depth', depth.m);
          preferences!.setBool('metric', true);
        }
      } else {
        depth = DistanceFt(depth.ft.round().roundi(10).toDouble());
        if (preferences != null) {
          preferences!.setDouble('depth', depth.ft);
          preferences!.setBool('metric', false);
        }
      }
      emit(state.copyWith(depth: depth));
    });

    on<SetTankPressure>((event, emit) async {
      var pressure = event.pressure;
      if (state.metric) {
        pressure = PressureBar(pressure.bar.round().roundi(10));
        if (preferences != null) {
          preferences!.setInt('pressure', pressure.bar);
          preferences!.setBool('metric', true);
        }
      } else {
        pressure = PressurePsi(pressure.psi.round().roundi(100));
        if (preferences != null) {
          preferences!.setInt('pressure', pressure.psi);
          preferences!.setBool('metric', false);
        }
      }
      emit(state.copyWith(tankPressure: pressure));
    });

    on<_NewClosed>((event, emit) async {
      emit(state.copyWith(foldedClosed: event.foldedClosed));
    });

    on<ToggleFolding>((event, emit) async {
      final foldedClosed = state.foldedClosed;
      if (foldedClosed.contains(event.id)) {
        foldedClosed.remove(event.id);
      } else {
        foldedClosed.add(event.id);
      }
      emit(state.copyWith(foldedClosed: foldedClosed));
      await preferences!.setStringList('foldedClosed', foldedClosed.toList());
    });

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

  Future loadPreferences() async {
    preferences = await SharedPreferences.getInstance();
    final metric = preferences!.getBool('metric') ?? true;
    final pres = preferences!.getInt('pressure') ?? 200;
    add(SetTankPressure(metric ? PressureBar(pres) : PressurePsi(pres)));

    final dep = preferences!.getDouble('depth') ?? 15;
    add(SetDepth(metric ? DistanceM(dep) : DistanceFt(dep)));

    final closed = (preferences!.getStringList('foldedClosed') ?? ['rockbottom']).toSet();
    add(_NewClosed(closed));
  }
}
