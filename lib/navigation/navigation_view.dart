import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cylinderlist/cylinderlist_view.dart';
import '../cylinders/cylinderlist_simulation_container.dart';
import '../services/service_locator.dart';
import 'navigation_viewmodel.dart';

class NavigationView extends StatefulWidget {
  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final model = serviceLocator<NavigationViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationViewModel>(
      create: (context) => model,
      child: Consumer<NavigationViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text('Flaska · ${model.title}'),
          ),
          body: body(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: model.index,
            onTap: model.setIndex,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.calculate),
                label: 'Calculation',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.list),
                label: 'Cylinders',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    switch (model.page) {
      case NavigationPage.CylinderListPage:
        return CylinderListView();
      case NavigationPage.DiveCalculationPage:
        return CylinderSimulationContainer();
      case NavigationPage.SettingsPage:
      default:
        return Placeholder();
    }
  }
}
