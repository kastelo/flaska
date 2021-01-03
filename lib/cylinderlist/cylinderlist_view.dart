import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../models/cylinder_model.dart';
import '../models/units.dart';
import '../proto/proto.dart';
import 'cylinderlist_bloc.dart';
import 'cylinderlist_edit_view.dart';

final _defaultNewCylinder = CylinderModel.imperial(null, "", Metal.ALUMINIUM,
    PressurePsi(3000), VolumeCuFt(77.4), WeightLb(31.9), false, true);

class CylinderListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CylinderListBloc, CylinderListState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: state.cylinders
                  .map(
                    (c) => ListTile(
                      title: Text(c.name),
                      trailing: Switch(
                        value: c.selected,
                        onChanged: (selected) => context
                            .read<CylinderListBloc>()
                            .add(UpdateCylinder(c..selected = selected)),
                      ),
                      onTap: () async => await editCylinder(context, c),
                    ) as Widget,
                  )
                  .toList() +
              [
                OutlinedButton(
                  child: Text("Add cylinder..."),
                  onPressed: () => editCylinder(context, _defaultNewCylinder),
                ),
              ],
        ),
      ),
    );
  }

  Future editCylinder(BuildContext context, CylinderModel cylinder) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => CylinderEditView(
        cylinder: cylinder.toData(),
        onChange: (cyl) =>
            context.read<CylinderListBloc>().add(UpdateCylinder(cyl)),
        onDelete: (id) =>
            context.read<CylinderListBloc>().add(DeleteCylinder(id)),
      ),
    );
  }
}
