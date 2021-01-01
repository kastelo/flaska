import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cylinderlist/cylinderlist_view.dart';
import '../cylinders/cylinderlist_simulation_container.dart';

class NavigationView extends StatefulWidget {
  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flaska'),
        ),
        body: TabBarView(
          children: [
            CylinderSimulationContainer(),
            CylinderListView(),
            Placeholder(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(text: "Calculator", icon: Icon(Icons.calculate)),
            Tab(text: "Cylinders", icon: Icon(Icons.list)),
            Tab(text: "Settings", icon: Icon(Icons.settings)),
          ],
        ),
      ),
    );
  }
}
