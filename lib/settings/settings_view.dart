import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/units.dart';
import '../proto/proto.dart';
import 'settings_bloc.dart';

const _appBuild = int.fromEnvironment("BUILD", defaultValue: 0);
const _marketingVer = String.fromEnvironment("MARKETINGVERSION", defaultValue: "0.0.0");
const _gitVer = String.fromEnvironment("GITVERSION", defaultValue: "unknown-dev");

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  SettingsData? prevSettings;

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
                  if (state.settings.principles == Principles.ROCKBOTTOM) ascentTable(context, state.settings),
                  if (state.settings.principles == Principles.ROCKBOTTOM) safetyStopTable(context, state.settings),
                  visualTable(context, state.settings),
                  Divider(
                    height: 32,
                    indent: 32,
                    endIndent: 32,
                  ),
                  Text(
                    "Version $_marketingVer ($_appBuild)\n[$_gitVer]",
                    style: Theme.of(context).textTheme.bodySmall,
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

  Widget generalTable(BuildContext context, SettingsData settings) {
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
              style: t.textTheme.titleSmall!.copyWith(color: t.disabledColor),
            ),
            titledRow(
              title: "System",
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: SegmentedButton<MeasurementSystem>(
                  segments: [
                    ButtonSegment(value: MeasurementSystem.METRIC, label: Text("Metric")),
                    ButtonSegment(value: MeasurementSystem.IMPERIAL, label: Text("Imperial")),
                  ],
                  selected: <MeasurementSystem>{settings.measurements},
                  onSelectionChanged: (p0) => context.read<SettingsBloc>().add(SetMeasurementSystem(p0.first)),
                ),
              ),
            ),
            titledRow(
              title: "Principles",
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: SegmentedButton<Principles>(
                  segments: [
                    ButtonSegment(value: Principles.ROCKBOTTOM, label: Text("Rock bottom")),
                    ButtonSegment(value: Principles.MINGAS, label: Text("Min gas (GUE)")),
                  ],
                  selected: <Principles>{settings.principles},
                  onSelectionChanged: (p0) => context.read<SettingsBloc>().add(SetPrinciples(p0.first)),
                ),
              ),
            ),
            titledRow(
              title: "SAC rate " + (settings.measurements == MeasurementSystem.METRIC ? "(L/min)" : "(cuft/min)"),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: SegmentedButton<Volume>(
                  segments: [
                    if (settings.measurements == MeasurementSystem.METRIC && settings.principles == Principles.ROCKBOTTOM)
                      ButtonSegment(value: VolumeL(10), label: Text("10")),
                    if (settings.measurements == MeasurementSystem.METRIC) ButtonSegment(value: VolumeL(15), label: Text("15")),
                    if (settings.measurements == MeasurementSystem.METRIC) ButtonSegment(value: VolumeL(20), label: Text("20")),
                    if (settings.measurements == MeasurementSystem.METRIC && settings.principles == Principles.ROCKBOTTOM)
                      ButtonSegment(value: VolumeL(25), label: Text("25")),
                    if (settings.measurements == MeasurementSystem.IMPERIAL && settings.principles == Principles.ROCKBOTTOM)
                      ButtonSegment(value: VolumeCuFt(0.4), label: Text("0.4")),
                    if (settings.measurements == MeasurementSystem.IMPERIAL) ButtonSegment(value: VolumeCuFt(0.5), label: Text("0.5")),
                    if (settings.measurements == MeasurementSystem.IMPERIAL) ButtonSegment(value: VolumeCuFt(0.75), label: Text("0.75")),
                    if (settings.measurements == MeasurementSystem.IMPERIAL && settings.principles == Principles.ROCKBOTTOM)
                      ButtonSegment(value: VolumeCuFt(1.0), label: Text("1.0")),
                  ],
                  selected: <Volume>{settings.sacRate},
                  onSelectionChanged: (p0) => context.read<SettingsBloc>().add(UpdateSettings((s) => s..sacRate = p0.first)),
                ),
              ),
            ),
            if (settings.principles == Principles.ROCKBOTTOM)
              titledRow(
                title: "NDL exceeded notice",
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(value: false, label: Text("Shown")),
                      ButtonSegment(value: true, label: Text("Hidden")),
                    ],
                    selected: <bool>{settings.hideNdlNotice},
                    onSelectionChanged: (p0) => context.read<SettingsBloc>().add(UpdateSettings((s) => s..hideNdlNotice = p0.first)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget troubleSolvingTable(BuildContext context, SettingsData settings) {
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
              style: t.textTheme.titleSmall!.copyWith(color: t.disabledColor),
            ),
            Column(
              children: [
                titledRow(
                  title: "Duration",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: SegmentedButton<double>(
                      segments: [
                        ButtonSegment<double>(label: Text("0 min"), value: 0.0),
                        ButtonSegment<double>(label: Text("1 min"), value: 1.0),
                        ButtonSegment<double>(label: Text("2 min"), value: 2.0),
                        ButtonSegment<double>(label: Text("4 min"), value: 4.0),
                      ],
                      selected: <double>{settings.troubleSolvingDuration},
                      onSelectionChanged: (p0) => context.read<SettingsBloc>().add(UpdateSettings((s) => s..troubleSolvingDuration = p0.first)),
                    ),
                  ),
                ),
                if (settings.principles == Principles.ROCKBOTTOM && settings.troubleSolvingDuration > 0)
                  titledRow(
                    title: "SAC multiplier",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: SegmentedButton<double>(
                        segments: [
                          ButtonSegment<double>(label: Text("2×"), value: 2.0),
                          ButtonSegment<double>(label: Text("3×"), value: 3.0),
                          ButtonSegment<double>(label: Text("4×"), value: 4.0),
                        ],
                        selected: <double>{settings.troubleSolvingSacMultiplier},
                        onSelectionChanged: (p0) => context.read<SettingsBloc>().add(UpdateSettings((s) => s..troubleSolvingSacMultiplier = p0.first)),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ascentTable(BuildContext context, SettingsData settings) {
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
              style: t.textTheme.titleSmall!.copyWith(color: t.disabledColor),
            ),
            titledRow(
              title: "SAC multiplier",
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: SegmentedButton<double>(
                  segments: [
                    ButtonSegment<double>(label: Text("1×"), value: 1.0),
                    ButtonSegment<double>(label: Text("2×"), value: 2.0),
                    ButtonSegment<double>(label: Text("3×"), value: 3.0),
                    ButtonSegment<double>(label: Text("4×"), value: 4.0),
                  ],
                  selected: <double>{settings.ascentSacMultiplier},
                  onSelectionChanged: (p0) => context.read<SettingsBloc>().add(UpdateSettings((s) => s..ascentSacMultiplier = p0.first)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget safetyStopTable(BuildContext context, SettingsData settings) {
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
              style: t.textTheme.titleSmall!.copyWith(color: t.disabledColor),
            ),
            titledRow(
              title: "Duration",
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: SegmentedButton<double>(
                  segments: [
                    ButtonSegment<double>(label: Text("None"), value: 0.0),
                    ButtonSegment<double>(label: Text("3 min"), value: 3.0),
                    ButtonSegment<double>(label: Text("5 min"), value: 5.0),
                  ],
                  selected: <double>{settings.safetyStopDuration},
                  onSelectionChanged: (p0) => context.read<SettingsBloc>().add(UpdateSettings((s) => s..safetyStopDuration = p0.first)),
                ),
              ),
            ),
            if (settings.safetyStopDuration > 0)
              titledRow(
                title: "SAC multiplier",
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: SegmentedButton<double>(
                    segments: [
                      ButtonSegment<double>(label: Text("1×"), value: 1.0),
                      ButtonSegment<double>(label: Text("2×"), value: 2.0),
                      ButtonSegment<double>(label: Text("3×"), value: 3.0),
                      ButtonSegment<double>(label: Text("4×"), value: 4.0),
                    ],
                    selected: <double>{settings.safetyStopSacMultiplier},
                    onSelectionChanged: (p0) => context.read<SettingsBloc>().add(UpdateSettings((s) => s..safetyStopSacMultiplier = p0.first)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget visualTable(BuildContext context, SettingsData settings) {
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
              "VISUAL",
              style: t.textTheme.titleSmall!.copyWith(color: t.disabledColor),
            ),
            titledRow(
              title: "Theme color",
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: SegmentedButton<ThemeColor>(
                  segments: [
                    ButtonSegment(value: ThemeColor.BLUE, label: Text("Bl")),
                    ButtonSegment(value: ThemeColor.GREEN, label: Text("Gr")),
                    ButtonSegment(value: ThemeColor.ORANGE, label: Text("Or")),
                    ButtonSegment(value: ThemeColor.PINK, label: Text("Pi")),
                    ButtonSegment(value: ThemeColor.PURPLE, label: Text("Pu")),
                  ],
                  selected: <ThemeColor>{settings.themeColor},
                  onSelectionChanged: (p0) => context.read<SettingsBloc>().add(UpdateSettings((s) => s..themeColor = p0.first)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget titledRow({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title),
          child,
        ],
      ),
    );
  }
}
