import 'package:flutter/material.dart';

class CustomGrid extends StatelessWidget {
  const CustomGrid({
    super.key,
    required this.children,
    required this.rowWidth,
  });
  final List<Widget> children;
  final int rowWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: grid(context),
    );
  }

  List<Widget> grid(context) {
    int filledColumns = (children.length / rowWidth).floor();
    int remainder = children.length % rowWidth;
    bool hasRemainder = remainder != 0;

    return [
      if (filledColumns != 0)
        ...List.generate(
          filledColumns,
          (index) => Row(
            children: List.generate(
              rowWidth,
              (rowIndex) =>
                  Expanded(child: children[(rowWidth * index) + rowIndex]),
            ),
          ),
        ),
      if (hasRemainder)
        Row(
          children: [
            ...List.generate(
              remainder,
              (rowIndex) => Expanded(
                  child: children[(rowWidth * filledColumns) + rowIndex]),
            ),
            ...List.generate(
              rowWidth - (remainder),
              (index) => const Spacer(),
            )
          ],
        )
    ];
  }
}
