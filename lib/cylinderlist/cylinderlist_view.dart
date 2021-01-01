import 'package:flutter/material.dart';

import '../services/service_locator.dart';
import 'cylinderlist_viewmodel.dart';

class CylinderListView extends StatefulWidget {
  @override
  _CylinderListViewState createState() => _CylinderListViewState();
}

class _CylinderListViewState extends State<CylinderListView> {
  final CylinderListViewModel model = serviceLocator<CylinderListViewModel>();

  @override
  initState() {
    model.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}
