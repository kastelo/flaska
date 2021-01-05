import 'dart:async';

import 'package:flaska/transfill/transfill_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cylinderlist/cylinderlist_bloc.dart';
import '../models/cylinder_model.dart';
import '../models/rockbottom_model.dart';
import '../models/units.dart';
import '../proto/proto.dart';
import '../settings/settings_bloc.dart';

class TransfillState {
  final SettingsData settings;
  final List<CylinderModel> cylinders;
  final TransfillCylinderModel from;
  final TransfillCylinderModel to;

  bool get init => settings != null && cylinders != null;
  bool get valid =>
      settings != null && cylinders != null && from != null && to != null;

  const TransfillState({this.settings, this.cylinders, this.from, this.to});

  const TransfillState.empty()
      : settings = null,
        cylinders = null,
        from = null,
        to = null;

  TransfillState copyWith({
    SettingsData settings,
    List<CylinderModel> cylinders,
    TransfillCylinderModel from,
    TransfillCylinderModel to,
  }) =>
      TransfillState(
        settings: settings ?? this.settings,
        cylinders: cylinders ?? this.cylinders,
        from: from ?? this.from,
        to: to ?? this.to,
      );
}

class TransfillEvent {
  const TransfillEvent();
}

class _NewSettings extends TransfillEvent {
  final SettingsData settings;
  const _NewSettings(this.settings);
}

class _NewCylinders extends TransfillEvent {
  final List<CylinderModel> cylinders;
  const _NewCylinders(this.cylinders);
}

class NewFrom extends TransfillEvent {
  final TransfillCylinderModel from;
  const NewFrom(this.from);
}

class NewTo extends TransfillEvent {
  final TransfillCylinderModel to;
  const NewTo(this.to);
}

class TransfillBloc extends Bloc<TransfillEvent, TransfillState> {
  StreamSubscription settingsSub;
  StreamSubscription cylindersSub;
  SharedPreferences preferences;

  TransfillBloc(SettingsBloc settingsBloc, CylinderListBloc cylinderListBloc)
      : super(TransfillState.empty()) {
    this.add(_NewSettings(settingsBloc.state.settings));
    settingsSub = settingsBloc.listen((settingsState) {
      this.add(_NewSettings(settingsState.settings));
    });

    this.add(_NewCylinders(cylinderListBloc.state.cylinders));
    cylindersSub = cylinderListBloc.listen((cylindersState) {
      this.add(_NewCylinders(cylindersState.cylinders));
    });
  }

  @override
  Future<void> close() {
    settingsSub.cancel();
    cylindersSub.cancel();
    return super.close();
  }

  @override
  Stream<TransfillState> mapEventToState(TransfillEvent event) async* {
    if (event is _NewSettings) {
      final newState = state.copyWith(settings: event.settings);
      yield newState;
      if (preferences == null && newState.init) {
        await loadPreferences();
      }
    }

    if (event is _NewCylinders) {
      var newState = state.copyWith(cylinders: event.cylinders);
      if (newState.to == null) {
        newState = newState.copyWith(
          to: TransfillCylinderModel(
            cylinder: newState.cylinders.first,
            pressure: PressureBar(50),
            metric: state.settings.isMetric,
          ),
        );
      }
      if (newState.from == null) {
        newState = newState.copyWith(
          from: TransfillCylinderModel(
            cylinder: newState.cylinders.first,
            pressure: PressureBar(220),
            metric: state.settings.isMetric,
          ),
        );
      }
      yield newState;
      if (preferences == null && newState.init) {
        await loadPreferences();
      }
    }

    if (event is NewFrom) {
      yield state.copyWith(from: event.from);
    }

    if (event is NewTo) {
      yield state.copyWith(to: event.to);
    }
  }

  Future loadPreferences() async {
    preferences = await SharedPreferences.getInstance();
    final metric = preferences.getBool('metric') ?? true;
    final fromCylinder = preferences.getString('fromCylinder');
    final toCylinder = preferences.getString('toCylinder');
    final fromPressure = preferences.getInt('fromPressure') ?? 15;
    final toPressure = preferences.getInt('toPressure') ?? 15;
  }
}

class TransfillCylinderModel {
  final CylinderModel cylinder;
  final Pressure pressure;
  final bool metric;

  const TransfillCylinderModel({this.cylinder, this.pressure, this.metric});
}
