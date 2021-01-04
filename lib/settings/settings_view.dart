import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/units.dart';
import '../proto/proto.dart';
import 'settings_bloc.dart';

const _appBuild = int.fromEnvironment("BUILD", defaultValue: 0);
const _marketingVer =
    String.fromEnvironment("MARKETINGVERSION", defaultValue: "0.0.0");
const _gitVer =
    String.fromEnvironment("GITVERSION", defaultValue: "unknown-dev");

final _decimalExp = RegExp(r'[0-9\.,]');
double parseDouble(String s) {
  return double.parse(s.trim().replaceAll(",", "."), (_) => 0.0);
}

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
  SettingsData prevSettings;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("Settings"),
              pinned: true,
              floating: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: formTable(context, state.settings),
                  ),
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
          ],
        ),
      ),
    );
  }

  Widget formTable(BuildContext context, SettingsData settings) {
    if (settings != prevSettings) {
      prevSettings = settings;

      _sacRateController.text = settings.isMetric
          ? settings.sacRate.liter.toString()
          : settings.sacRate.cuft.toString();

      _troubleSolvingDurationController.text =
          settings.troubleSolvingDuration.toString();
      _troubleSolvingSacMultiplierController.text =
          settings.troubleSolvingSacMultiplier.toString();

      _ascentRateController.text = settings.isMetric
          ? settings.ascentRate.m.toString()
          : settings.ascentRate.ft.toString();
      _ascentSacMultiplierController.text =
          settings.ascentSacMultiplier.toString();

      _safetyStopDurationController.text =
          settings.safetyStopDuration.toString();
      _safetyStopDepthController.text = settings.isMetric
          ? settings.safetyStopDepth.m.toString()
          : settings.safetyStopDepth.ft.toString();
      _safetyStopSacMultiplierController.text =
          settings.safetyStopSacMultiplier.toString();
    }

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
            dropdownColor: Theme.of(context).cardColor,
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
          child: FocusScope(
            onFocusChange: (focus) {
              if (focus) return;
              final d = parseDouble(_sacRateController.text);
              final vol = settings.isMetric ? VolumeLiter(d) : VolumeCuFt(d);
              context
                  .read<SettingsBloc>()
                  .add(UpdateSettings((s) => s..sacRate = vol));
            },
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
              controller: _sacRateController,
            ),
          ),
          metric: "L/min",
          imperial: "cuft/min",
          settings: settings,
        ),
        headerRow(context: context, title: "Trouble solving"),
        titledRow(
          title: "Duration",
          child: FocusScope(
            onFocusChange: (focus) {
              if (focus) return;
              final d = parseDouble(_troubleSolvingDurationController.text);
              context
                  .read<SettingsBloc>()
                  .add(UpdateSettings((s) => s..troubleSolvingDuration = d));
            },
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
              controller: _troubleSolvingDurationController,
            ),
          ),
          trailer: "min",
        ),
        titledRow(
          title: "SAC multiplier",
          child: FocusScope(
            onFocusChange: (focus) {
              if (focus) return;
              final d =
                  parseDouble(_troubleSolvingSacMultiplierController.text);
              context.read<SettingsBloc>().add(
                  UpdateSettings((s) => s..troubleSolvingSacMultiplier = d));
            },
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
              controller: _troubleSolvingSacMultiplierController,
            ),
          ),
          trailer: "×",
        ),
        headerRow(context: context, title: "Ascent"),
        titledUnitRow(
          title: "Ascent rate",
          child: FocusScope(
            onFocusChange: (focus) {
              if (focus) return;
              final d = parseDouble(_ascentRateController.text);
              final rate = settings.isMetric ? DistanceM(d) : DistanceFt(d);
              context
                  .read<SettingsBloc>()
                  .add(UpdateSettings((s) => s..ascentRate = rate));
            },
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
              controller: _ascentRateController,
            ),
          ),
          metric: "m/min",
          imperial: "ft/min",
          settings: settings,
        ),
        titledRow(
          title: "SAC multiplier",
          child: FocusScope(
            onFocusChange: (focus) {
              if (focus) return;
              final d = parseDouble(_ascentSacMultiplierController.text);
              context
                  .read<SettingsBloc>()
                  .add(UpdateSettings((s) => s..ascentSacMultiplier = d));
            },
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
              controller: _ascentSacMultiplierController,
            ),
          ),
          trailer: "×",
        ),
        headerRow(context: context, title: "Safety stop"),
        titledRow(
          title: "Duration",
          child: FocusScope(
            onFocusChange: (focus) {
              if (focus) return;
              final d = parseDouble(_safetyStopDurationController.text);
              context
                  .read<SettingsBloc>()
                  .add(UpdateSettings((s) => s..safetyStopDuration = d));
            },
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
              controller: _safetyStopDurationController,
            ),
          ),
          trailer: "min",
        ),
        titledUnitRow(
          title: "Depth",
          child: FocusScope(
            onFocusChange: (focus) {
              if (focus) return;
              final d = parseDouble(_safetyStopDepthController.text);
              final dep = settings.isMetric ? DistanceM(d) : DistanceFt(d);
              context
                  .read<SettingsBloc>()
                  .add(UpdateSettings((s) => s..safetyStopDepth = dep));
            },
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
              controller: _safetyStopDepthController,
            ),
          ),
          metric: "m",
          imperial: "ft",
          settings: settings,
        ),
        titledRow(
          title: "SAC multiplier",
          child: FocusScope(
            onFocusChange: (focus) {
              if (focus) return;
              final d = parseDouble(_safetyStopSacMultiplierController.text);
              context
                  .read<SettingsBloc>()
                  .add(UpdateSettings((s) => s..safetyStopSacMultiplier = d));
            },
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
              controller: _safetyStopSacMultiplierController,
            ),
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
