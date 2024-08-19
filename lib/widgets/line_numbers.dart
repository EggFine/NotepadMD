import 'package:flutter/material.dart';
import 'dart:math' as math;

class LineNumbers extends StatelessWidget {
  final int lineCount;
  final ScrollController scrollController;
  final TextStyle textStyle;

  const LineNumbers({
    Key? key,
    required this.lineCount,
    required this.scrollController,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: ListView.builder(
        controller: scrollController,
        itemCount: math.max(lineCount, 1),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Text(
              '${index + 1}',
              style: textStyle,
              textAlign: TextAlign.right,
            ),
          );
        },
      ),
    );
  }
}