import 'package:get_it/get_it.dart';
import 'package:tankbuddy/cylinders/cylinderlist_viewmodel.dart';

import '../cylinders/cylinderlist_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<CylinderListService>(
      () => FakeCylinderListService());
  serviceLocator
      .registerFactory<CylinderListViewModel>(() => CylinderListViewModel());
}
