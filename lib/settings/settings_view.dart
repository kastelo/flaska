import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/units.dart';
import '../proto/proto.dart';
import 'settings_bloc.dart';

const _appBuild = int.fromEnvironment("BUILD", defaultValue: 0);
const _marketingVer = String.fromEnvironment("MARKETINGVERSION", defaultValue: "0.0.0");
const _gitVer = String.fromEnvironment("GITVERSION", defaultValue: "unknown-dev");

final _decimalExp = RegExp(r'[0-9\.,]');
final _integerExp = RegExp(r'[0-9]');

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
  final _minPressureController = TextEditingController();
  final _maxPressureController = TextEditingController();
  final _pressureStepController = TextEditingController();
  final _minDepthController = TextEditingController();
  final _maxDepthController = TextEditingController();
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
                  generalTable(context, state.settings),
                  troubleSolvingTable(context, state.settings),
                  ascentTable(context, state.settings),
                  safetyStopTable(context, state.settings),
                  pressureSlidersTable(context, state.settings),
                  depthSlidersTable(context, state.settings),
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

  SettingsData _generalSettings;
  Widget generalTable(BuildContext context, SettingsData settings) {
    if (settings != _generalSettings) {
      _generalSettings = settings;

      _sacRateController.text = settings.isMetric ? settings.sacRate.l.toString() : settings.sacRate.cuft.toString();
    }

    final t = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "GENERAL",
              style: t.textTheme.subtitle2.copyWith(color: t.disabledColor),
            ),
            Table(
              columnWidths: {
                0: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <TableRow>[
                titledRow(
                  title: "System",
                  child: DropdownButton<MeasurementSystem>(
                    dropdownColor: Theme.of(context).cardColor,
                    value: settings.measurements,
                    items: [
                      DropdownMenuItem(value: MeasurementSystem.METRIC, child: Text("Metric")),
                      DropdownMenuItem(value: MeasurementSystem.IMPERIAL, child: Text("Imperial")),
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
                      final vol = settings.isMetric ? VolumeL(d) : VolumeCuFt(d);
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..sacRate = vol));
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  SettingsData _troubleSolvingSettings;
  Widget troubleSolvingTable(BuildContext context, SettingsData settings) {
    if (settings != _troubleSolvingSettings) {
      _troubleSolvingSettings = settings;

      _troubleSolvingDurationController.text = settings.troubleSolvingDuration.toString();
      _troubleSolvingSacMultiplierController.text = settings.troubleSolvingSacMultiplier.toString();
    }

    final t = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "TROUBLE SOLVING",
              style: t.textTheme.subtitle2.copyWith(color: t.disabledColor),
            ),
            Table(
              columnWidths: {
                0: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <TableRow>[
                titledRow(
                  title: "Duration",
                  child: FocusScope(
                    onFocusChange: (focus) {
                      if (focus) return;
                      final d = parseDouble(_troubleSolvingDurationController.text);
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..troubleSolvingDuration = d));
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
                      final d = parseDouble(_troubleSolvingSacMultiplierController.text);
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..troubleSolvingSacMultiplier = d));
                    },
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
                      controller: _troubleSolvingSacMultiplierController,
                    ),
                  ),
                  trailer: "×",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SettingsData _ascentSettings;
  Widget ascentTable(BuildContext context, SettingsData settings) {
    if (settings != _ascentSettings) {
      _ascentSettings = settings;

      _ascentRateController.text = settings.isMetric ? settings.ascentRate.m.toString() : settings.ascentRate.ft.toString();
      _ascentSacMultiplierController.text = settings.ascentSacMultiplier.toString();
    }

    final t = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "ASCENT",
              style: t.textTheme.subtitle2.copyWith(color: t.disabledColor),
            ),
            Table(
              columnWidths: {
                0: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <TableRow>[
                titledUnitRow(
                  title: "Ascent rate",
                  child: FocusScope(
                    onFocusChange: (focus) {
                      if (focus) return;
                      final d = parseDouble(_ascentRateController.text);
                      final rate = settings.isMetric ? DistanceM(d) : DistanceFt(d);
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..ascentRate = rate));
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
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..ascentSacMultiplier = d));
                    },
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(_decimalExp)],
                      controller: _ascentSacMultiplierController,
                    ),
                  ),
                  trailer: "×",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SettingsData _safetyStopSettings;
  Widget safetyStopTable(BuildContext context, SettingsData settings) {
    if (settings != _safetyStopSettings) {
      _safetyStopSettings = settings;

      _safetyStopDurationController.text = settings.safetyStopDuration.toString();
      _safetyStopDepthController.text = settings.isMetric ? settings.safetyStopDepth.m.toInt().toString() : settings.safetyStopDepth.ft.toInt().toString();
      _safetyStopSacMultiplierController.text = settings.safetyStopSacMultiplier.toString();
    }

    final t = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "SAFETY STOP",
              style: t.textTheme.subtitle2.copyWith(color: t.disabledColor),
            ),
            Table(
              columnWidths: {
                0: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <TableRow>[
                titledRow(
                  title: "Duration",
                  child: FocusScope(
                    onFocusChange: (focus) {
                      if (focus) return;
                      final d = parseDouble(_safetyStopDurationController.text);
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..safetyStopDuration = d));
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
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..safetyStopDepth = dep));
                    },
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(_integerExp)],
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
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..safetyStopSacMultiplier = d));
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
            ),
          ],
        ),
      ),
    );
  }

  SettingsData _pressureSlidersSettings;
  Widget pressureSlidersTable(BuildContext context, SettingsData settings) {
    if (settings != _pressureSlidersSettings) {
      _pressureSlidersSettings = settings;

      _minPressureController.text = settings.isMetric ? settings.minPressure.bar.toString() : settings.minPressure.psi.toString();
      _maxPressureController.text = settings.isMetric ? settings.maxPressure.bar.toString() : settings.maxPressure.psi.toString();
      _pressureStepController.text = settings.isMetric ? settings.pressureStep.bar.toString() : settings.pressureStep.psi.toString();
    }

    final t = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "PRESSURE SLIDERS",
              style: t.textTheme.subtitle2.copyWith(color: t.disabledColor),
            ),
            Table(
              columnWidths: {
                0: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <TableRow>[
                titledUnitRow(
                  title: "Min Pressure",
                  child: FocusScope(
                    onFocusChange: (focus) {
                      if (focus) return;
                      final d = int.parse(_minPressureController.text, onError: (_) => 0);
                      final pres = settings.isMetric ? PressureBar(d) : PressurePsi(d);
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..minPressure = pres));
                    },
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(_integerExp)],
                      controller: _minPressureController,
                    ),
                  ),
                  metric: "bar",
                  imperial: "psi",
                  settings: settings,
                ),
                titledUnitRow(
                  title: "Max Pressure",
                  child: FocusScope(
                    onFocusChange: (focus) {
                      if (focus) return;
                      final d = int.parse(_maxPressureController.text, onError: (_) => 0);
                      final pres = settings.isMetric ? PressureBar(d) : PressurePsi(d);
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..maxPressure = pres));
                    },
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(_integerExp)],
                      controller: _maxPressureController,
                    ),
                  ),
                  metric: "bar",
                  imperial: "psi",
                  settings: settings,
                ),
                titledUnitRow(
                  title: "Pressure Step",
                  child: FocusScope(
                    onFocusChange: (focus) {
                      if (focus) return;
                      final d = int.parse(_pressureStepController.text, onError: (_) => 0);
                      final pres = settings.isMetric ? PressureBar(d) : PressurePsi(d);
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..pressureStep = pres));
                    },
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(_integerExp)],
                      controller: _pressureStepController,
                    ),
                  ),
                  metric: "bar",
                  imperial: "psi",
                  settings: settings,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SettingsData _depthSlidersSettings;
  Widget depthSlidersTable(BuildContext context, SettingsData settings) {
    if (settings != _depthSlidersSettings) {
      _depthSlidersSettings = settings;

      _minDepthController.text = settings.isMetric ? settings.minDepth.m.toInt().toString() : settings.minDepth.ft.toInt().toString();
      _maxDepthController.text = settings.isMetric ? settings.maxDepth.m.toInt().toString() : settings.maxDepth.ft.toInt().toString();
    }

    final t = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "DEPTH SLIDERS",
              style: t.textTheme.subtitle2.copyWith(color: t.disabledColor),
            ),
            Table(
              columnWidths: {
                0: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <TableRow>[
                titledUnitRow(
                  title: "Min Depth",
                  child: FocusScope(
                    onFocusChange: (focus) {
                      if (focus) return;
                      final d = parseDouble(_minDepthController.text);
                      final depth = settings.isMetric ? DistanceM(d) : DistanceFt(d);
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..minDepth = depth));
                    },
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(_integerExp)],
                      controller: _minDepthController,
                    ),
                  ),
                  metric: "m",
                  imperial: "ft",
                  settings: settings,
                ),
                titledUnitRow(
                  title: "Max Depth",
                  child: FocusScope(
                    onFocusChange: (focus) {
                      if (focus) return;
                      final d = parseDouble(_maxDepthController.text);
                      final depth = settings.isMetric ? DistanceM(d) : DistanceFt(d);
                      context.read<SettingsBloc>().add(UpdateSettings((s) => s..minDepth = depth));
                    },
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(_integerExp)],
                      controller: _maxDepthController,
                    ),
                  ),
                  metric: "m",
                  imperial: "ft",
                  settings: settings,
                ),
              ],
            ),
          ],
        ),
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
        child: Text(title, style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey)),
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
      trailer == null || trailer.isEmpty ? Container() : Padding(padding: const EdgeInsets.only(left: 16.0), child: Text(trailer)),
    ]);
  }

  TableRow titledUnitRow({String title, Widget child, String metric, String imperial, SettingsData settings}) {
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
        child: Text(settings.measurements == MeasurementSystem.METRIC ? metric : imperial),
      )
    ]);
  }
}

class WithUnit extends StatelessWidget {
  final MeasurementSystem measurements;
  final String metric;
  final String imperial;
  final Widget child;

  const WithUnit({@required this.measurements, @required this.metric, @required this.imperial, @required this.child});

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
