import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

/// A short luminous slash showing the lane crossed by the player's phase shift.
class PhaseShiftTrail extends Node {
  PhaseShiftTrail({required this.direction, required this.distance}) {
    zPosition = 190.0;
  }

  final double direction;
  final double distance;
  double _elapsed = 0.0;

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= 0.32) removeFromParent();
  }

  @override
  void paint(Canvas canvas) {
    final progress = (_elapsed / 0.32).clamp(0.0, 1.0).toDouble();
    final opacity = 1.0 - progress;
    final reach = distance * 0.5 * (0.78 + progress * 0.22);
    final path = Path()
      ..moveTo(-direction * reach, -10.0)
      ..quadraticBezierTo(0.0, 0.0, direction * reach, 10.0);

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF55E8FF).withValues(alpha: 0.72 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0 * (1.0 - progress * 0.55)
        ..strokeCap = StrokeCap.round
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8.0),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFE5FFFF).withValues(alpha: 0.92 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );
  }
}

/// An expanding energy ring marks the end of the dash and the blade impact.
class PhaseShiftPulse extends Node {
  PhaseShiftPulse() {
    zPosition = 190.0;
  }

  double _elapsed = 0.0;

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= 0.38) removeFromParent();
  }

  @override
  void paint(Canvas canvas) {
    final progress = (_elapsed / 0.38).clamp(0.0, 1.0).toDouble();
    final opacity = 1.0 - progress;
    final radius = 9.0 + progress * 35.0;
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = const Color(0xFF55E8FF).withValues(alpha: 0.65 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0 * opacity
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 5.0),
    );
    canvas.drawCircle(
      Offset.zero,
      radius * 0.68,
      Paint()
        ..color = const Color(0xFFD9FCFF).withValues(alpha: 0.42 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }
}
