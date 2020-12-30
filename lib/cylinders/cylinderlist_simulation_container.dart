import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tankbuddy/cylinders/cylinder_edit_view.dart';
import 'package:tankbuddy/cylinders/cylinderlist_viewmodel.dart';
import 'package:tankbuddy/proto/tankbuddy.pb.dart';

import '../services/service_locator.dart';
import 'cylinder_model.dart';
import 'cylinder_simulation_view.dart';
import 'units.dart';

class CylinderSimulationContainer extends StatefulWidget {
  @override
  _CylinderSimulationContainerState createState() =>
      _CylinderSimulationContainerState();
}

class _CylinderSimulationContainerState
    extends State<CylinderSimulationContainer> {
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
          builder: (context, model, child) => Column(children: <Widget>[
            sliders(),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: model.selectedCylinders
                        .map(editableCylinder)
                        .toList() +
                    [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            onPressed: () async =>
                                editCylinder(defaultCylinder()),
                            child: Text("Add cylinder..."),
                          ),
                          FlatButton(
                            onPressed: () {
                              model.toggleMetric();
                            },
                            child: Text(model.metric ? "Metric" : "Imperial"),
                          ),
                        ],
                      ),
                    ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget editableCylinder(CylinderModel c) {
    return InkWell(
      onTap: () async => await editCylinder(c),
      child: cylinder(c),
    );
  }

  Widget cylinder(CylinderModel c) {
    if (model.metric) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MetricCylinderSimulationView(
              cylinder: c,
              pressure: model.pressure,
              sac: model.sac,
              depth: model.depth,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImperialCylinderSimulationView(
              cylinder: c,
              pressure: model.pressure,
              sac: model.sac,
              depth: model.depth,
            ),
          ),
        ),
      );
    }
  }

  Widget sliders() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Table(
        columnWidths: {1: IntrinsicColumnWidth()},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          pressureSlider(),
          depthSlider(),
          sacSlider(),
        ],
      ),
    );
  }

  TableRow pressureSlider() {
    return TableRow(children: [
      model.metric
          ? Slider(
              value: model.pressure.bar.toDouble(),
              min: 0,
              max: 300,
              divisions: 60,
              onChanged: (v) {
                model.pressure = PressureBar(v.toInt());
              })
          : Slider(
              value: model.pressure.psi.toDouble(),
              min: 0,
              max: 4400,
              divisions: 44 * 2,
              onChanged: (v) {
                model.pressure = PressurePsi(v.toInt());
              }),
      Text(
        model.metric
            ? "%d bar".format([model.pressure.bar])
            : "%d psi".format([model.pressure.psi]),
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.caption,
      ),
    ]);
  }

  TableRow depthSlider() {
    return TableRow(
      children: [
        model.metric
            ? Slider(
                value: model.depth.m,
                min: 0,
                max: 40,
                divisions: 40,
                onChanged: (v) {
                  model.depth = DistanceM(v);
                })
            : Slider(
                value: model.depth.ft,
                min: 0,
                max: 130,
                divisions: 13 * 2,
                onChanged: (v) {
                  model.depth = DistanceFt(v);
                }),
        Text(
          model.metric
              ? "%.0f m".format([model.depth.m])
              : "%.0f ft".format([model.depth.ft]),
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  TableRow sacSlider() {
    return TableRow(
      children: [
        model.metric
            ? Slider(
                value: model.sac.liter,
                min: 5,
                max: 30,
                divisions: 25,
                onChanged: (v) {
                  model.sac = VolumeLiter(v);
                })
            : Slider(
                value: model.sac.cuft,
                min: 0,
                max: 1,
                divisions: 10,
                onChanged: (v) {
                  model.sac = VolumeCuFt(v);
                }),
        Text(
          model.metric
              ? "%.0f L/min".format([model.sac.liter])
              : "%.1f cuft/min".format([model.sac.cuft]),
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  Future editCylinder(CylinderModel cylinder) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CylinderEditView(cylinder: cylinder.toData(), model: model),
        ),
      ),
    );
    model.loadData();
  }

  CylinderModel defaultCylinder() {
    return model.metric
        ? CylinderModel.metric(null, "", Metal.STEEL, PressureBar(232),
            VolumeLiter(12), WeightKg(14.5), true)
        : CylinderModel.imperial(null, "", Metal.STEEL, PressurePsi(3442),
            VolumeCuFt(80), WeightLb(28.3), true);
  }
}
