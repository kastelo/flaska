import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../divecalculation/pressureslider.dart';
import '../divecalculation/valueunit.dart';
import '../models/cylinder_model.dart';
import '../models/units.dart';
import '../proto/proto.dart';
import 'transfill_bloc.dart';
import 'transfill_result_viewmodel.dart';

class TransfillView extends StatefulWidget {
  @override
  _TransfillViewState createState() => _TransfillViewState();
}

class _TransfillViewState extends State<TransfillView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransfillBloc, TransfillState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text("Transfill"),
                pinned: true,
                floating: true,
              ),
              if (state.valid)
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TransfillCylinderEditView(
                        title: "From",
                        cylinders: state.cylinders,
                        selected: state.from,
                        settings: state.settings,
                        onChanged: (m) =>
                            context.read<TransfillBloc>().add(NewFrom(m)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TransfillCylinderEditView(
                        title: "To",
                        cylinders: state.cylinders,
                        selected: state.to,
                        settings: state.settings,
                        onChanged: (m) =>
                            context.read<TransfillBloc>().add(NewTo(m)),
                        child: TransfillResultView(
                          result: TransfillResultViewModel(
                            from: state.from,
                            to: state.to,
                          ),
                          metric: state.metric,
                        ),
                      ),
                    ),
                  ]),
                ),
            ],
          ),
        );
      },
    );
  }
}

class TransfillCylinderEditView extends StatelessWidget {
  final String title;
  final List<CylinderModel> cylinders;
  final TransfillCylinderModel selected;
  final Function(TransfillCylinderModel) onChanged;
  final SettingsData settings;
  final Widget child;

  const TransfillCylinderEditView({
    @required this.title,
    @required this.cylinders,
    @required this.selected,
    @required this.onChanged,
    @required this.settings,
    this.child,
  });

  bool get metric => settings.isMetric;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: 30,
                      child: Text(
                        title,
                        style: t.textTheme.caption
                            .copyWith(color: t.disabledColor),
                      ),
                    ),
                  ),
                  Expanded(
                    child: DropdownButton(
                      value: selected.cylinder,
                      items: cylinders
                          .map((c) =>
                              DropdownMenuItem(value: c, child: Text(c.name)))
                          .toList(),
                      onChanged: (cyl) {
                        onChanged(TransfillCylinderModel(
                          cylinder: cyl,
                          pressure: selected.pressure,
                        ));
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("With",
                      style:
                          t.textTheme.caption.copyWith(color: t.disabledColor)),
                  Expanded(
                    child: PressureSlider(
                      value: selected.pressure,
                      metric: metric,
                      minValue: settings.minPressure,
                      maxValue: settings.maxPressure,
                      step: settings.pressureStep,
                      onChanged: (pres) {
                        onChanged(TransfillCylinderModel(
                          cylinder: selected.cylinder,
                          pressure: pres,
                        ));
                      },
                    ),
                  ),
                ],
              ),
              if (child != null) child,
            ],
          )),
    );
  }
}

class TransfillResultView extends StatelessWidget {
  final TransfillResultViewModel result;
  final bool metric;

  String get _unit => metric ? "bar" : "psi";
  String _pressure(Pressure p) => metric ? p.bar.toString() : p.psi.toString();

  const TransfillResultView({@required this.result, @required this.metric});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Divider(),
        ),
        if (!result.to.cylinder.twinset)
          Row(
            children: [
              Expanded(
                child: ValueUnit(
                    title: "PRESSURE",
                    value: _pressure(result.resultingPressure),
                    unit: _unit),
              )
            ],
          ),
        if (result.to.cylinder.twinset)
          Row(
            children: [
              Expanded(
                child: ValueUnit(
                    title: "T1",
                    value: _pressure(result.T1Pressure),
                    unit: _unit),
              ),
              Expanded(
                child: ValueUnit(
                    title: "T2",
                    value: _pressure(result.T2Pressure),
                    unit: _unit),
              ),
              Expanded(
                child: ValueUnit(
                    title: "TWINSET",
                    value: _pressure(result.resultingPressure),
                    unit: _unit),
              )
            ],
          ),
      ],
    );
  }
}
