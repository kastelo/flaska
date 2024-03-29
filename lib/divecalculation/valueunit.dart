import 'package:flutter/material.dart';

class ValueUnit extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const ValueUnit({required this.title, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final valueStyle = t.textTheme.headlineSmall;
    final titleStyle = t.textTheme.titleSmall!.copyWith(color: t.colorScheme.primary);
    final unitStyle = t.textTheme.bodyLarge!.copyWith(color: t.disabledColor);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: titleStyle,
                textAlign: TextAlign.right,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                value,
                style: valueStyle,
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                " " + unit,
                style: unitStyle,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
