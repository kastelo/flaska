import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/rockbottom_model.dart';
import '../models/units.dart';
import '../proto/proto.dart';
import '../settings/settings_bloc.dart';

class DiveCalculationState {
  final RockBottomModel rockBottom;
  final Pressure tankPressure;
  final bool metric;

  bool get valid =>
      rockBottom != null && tankPressure != null && metric != null;

  Distance get depth => rockBottom.depth;
  Volume get sac => rockBottom.sac;

  const DiveCalculationState({
    this.rockBottom,
    this.tankPressure,
    this.metric,
  });

  const DiveCalculationState.empty()
      : rockBottom = null,
        tankPressure = null,
        metric = null;

  DiveCalculationState copyWith({
    RockBottomModel rockBottom,
    Pressure tankPressure,
    bool metric,
  }) =>
      DiveCalculationState(
        rockBottom: rockBottom ?? this.rockBottom,
        tankPressure: tankPressure ?? this.tankPressure,
        metric: metric ?? this.metric,
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

class DiveCalculationBloc
    extends Bloc<DiveCalculationEvent, DiveCalculationState> {
  StreamSubscription settingsSub;
  SharedPreferences preferences;

  DiveCalculationBloc(SettingsBloc settingsBloc)
      : super(DiveCalculationState.empty()) {
    settingsSub = settingsBloc.listen((settingsState) {
      this.add(_NewSettings(settingsState.settings));
    });
  }

  @override
  Future<void> close() {
    settingsSub.cancel();
    return super.close();
  }

  @override
  Stream<DiveCalculationState> mapEventToState(
      DiveCalculationEvent event) async* {
    if (event is _NewSettings) {
      final newState = state.copyWith(
        metric: event.settings.isMetric,
        rockBottom: RockBottomModel(
          depth: state.rockBottom?.depth ?? DistanceM(15),
          sac: event.settings.sacRate,
          ascentRatePerMin: event.settings.ascentRate,
          ascentSacMultiplier: event.settings.ascentSacMultiplier,
          troubleSolvingDurationMin: event.settings.troubleSolvingDuration,
          troubleSolvingSacMultiplier:
              event.settings.troubleSolvingSacMultiplier,
          safetyStopDepth: event.settings.safetyStopDepth,
          safetyStopDurationMin: event.settings.safetyStopDuration,
          safetyStopSacMultiplier: event.settings.safetyStopSacMultiplier,
        ),
      );
      if (preferences == null) {
        await loadPreferences();
      } else if (newState.metric != state.metric) {
        add(SetTankPressure(newState.tankPressure));
        add(SetDepth(newState.rockBottom.depth));
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
      yield state.copyWith(rockBottom: state.rockBottom.copyWith(depth: depth));
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
  }

  Future loadPreferences() async {
    preferences = await SharedPreferences.getInstance();
    final metric = preferences.getBool('metric') ?? true;
    final pres = preferences.getInt('pressure') ?? 200;
    final dep = preferences.getDouble('depth') ?? 15;
    add(SetTankPressure(metric ? PressureBar(pres) : PressurePsi(pres)));
    add(SetDepth(metric ? DistanceM(dep) : DistanceFt(dep)));
  }
}
