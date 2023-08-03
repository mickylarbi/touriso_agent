import 'package:flutter/material.dart';

class RowViewText extends StatelessWidget {
  const RowViewText(
      {super.key, required this.texts, this.color, this.textStyle});
  final List<String> texts;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: color,
      child: Row(
        children: texts
            .map((e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.centerLeft,
                  width: 200,
                  child: Text(
                    e,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class RowViewWidgets extends StatelessWidget {
  const RowViewWidgets(
      {super.key, required this.widgets, this.color, this.textStyle});
  final List<Widget> widgets;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: color,
      child: Row(
        children: widgets
            .map((e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.centerLeft,
                  width: 200,
                  child: e,
                ))
            .toList(),
      ),
    );
  }
}
