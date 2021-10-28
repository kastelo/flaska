import 'package:flaska/divecalculation/divecalculation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Foldable extends StatelessWidget {
  final String id;
  final Widget child;
  final Widget title;

  const Foldable({
    @required this.id,
    @required this.child,
    @required this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiveCalculationBloc, DiveCalculationState, bool>(
      selector: (state) => state.foldedOpen(id),
      builder: (context, open) => GestureDetector(
        onTap: () {
          BlocProvider.of<DiveCalculationBloc>(context).add(ToggleFolding(id));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).cardColor.withOpacity(open ? 1.0 : 0.75),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: open ? 1.0 : 0.5,
                  child: title,
                ),
                AnimatedCrossFade(
                  crossFadeState: open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 300),
                  firstChild: Column(
                    children: [
                      Divider(),
                      child,
                    ],
                  ),
                  secondChild: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
