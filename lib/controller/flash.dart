import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class Flash extends NodeWithSize {
  Flash(Size size, double duration)
      : duration = duration.clamp(0.0, 0.18).toDouble(),
        super(size) {
    MotionTween fade = MotionTween<double>(
      setter: (a) => _opacity = a,
      // Avoid a full-screen white strobe when bosses are defeated repeatedly.
      start: _maxOpacity,
      end: 0.0,
      duration: duration,
    );
    MotionSequence seq = MotionSequence(
      motions: <Motion>[
        fade,
        MotionRemoveNode(node: this),
      ],
    );
    motions.run(seq);
  }

  double duration;
  static const double _maxOpacity = 0.22;
  double _opacity = _maxOpacity;
  final Paint _cachedPaint = Paint();

  @override
  void paint(Canvas canvas) {
    // Update the color
    _cachedPaint.color =
        Color.fromARGB((255.0 * _opacity).toInt(), 255, 255, 255);
    // Fill the area
    applyTransformForPivot(canvas);
    canvas.drawRect(
        Rect.fromLTRB(0.0, 0.0, size.width, size.height), _cachedPaint);
  }
}
