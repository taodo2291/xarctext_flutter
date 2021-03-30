import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';

import 'package:text_x_arc/text_x_arc.dart';

void main() {
  final dashbook = Dashbook(
    theme: ThemeData(),
  );
  dashbook.storiesOf('XArtTextDrawer').decorator(CenterDecorator()).add(
        'Arc Text',
        (context) => Container(
          width: 300,
          child: CustomPaint(
            painter: ArcTextPainter(
              ArcTextExampleModel(
                startAngle: context.numberProperty('start Angle(degree)', 90),
                endAngle: context.numberProperty('end Angle(degree)', 90),
                baseline: context.listProperty('text baseline',
                    ArcTextBaseline.Outer, ArcTextBaseline.values),
                letterSpacing:
                    context.numberProperty('letter spacing', 0.0).toInt(),
                radius: context.numberProperty('radius', 200),
                text: context.textProperty('text',
                    'Without requirements or design, programming is the art of adding bugs to an empty text file.'),
                textDirection: context.listProperty('text direction',
                    ArcTextDirection.Clockwise, ArcTextDirection.values),
                drawCircle: context.boolProperty('draw circle', true),
                style: TextStyle(
                    backgroundColor:
                        context.colorProperty('background', Colors.white),
                    color: context.colorProperty('text color', Colors.black),
                    fontSize: context.numberProperty('font size', 20),
                    fontStyle: context.listProperty(
                        'font style', FontStyle.normal, FontStyle.values),
                    fontWeight: context.listProperty(
                        'font weight', FontWeight.normal, FontWeight.values)),
              ),
            ),
          ),
        ),
      );
  runApp(dashbook);
}

class ArcTextExampleModel {
  double radius;
  double startAngle;
  double endAngle;
  ArcTextDirection textDirection;
  String text;
  int letterSpacing;
  ArcTextBaseline baseline;
  bool drawCircle;
  TextStyle style;

  ArcTextExampleModel({
    required this.radius,
    required this.startAngle,
    required this.endAngle,
    required this.textDirection,
    required this.text,
    required this.letterSpacing,
    required this.baseline,
    required this.drawCircle,
    required this.style,
  });
}

class ArcTextPainter extends CustomPainter {
  final ArcTextExampleModel model;

  ArcTextPainter(this.model);

  @override
  void paint(Canvas canvas, Size size) {
    final centerPos = Offset(size.width / 2, size.height / 2);
    TextPainter textPainter = TextPainter(
        textAlign: TextAlign.justify, textDirection: TextDirection.ltr);
    XArcTextDrawer.draw(
      canvas: canvas,
      centerPos: Offset(size.width / 2, size.height / 2),
      radius: model.radius,
      startAngle: model.startAngle,
      endAngle: model.endAngle,
      textArcDirection: model.textDirection,
      text: model.text,
      textStyle: model.style,
      baseline: model.baseline,
      textPainter: textPainter,
      letterSpacing: model.letterSpacing,
    );

    if (model.drawCircle) {
      canvas.drawCircle(
          centerPos, model.radius, Paint()..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
