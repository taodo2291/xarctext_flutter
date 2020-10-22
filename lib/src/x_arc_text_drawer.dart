import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as v_math;

abstract class Watcher {
  void rotate(double rotation);
  void scale(double scale);
  void translate(double dx, double dy);
  void restore();
  void save();
  void drawText(InlineSpan text, TextStyle style);
  void rawPath(Path path, int width);
}

class XArcTextDrawer {
  /// Draw arc text
  ///
  ///  Parameters:
  /// * canvas [Canvas] -  the canvas
  /// * centerPos [Offset] -  the center position of the arc
  /// * radius [double] - the radius of the arc
  /// * startAngle [double] - the start text angle in degree format (360)
  /// * endAngle [double] - the end text angle in degree format (360)
  /// * textArcDirection[TextArcDirection] - the direction of the text clockwise or anti-clockwise
  /// * text [String]  - the display text
  /// * textStyle [TextStyle]
  /// * baseline [TextArcBaseline] - [TextArcBaseline.Inner, TextArcBaseline.Outer, TextArcBaseline.Center] - how text display relative to the arc
  /// * textPainter [TextPainter] - the text painter
  static void draw(
      {@required Canvas canvas,
      @required Offset centerPos,
      @required double radius,
      @required double startAngle,
      @required double endAngle,
      @required TextArcDirection textArcDirection,
      @required String text,
      @required TextStyle textStyle,
      @required TextArcBaseline baseline,
      @required TextPainter textPainter,
      @required Watcher watcher,
      int letterSpacing = 0}) {
    canvas.save();
    watcher.save();

    canvas.translate(centerPos.dx, centerPos.dy);
    watcher.translate(centerPos.dx, centerPos.dy);

    int multiplyDirection =
        textArcDirection == TextArcDirection.Clockwise ? 1 : -1;
    //find delta angle
    double deltaAngle = _calcDeltaAngle(startAngle, endAngle, textArcDirection);
    double halfAngle = deltaAngle / 2;

    textPainter.text = TextSpan(text: text, style: textStyle);
    textPainter.layout();
    double textWidth = textPainter.size.width -
        (letterSpacing * text.length); //bonus each character 1 pixel
    double textHeight = textPainter.size.height;

    double arcAngleByText = v_math.degrees(textWidth / radius);
    double actualStartAngle;
    double maxAngle = deltaAngle;
    if (deltaAngle > arcAngleByText) {
      actualStartAngle = startAngle +
          multiplyDirection * halfAngle -
          multiplyDirection * arcAngleByText / 2;
    } else {
      actualStartAngle = startAngle;
    }

    if (baseline == TextArcBaseline.Outer) {
      radius += textHeight / 2;
    } else if (baseline == TextArcBaseline.Inner) {
      radius -= textHeight / 2;
    }

    Offset characterOffset =
        Offset(0, -radius * multiplyDirection - textHeight / 2);
    final rotationInRadian =
        v_math.radians(actualStartAngle + multiplyDirection * 90);
    canvas.rotate(rotationInRadian);
    watcher.rotate(rotationInRadian);

    double angle = 0;
    double prevIncreaseAngle = 0;

    for (String character in text.characters) {
      textPainter.text = TextSpan(text: character, style: textStyle);
      textPainter.layout();
      final characterWidth = textPainter.size.width - letterSpacing;
      final characterAngle = characterWidth / radius;

      angle += v_math.degrees(characterAngle);
      if (angle > maxAngle) {
        break;
      }
      canvas.rotate(prevIncreaseAngle);
      watcher.rotate(prevIncreaseAngle);

      prevIncreaseAngle = multiplyDirection * characterAngle;
      textPainter.paint(canvas, characterOffset);

      watcher.drawText(textPainter.text, textStyle);
    }
    canvas.restore();
    watcher.restore();
  }

  static double _calcDeltaAngle(
      double startAngle, double endAngle, TextArcDirection textArcDirection) {
    if (textArcDirection == TextArcDirection.Clockwise) {
      if (endAngle <= startAngle) {
        return 360 - (startAngle - endAngle);
      }
      return endAngle - startAngle;
    } else {
      if (startAngle > endAngle) {
        return startAngle - endAngle;
      }
      return 360 - (endAngle - startAngle);
    }
  }
}

enum TextArcBaseline { Outer, Inner, Center }
enum TextArcDirection { Clockwise, AntiClockwise }
