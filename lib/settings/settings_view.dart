import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../proto/proto.dart';
import 'settings_bloc.dart';

const _appBuild = int.fromEnvironment("BUILD", defaultValue: 0);
const _marketingVer =
    String.fromEnvironment("MARKETINGVERSION", defaultValue: "0.0.0");
const _gitVer =
    String.fromEnvironment("GITVERSION", defaultValue: "unknown-dev");

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _sacRateController = TextEditingController();
  final _troubleSolvingDurationController = TextEditingController();
  final _troubleSolvingSacMultiplierController = TextEditingController();
  final _ascentRateController = TextEditingController();
  final _ascentSacMultiplierController = TextEditingController();
  final _safetyStopDurationController = TextEditingController();
  final _safetyStopDepthController = TextEditingController();
  final _safetyStopSacMultiplierController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => GestureDetector(
          onTap: () {
            var currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                formTable(context, state.settings),
                Divider(
                  height: 32,
                  indent: 32,
                  endIndent: 32,
                ),
                Text(
                  "Version $_marketingVer ($_appBuild)\n[$_gitVer]",
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formTable(BuildContext context, SettingsData settings) {
    _sacRateController.text = settings.sacRate.toString();

    _troubleSolvingDurationController.text =
        settings.troubleSolvingDuration.toString();
    _troubleSolvingSacMultiplierController.text =
        settings.troubleSolvingSacMultiplier.toString();

    _ascentRateController.text = settings.ascentRate.toString();
    _ascentSacMultiplierController.text =
        settings.ascentSacMultiplier.toString();

    _safetyStopDurationController.text = settings.safetyStopDuration.toString();
    _safetyStopDepthController.text = settings.safetyStopDepth.toString();
    _safetyStopSacMultiplierController.text =
        settings.safetyStopSacMultiplier.toString();

    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      children: <TableRow>[
        headerRow(context: context, title: "General"),
        titledRow(
          title: "System",
          child: DropdownButton<MeasurementSystem>(
            value: settings.measurements,
            items: [
              DropdownMenuItem(
                  value: MeasurementSystem.METRIC, child: Text("Metric")),
              DropdownMenuItem(
                  value: MeasurementSystem.IMPERIAL, child: Text("Imperial")),
            ],
            onChanged: (value) {
              context.read<SettingsBloc>().add(SetMeasurementSystem(value));
            },
          ),
        ),
        titledUnitRow(
          title: "SAC Rate",
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
            ],
            controller: _sacRateController,
            onChanged: (value) {},
          ),
          metric: "L/min",
          imperial: "ft³/min",
          settings: settings,
        ),
        headerRow(context: context, title: "Trouble solving"),
        titledRow(
          title: "Duration",
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
            ],
            controller: _troubleSolvingDurationController,
            onChanged: (value) {},
          ),
          trailer: "min",
        ),
        titledRow(
          title: "SAC multiplier",
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
            ],
            controller: _troubleSolvingSacMultiplierController,
            onChanged: (value) {},
          ),
          trailer: "×",
        ),
        headerRow(context: context, title: "Ascent"),
        titledUnitRow(
          title: "Ascent rate",
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
            ],
            controller: _ascentRateController,
            onChanged: (value) {},
          ),
          metric: "m/min",
          imperial: "ft/min",
          settings: settings,
        ),
        titledRow(
          title: "SAC multiplier",
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
            ],
            controller: _ascentSacMultiplierController,
            onChanged: (value) {},
          ),
          trailer: "×",
        ),
        headerRow(context: context, title: "Safety stop"),
        titledRow(
          title: "Duration",
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
            ],
            controller: _safetyStopDurationController,
            onChanged: (value) {},
          ),
          trailer: "min",
        ),
        titledUnitRow(
          title: "Depth",
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
            ],
            controller: _safetyStopDepthController,
            onChanged: (value) {},
          ),
          metric: "m",
          imperial: "ft",
          settings: settings,
        ),
        titledRow(
          title: "SAC multiplier",
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
            ],
            controller: _safetyStopSacMultiplierController,
            onChanged: (value) {},
          ),
          trailer: "×",
        ),
      ],
    );
  }

  Widget troubleSolvingTable(SettingsData settings) {
    return Form(
      child: Table(
        columnWidths: {
          0: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
        children: <TableRow>[],
      ),
    );
  }

  TableRow headerRow({
    BuildContext context,
    String title,
  }) {
    return TableRow(children: [
      Container(),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.grey)),
      ),
      Container(),
    ]);
  }

  TableRow titledRow({String title, Widget child, String trailer}) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Text(
          title + ":",
          textAlign: TextAlign.right,
        ),
      ),
      child,
      trailer == null || trailer.isEmpty
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(left: 16.0), child: Text(trailer)),
    ]);
  }

  TableRow titledUnitRow(
      {String title,
      Widget child,
      String metric,
      String imperial,
      SettingsData settings}) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Text(
          title + ":",
          textAlign: TextAlign.right,
        ),
      ),
      child,
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(settings.measurements == MeasurementSystem.METRIC
            ? metric
            : imperial),
      )
    ]);
  }
}

class WithUnit extends StatelessWidget {
  final MeasurementSystem measurements;
  final String metric;
  final String imperial;
  final Widget child;

  const WithUnit(
      {@required this.measurements,
      @required this.metric,
      @required this.imperial,
      @required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: child),
        Text(measurements == MeasurementSystem.METRIC ? metric : imperial),
      ],
    );
  }
}
