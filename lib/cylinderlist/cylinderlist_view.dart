import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cylinders/cylinder_edit_view.dart';
import '../models/cylinder_model.dart';
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
    return ChangeNotifierProvider<CylinderListViewModel>(
      create: (context) => model,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<CylinderListViewModel>(
          builder: (context, model, child) => ListView(
            children: model.cylinders
                .map(
                  (c) => ListTile(
                    title: Text(c.name),
                    trailing: Checkbox(
                      value: c.selected,
                      onChanged: (_) {},
                    ),
                    onTap: () async => await editCylinder(c),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Future editCylinder(CylinderModel cylinder) async {
    await showDialog(
      context: context,
      builder: (context) =>
          CylinderEditView(cylinder: cylinder.toData(), model: model),
    );
    model.loadData();
  }
}
