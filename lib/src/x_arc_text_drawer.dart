import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as v_math;

/// The Text Draw watcher
///
/// Using it for record canvas events happens during rendering arc text
abstract class Watcher {
  /// canvas rotate
  void rotate(double rotation);

  /// canvas scale
  void scale(double scale);

  /// canvas translate
  void translate(double dx, double dy);

  /// canvas restore
  void restore();

  ///canvas save
  void save();

  ///canvas draw text
  void drawText(String text, TextStyle style, Offset position);
}

class _DefaultWatcher extends Watcher {
  @override
  void drawText(String text, TextStyle style, Offset position) {}

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

class XArcTextDrawer {
  /// Draw arc text
  ///
  ///  Parameters:
  /// * canvas [Canvas] -  the canvas
  /// * centerPos [Offset] -  the center position of the arc
  /// * radius [double] - the radius of the arc
  /// * startAngle [double] - the start text angle in degree format (360)
  /// * endAngle [double] - the end text angle in degree format (360)
  /// * textArcDirection[ArcTextDirection] - the direction of the text clockwise or anti-clockwise
  /// * text [String]  - the display text
  /// * textStyle [TextStyle]
  /// * baseline [ArcTextBaseline] - [TextArcBaseline.Inner, TextArcBaseline.Outer, TextArcBaseline.Center] - how text display relative to the arc
  /// * textPainter [TextPainter] - the text painter
  /// * watcher [Watcher] - the canvas watcher
  /// * letterSpacing - the spacing between letters
  static void draw(
      {required Canvas canvas,
      required Offset centerPos,
      required double radius,
      required String text,
      required TextStyle textStyle,
      required TextPainter textPainter,
      double startAngle = 90,
      double endAngle = 90,
      ArcTextDirection textArcDirection = ArcTextDirection.Clockwise,
      ArcTextBaseline baseline = ArcTextBaseline.Outer,
      Watcher? watcher,
      int letterSpacing = 0}) {
    watcher ??= _DefaultWatcher();

    canvas.save();
    watcher.save();

    canvas.translate(centerPos.dx, centerPos.dy);
    watcher.translate(centerPos.dx, centerPos.dy);

    int multiplyDirection =
        textArcDirection == ArcTextDirection.Clockwise ? 1 : -1;

    double deltaAngle = _calcDeltaAngle(startAngle, endAngle, textArcDirection);
    double halfAngle = deltaAngle / 2;

    textPainter.text = TextSpan(text: text, style: textStyle);
    textPainter.layout();
    double textWidth = textPainter.size.width + (letterSpacing * text.length);
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

    if (baseline == ArcTextBaseline.Outer) {
      radius += textHeight / 2;
    } else if (baseline == ArcTextBaseline.Inner) {
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
      final characterWidth = textPainter.size.width + letterSpacing;
      final characterAngle = characterWidth / radius;

      angle += v_math.degrees(characterAngle);
      if (angle > maxAngle) {
        break;
      }
      canvas.rotate(prevIncreaseAngle);
      watcher.rotate(prevIncreaseAngle);

      prevIncreaseAngle = multiplyDirection * characterAngle;
      textPainter.paint(canvas, characterOffset);

      watcher.drawText(character, textStyle, characterOffset);
    }
    canvas.restore();
    watcher.restore();
  }

  static double _calcDeltaAngle(
      double startAngle, double endAngle, ArcTextDirection textArcDirection) {
    if (textArcDirection == ArcTextDirection.Clockwise) {
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

/// Text Arc Base Line
/// The base line of the text with the circle
enum ArcTextBaseline { Outer, Inner, Center }

/// The Arc text direction
enum ArcTextDirection { Clockwise, AntiClockwise }
