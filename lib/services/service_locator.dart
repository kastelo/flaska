import 'package:flaska/services/settings_service.dart';
import 'package:get_it/get_it.dart';

import 'cylinderlist_service.dart';
import 'settings_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<CylinderListService>(
      () => LocalCylinderListService());
  serviceLocator
      .registerLazySingleton<SettingsService>(() => LocalSettingsService());
}
