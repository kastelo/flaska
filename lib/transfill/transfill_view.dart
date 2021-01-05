import 'dart:math';

import 'package:flaska/divecalculation/valueunit.dart';
import 'package:flaska/transfill/transfill_result_viewmodel.dart';

import '../models/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cylinder_model.dart';
import '../transfill/transfill_bloc.dart';

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
                        onChanged: (m) =>
                            context.read<TransfillBloc>().add(NewTo(m)),
                        child: TransfillResultView(
                          result: TransfillResultViewModel(
                              from: state.from, to: state.to),
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
  final Widget child;

  const TransfillCylinderEditView({
    @required this.title,
    @required this.cylinders,
    @required this.selected,
    @required this.onChanged,
    this.child,
  });

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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      title,
                      style: t.textTheme.subtitle1
                          .copyWith(color: t.disabledColor),
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
                          metric: selected.metric,
                        ));
                      },
                    ),
                  ),
                ],
              ),
              _PressureSlider(
                value: selected.pressure,
                metric: selected.metric,
                onChanged: (pres) {
                  onChanged(TransfillCylinderModel(
                    cylinder: selected.cylinder,
                    pressure: pres,
                    metric: selected.metric,
                  ));
                },
              ),
              if (child != null) child,
            ],
          )),
    );
  }
}

class TransfillResultView extends StatelessWidget {
  final TransfillResultViewModel result;

  const TransfillResultView({@required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        if (!result.to.cylinder.twinset)
          Row(
            children: [
              Expanded(
                child: ValueUnit(
                    title: "PRESSURE",
                    value: result.resultingPressure.bar.toString(),
                    unit: "bar"),
              )
            ],
          ),
        if (result.to.cylinder.twinset)
          Row(
            children: [
              Expanded(
                child: ValueUnit(
                    title: "T1",
                    value: result.T1Pressure.bar.toString(),
                    unit: "bar"),
              ),
              Expanded(
                child: ValueUnit(
                    title: "T2",
                    value: result.T2Pressure.bar.toString(),
                    unit: "bar"),
              ),
              Expanded(
                child: ValueUnit(
                    title: "TWINSET",
                    value: result.resultingPressure.bar.toString(),
                    unit: "bar"),
              )
            ],
          ),
      ],
    );
  }
}

class _PressureSlider extends StatelessWidget {
  final Pressure value;
  final bool metric;
  final Function(Pressure) onChanged;

  double get _current => metric ? value.bar.toDouble() : value.psi.toDouble();
  double get _max => metric ? 300 : 4000;
  String get _unit => metric ? "bar" : "psi";

  const _PressureSlider(
      {@required this.value, @required this.metric, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
              value: min(_current, _max),
              min: 0,
              max: _max,
              onChanged: (v) {
                final pressure = metric
                    ? PressureBar(v.toInt().roundi(5))
                    : PressurePsi(v.toInt().roundi(100));
                onChanged(pressure);
              }),
        ),
        Text(
          "${_current.toInt()} $_unit",
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
