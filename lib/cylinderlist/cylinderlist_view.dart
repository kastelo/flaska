import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';

import '../models/cylinder_model.dart';
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
                context.read<CylinderListBloc>().add(CylinderListEvent.reorder(a, b));
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
                          title: Text(c.name),
                          leading: Switch(
                            value: c.selected,
                            onChanged: (selected) => context.read<CylinderListBloc>().add(CylinderListEvent.update(c..selected = selected)),
                          ),
                          trailing: c.twinset
                              ? RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(Icons.view_stream),
                                )
                              : null,
                          onTap: () async => await editCylinder(context, c),
                        ),
                      ),
                    ),
                  )
                  .toList()),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButtonTheme(
                  data: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error)),
                  child: TextButton.icon(
                    icon: Icon(Icons.restart_alt),
                    label: Text("Reset to default"),
                    onPressed: () async {
                      final res = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Reset to default"),
                          content: Text("Are you sure you want to reset the cylinder list to the default?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Reset", style: TextStyle(color: Theme.of(context).colorScheme.error)),
                            ),
                          ],
                        ),
                      );
                      if (context.mounted && res == true) {
                        context.read<CylinderListBloc>().add(CylinderListEvent.reset());
                      }
                    },
                  ),
                ),
              ),
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
        onChange: (cyl) => context.read<CylinderListBloc>().add(CylinderListEvent.update(cyl)),
        onDelete: (id) => context.read<CylinderListBloc>().add(CylinderListEvent.delete(id)),
      ),
    );
  }
}
