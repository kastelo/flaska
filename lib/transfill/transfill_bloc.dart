import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cylinderlist/cylinderlist_bloc.dart';
import '../models/cylinder_model.dart';
import '../models/units.dart';
import '../proto/proto.dart';
import '../settings/settings_bloc.dart';
import 'transfill_result_viewmodel.dart';

class TransfillState {
  final SettingsData? settings;
  final List<CylinderModel>? cylinders;
  final TransfillCylinderModel? from;
  final TransfillCylinderModel? to;

  bool get metric => settings!.measurements == MeasurementSystem.METRIC;
  bool get init => settings != null && cylinders != null;
  bool get valid => settings != null && cylinders != null && from != null && to != null;

  const TransfillState({this.settings, this.cylinders, this.from, this.to});

  const TransfillState.empty()
      : settings = null,
        cylinders = null,
        from = null,
        to = null;

  TransfillState copyWith({
    SettingsData? settings,
    List<CylinderModel>? cylinders,
    TransfillCylinderModel? from,
    TransfillCylinderModel? to,
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
  final TransfillCylinderModel? from;
  const NewFrom(this.from);
}

class NewTo extends TransfillEvent {
  final TransfillCylinderModel? to;
  const NewTo(this.to);
}

class TransfillBloc extends Bloc<TransfillEvent, TransfillState> {
  late StreamSubscription settingsSub;
  late StreamSubscription cylindersSub;
  SharedPreferences? preferences;

  TransfillBloc(SettingsBloc settingsBloc, CylinderListBloc cylinderListBloc) : super(TransfillState.empty()) {
    on<_NewSettings>((event, emit) async {
      final newState = state.copyWith(settings: event.settings);
      if (preferences == null) {
        if (newState.init) {
          await loadPreferences();
        }
      } else if (newState.metric != state.metric) {
        preferences!.setBool('metric', newState.metric);
        if (state.from != null) add(NewFrom(state.from));
        if (state.to != null) add(NewTo(state.to));
      }
      emit(newState);
    });

    on<_NewCylinders>((event, emit) async {
      final selCylinders = event.cylinders.where((c) => c.selected).toList();
      var newState = state.copyWith(cylinders: selCylinders);
      if (newState.cylinders!.isNotEmpty) {
        if (newState.from == null || !selCylinders.contains(newState.from!.cylinder)) {
          newState = newState.copyWith(
            from: TransfillCylinderModel(
              cylinder: selCylinders.first,
              pressure: PressureBar(220),
            ),
          );
        }
        if (newState.to == null || !selCylinders.contains(newState.to!.cylinder)) {
          newState = newState.copyWith(
            to: TransfillCylinderModel(
              cylinder: selCylinders.first,
              pressure: PressureBar(50),
            ),
          );
        }
      }
      emit(newState);
      if (preferences == null && newState.init) {
        await loadPreferences();
      }
    });

    on<NewFrom>((event, emit) async {
      emit(state.copyWith(from: event.from));
      if (preferences != null) {
        preferences!.setInt('fromPressure', state.metric ? event.from!.pressure.bar : event.from!.pressure.psi);
        preferences!.setString('fromCylinder', event.from!.cylinder.id.toString());
      }
    });

    on<NewTo>((event, emit) async {
      emit(state.copyWith(to: event.to));
      if (preferences != null) {
        preferences!.setInt('toPressure', state.metric ? event.to!.pressure.bar : event.to!.pressure.psi);
        preferences!.setString('toCylinder', event.to!.cylinder.id.toString());
      }
    });

    this.add(_NewSettings(settingsBloc.state.settings));
    settingsSub = settingsBloc.stream.listen((settingsState) {
      this.add(_NewSettings(settingsState.settings));
    });

    this.add(_NewCylinders(cylinderListBloc.state.cylinders));
    cylindersSub = cylinderListBloc.stream.listen((cylindersState) {
      this.add(_NewCylinders(cylindersState.cylinders));
    });
  }

  @override
  Future<void> close() {
    settingsSub.cancel();
    cylindersSub.cancel();
    return super.close();
  }

  Future loadPreferences() async {
    preferences = await SharedPreferences.getInstance();
    final metric = preferences!.getBool('metric') ?? true;
    final fromCylinder = preferences!.getString('fromCylinder');
    final toCylinder = preferences!.getString('toCylinder');
    final fromPressure = preferences!.getInt('fromPressure');
    final toPressure = preferences!.getInt('toPressure');

    if (fromCylinder != null && fromPressure != null) {
      final cyl = state.cylinders!.firstWhereOrNull((c) => c.id.toString() == fromCylinder);
      final press = metric ? PressureBar(fromPressure) : PressurePsi(fromPressure);
      if (cyl != null) {
        add(NewFrom(TransfillCylinderModel(cylinder: cyl, pressure: press)));
      }
    }

    if (toCylinder != null && toPressure != null) {
      final cyl = state.cylinders!.firstWhereOrNull((c) => c.id.toString() == toCylinder);
      final press = metric ? PressureBar(toPressure) : PressurePsi(toPressure);
      if (cyl != null) {
        add(NewTo(TransfillCylinderModel(cylinder: cyl, pressure: press)));
      }
    }
  }
}
