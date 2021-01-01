import 'package:flutter_bloc/flutter_bloc.dart';

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

class DiveCalculationBloc
    extends Bloc<DiveCalculationEvent, DiveCalculationState> {
  DiveCalculationBloc()
      : super(DiveCalculationState(
          rockBottom: RockBottomModel(
            depth: DistanceM(15),
            sac: VolumeLiter(15),
            ascentRatePerMin: DistanceM(10),
            troubleSolvingDurationMin: 4,
            safetyStopDepth: DistanceM(5),
            safetyStopDurationMin: 5,
          ),
          tankPressure: PressureBar(200),
          metric: true,
        ));

  @override
  Stream<DiveCalculationState> mapEventToState(
      DiveCalculationEvent event) async* {
    if (event is SetDepth) {
      yield state.copyWith(
          rockBottom: state.rockBottom.copyWith(depth: event.depth));
    }

    if (event is SetSAC) {
      yield state.copyWith(
          rockBottom: state.rockBottom.copyWith(sac: event.sac));
    }

    if (event is SetMetric) {
      yield state.copyWith(metric: event.metric);
    }

    if (event is SetTankPressure) {
      yield state.copyWith(tankPressure: event.pressure);
    }
  }
}
