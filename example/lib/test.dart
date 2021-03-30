import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:text_x_arc/text_x_arc.dart';

main() {
  runApp(CustomPaint(
    painter: MyPainter(),
  ));
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerPos = Offset(size.width / 2, size.height / 2);
    TextPainter textPainter = TextPainter(
        textAlign: TextAlign.justify, textDirection: TextDirection.ltr);
    XArcTextDrawer.draw(
        canvas: canvas,
        centerPos: centerPos,
        radius: 200,
        text:
            'Without requirements or design, programming is the art of adding bugs to an empty text file.',
        textStyle: TextStyle(color: Colors.black, fontSize: 20),
        textPainter: textPainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
