import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

import '../models/cylinder_model.dart';
import '../models/units.dart';
import '../services/service_locator.dart';
import 'cylinder_simulation_view.dart';
import 'cylinder_simulation_viewmodel.dart';

class CylinderSimulationContainer extends StatefulWidget {
  @override
  _CylinderSimulationContainerState createState() =>
      _CylinderSimulationContainerState();
}

class _CylinderSimulationContainerState
    extends State<CylinderSimulationContainer>
    with AutomaticKeepAliveClientMixin {
  final CylinderSimulationViewModel model =
      serviceLocator<CylinderSimulationViewModel>();

  @override
  initState() {
    model.loadData();
    super.initState();
  }

  @override
  bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<CylinderSimulationViewModel>(
      create: (context) => model,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<CylinderSimulationViewModel>(
          builder: (context, model, child) => Column(children: <Widget>[
            sliders(),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                      rockBottom(),
                    ] +
                    model.selectedCylinders.map(cylinder).toList() +
                    [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
              rockBottom: model.rockBottom,
              pressure: model.pressure,
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
              rockBottom: model.rockBottom,
              pressure: model.pressure,
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
          depthSlider(),
          sacSlider(),
          pressureSlider(),
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

  Widget rockBottom() {
    final rbg = model.metric
        ? sprintf(
            "Rock bottom gas is %.0f L, based on %.0f min at %.0f m followed by ascent at %.0f m/min (both at %.0f L/min SAC) and %.0f min safety stop at %.0f m (at %.0f L/min SAC).",
            [
                model.rockBottom.volume.liter,
                model.rockBottom.troubleSolvingDurationMin,
                model.rockBottom.depth.m,
                model.rockBottom.ascentRatePerMin.m,
                model.rockBottom.sac.liter * 4,
                model.rockBottom.safetyStopDurationMin,
                model.rockBottom.safetyStopDepth.m,
                model.rockBottom.sac.liter * 2,
              ])
        : sprintf(
            "Rock bottom gas is %.0f cuft, based on %.0f min at %.0f ft followed by ascent at %.0f ft/min (both at %.1f cuft/min SAC) and %.0f min safety stop at %.0f ft (at %.1f cuft/min SAC).",
            [
                model.rockBottom.volume.cuft,
                model.rockBottom.troubleSolvingDurationMin,
                model.rockBottom.depth.m,
                model.rockBottom.ascentRatePerMin.ft,
                model.rockBottom.sac.liter * 4,
                model.rockBottom.safetyStopDurationMin,
                model.rockBottom.safetyStopDepth.m,
                model.rockBottom.sac.liter * 2,
              ]);
    return Text(rbg);
  }
}
