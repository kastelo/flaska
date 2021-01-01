import 'package:flaska/navigation/navigation_view.dart';
import 'package:get_it/get_it.dart';

import '../cylinderlist/cylinderlist_viewmodel.dart';
import '../navigation/navigation_viewmodel.dart';
import 'cylinderlist_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<CylinderListService>(
      () => LocalCylinderListService());

  serviceLocator.registerFactory(() => NavigationViewModel());
  serviceLocator.registerFactory(() => CylinderListViewModel());
}
