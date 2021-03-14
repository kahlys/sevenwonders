import 'package:flutter/material.dart';

import 'package:numberpicker/numberpicker.dart';

class NumberSelector extends StatelessWidget {
  const NumberSelector({
    Key? key,
    required this.value,
    this.min,
    this.max,
    required this.onChange,
  }) : super(key: key);

  final int value;

  final int? max;

  final int? min;

  final ValueChanged<int?>? onChange;

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      value: this.value,
      minValue: this.min ?? 0,
      maxValue: this.max ?? 999,
      textStyle: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5)),
      selectedTextStyle: TextStyle(fontSize: 16),
      itemWidth: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black26),
      ),
      onChanged: (v) => onChange!(v),
      axis: Axis.horizontal,
    );
  }
}
