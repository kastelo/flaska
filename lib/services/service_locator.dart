import 'package:get_it/get_it.dart';

import 'cylinderlist_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<CylinderListService>(
      () => LocalCylinderListService());
}
