import 'package:flutter/material.dart';
import 'package:text_x_arc/text_x_arc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    TextPainter textPainter = TextPainter(
        textAlign: TextAlign.justify, textDirection: TextDirection.ltr);
    XArcTextDrawer.draw(
      canvas: canvas,
      centerPos: Offset(200, 200),
      radius: 100,
      startAngle: 90,
      endAngle: 270,
      textArcDirection: TextArcDirection.AntiClockwise,
      text: 'hôm nay ăn gì thế nhỉ',
      textStyle: TextStyle(color: Colors.white, fontSize: 30),
      baseline: TextArcBaseline.Center,
      watcher: ArcTextWatcher(),
      textPainter: textPainter,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ArcTextWatcher extends Watcher {
  @override
  void drawText(InlineSpan text, TextStyle style) {}

  @override
  void rawPath(Path path, int width) {}

  @override
  void restore() {}

  @override
  void rotate(double rotation) {}

  @override
  void save() {}

  @override
  void scale(double scale) {}

  @override
  void translate(double dx, double dy) {}
}
