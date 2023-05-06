import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';
import 'package:uuid/uuid.dart';

import '../models/cylinder_model.dart';
import '../models/units.dart';
import '../proto/proto.dart';
import 'cylinderlist_bloc.dart';
import 'cylinderlist_edit_view.dart';

class CylinderListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return BlocBuilder<CylinderListBloc, CylinderListState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("Cylinders"),
              pinned: true,
              floating: true,
              actions: [
                TextButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Add..."),
                  onPressed: () => editCylinder(context, null),
                ),
              ],
            ),
            ReorderableSliverList(
              onReorder: (a, b) {
                context.read<CylinderListBloc>().add(Reordercylinders(a, b));
              },
              delegate: ReorderableSliverChildListDelegate(state.cylinders
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: t.cardColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: ListTile(
                          key: ValueKey(c.id),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          leading: c.twinset ? Icon(Icons.looks_two, color: t.colorScheme.primary) : Icon(Icons.looks_one),
                          title: Text(c.name),
                          trailing: Switch(
                            value: c.selected,
                            onChanged: (selected) => context.read<CylinderListBloc>().add(UpdateCylinder(c..selected = selected)),
                          ),
                          onTap: () async => await editCylinder(context, c),
                        ),
                      ),
                    ),
                  )
                  .toList()),
            ),
          ],
        ),
      ),
    );
  }

  Future editCylinder(BuildContext context, CylinderModel? cylinder) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => CylinderEditView(
        cylinder: cylinder?.toData() ?? CylinderData(),
        onChange: (cyl) => context.read<CylinderListBloc>().add(UpdateCylinder(cyl)),
        onDelete: (id) => context.read<CylinderListBloc>().add(DeleteCylinder(id)),
      ),
    );
  }
}
