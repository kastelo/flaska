import 'dart:async';

import 'package:flaska/proto/flaska.pbserver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings/settings_bloc.dart';
import '../models/units.dart';
import '../models/rockbottom_model.dart';

class DiveCalculationState {
  final RockBottomModel rockBottom;
  final Pressure tankPressure;
  final bool metric;

  Distance get depth => rockBottom.depth;
  Volume get sac => rockBottom.sac;

  const DiveCalculationState({
    this.rockBottom,
    this.tankPressure,
    this.metric,
  });

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

class SetSAC extends DiveCalculationEvent {
  final Volume sac;
  const SetSAC(this.sac);
}

class SetMetric extends DiveCalculationEvent {
  final bool metric;
  const SetMetric(this.metric);
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

  DiveCalculationBloc(SettingsBloc settingsBloc)
      : super(DiveCalculationState(
          rockBottom: RockBottomModel(
            depth: DistanceM(15),
            sac: VolumeLiter(15),
            ascentRatePerMin: DistanceM(10),
            ascentSacMultiplier: 4,
            troubleSolvingDurationMin: 4,
            troubleSolvingSacMultiplier: 4,
            safetyStopDepth: DistanceM(5),
            safetyStopDurationMin: 5,
            safetyStopSacMultiplier: 2,
          ),
          tankPressure: PressureBar(200),
          metric: true,
        )) {
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
          depth: state.rockBottom.depth,
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
      yield newState;
    }

    if (event is SetDepth) {
      var depth = event.depth;
      if (state.metric) {
        depth = DistanceM(depth.m.round().toDouble());
      } else {
        depth = DistanceFt(depth.ft.round().roundi(10).toDouble());
      }
      yield state.copyWith(rockBottom: state.rockBottom.copyWith(depth: depth));
    }

    if (event is SetSAC) {
      var sac = event.sac;
      if (state.metric) {
        sac = VolumeLiter(sac.liter.round().toDouble());
      } else {
        sac = VolumeCuFt((sac.liter * 10).round() / 10);
      }
      yield state.copyWith(rockBottom: state.rockBottom.copyWith(sac: sac));
    }

    if (event is SetMetric) {
      yield state.copyWith(metric: event.metric);
    }

    if (event is SetTankPressure) {
      var pressure = event.pressure;
      if (state.metric) {
        pressure = PressureBar(pressure.bar.round().roundi(5));
      } else {
        pressure = PressurePsi(pressure.psi.round().roundi(100));
      }
      yield state.copyWith(tankPressure: pressure);
    }
  }
}
