import 'package:flaska/services/service_locator.dart';
import 'package:flaska/services/settings_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/units.dart';
import '../proto/proto.dart';

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

class SetSAC extends SettingsEvent {
  final Volume sac;
  const SetSAC(this.sac);
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
      yield SettingsState(event.settings);
    }
  }
}
