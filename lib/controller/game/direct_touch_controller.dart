import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

/// Replaces the VirtualJoystick — the player touches anywhere on screen
/// and the ship flies directly to the finger position.
class DirectTouchController extends NodeWithSize {
  DirectTouchController(Size screenSize) : super(screenSize) {
    userInteractionEnabled = true;
    handleMultiplePointers = false;
    _paintDot = Paint()
      ..color = const Color(0xAAFFFFFF)
      ..style = PaintingStyle.fill;
    _paintRing = Paint()
      ..color = const Color(0x66FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
  }

  /// Current touch position in sprite-box coordinates (null when not touching).
  Offset? touchPosition;

  /// True while the screen is being touched.
  bool get isDown => touchPosition != null;

  late Paint _paintDot;
  late Paint _paintRing;
  double _pulseAngle = 0.0;

  @override
  bool handleEvent(SpriteBoxEvent event) {
    if (event.type == PointerEventType.down ||
        event.type == PointerEventType.move) {
      touchPosition = event.boxPosition;
    } else if (event.type == PointerEventType.up ||
        event.type == PointerEventType.cancel) {
      touchPosition = null;
    }
    return true;
  }

  @override
  void update(double dt) {
    _pulseAngle += dt * 4.0;
  }

  @override
  void paint(Canvas canvas) {
    if (touchPosition == null) return;

    // Pulsing glow ring
    double ringRadius = 18.0 + math.sin(_pulseAngle) * 4.0;
    double opacity = 0.3 + math.sin(_pulseAngle) * 0.2;
    _paintRing.color = Color.fromARGB((opacity * 255).toInt(), 255, 255, 255);
    canvas.drawCircle(touchPosition!, ringRadius, _paintRing);

    // Solid center dot
    canvas.drawCircle(touchPosition!, 5.0, _paintDot);
  }
}
