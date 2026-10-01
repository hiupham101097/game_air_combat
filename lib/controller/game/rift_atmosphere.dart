import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

/// Animated dimensional-rift layer that sits between the starfield and ships.
/// Its color and intensity shift as the campaign approaches the invasion core.
class RiftAtmosphere extends NodeWithSize {
  RiftAtmosphere({required bool eventMode})
      : _eventMode = eventMode,
        super(Size.zero) {
    if (eventMode) _sector = 3;
  }

  final bool _eventMode;
  int _sector = 0;
  double _time = 0.0;
  double _scroll = 0.0;

  Color get _riftColor => switch (_sector) {
        1 => const Color(0xFF2FE4DB),
        2 => const Color(0xFFB46CFF),
        _ => const Color(0xFFFF563F),
      };

  void setSector(int sector) {
    _sector = _eventMode ? 3 : sector.clamp(0, 3);
  }

  void advance(double dt, double scrollSpeed) {
    _time += dt;
    _scroll += scrollSpeed * 0.34;
    if (size.height > 0) _scroll %= size.height;
  }

  @override
  void spriteBoxPerformedLayout() {
    final visibleSize = spriteBox?.visibleArea?.size;
    if (visibleSize != null && visibleSize != Size.zero) size = visibleSize;
  }

  @override
  void paint(Canvas canvas) {
    if ((_sector == 0 && !_eventMode) || size.isEmpty) return;

    final width = size.width;
    final height = size.height;
    final color = _riftColor;
    final sway = math.sin(_time * 0.34);
    final center = Offset(width * (0.5 + sway * 0.13),
        height * (0.32 + math.sin(_time * 0.21) * 0.1));
    final radiusX = width * (0.19 + math.sin(_time * 0.8).abs() * 0.035);
    final radiusY = height * 0.115;
    final portalRect = Rect.fromCenter(
        center: center, width: radiusX * 2.4, height: radiusY * 2.8);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()
        ..shader = ui.Gradient.radial(
          center,
          width * 0.6,
          [color.withAlpha(_sector == 3 ? 30 : 18), Colors.transparent],
        ),
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(sway * 0.08);
    for (var ring = 0; ring < 3; ring++) {
      final inset = ring * 9.0;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: portalRect.width - inset * 2,
          height: portalRect.height - inset * 2,
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = ring == 0 ? 2.2 : 1.1
          ..color = color.withAlpha(50 - ring * 10)
          ..maskFilter =
              ui.MaskFilter.blur(ui.BlurStyle.normal, ring == 0 ? 7 : 3),
      );
    }
    canvas.restore();

    final seam = Path()
      ..moveTo(center.dx + sway * 7, center.dy - radiusY * 1.1);
    for (var segment = 1; segment <= 9; segment++) {
      final y = center.dy - radiusY * 1.1 + segment * radiusY * 0.25;
      final wobble = math.sin(segment * 2.7 + _time * 0.75) * width * 0.025;
      seam.lineTo(center.dx + wobble, y);
    }
    final glow = Paint()
      ..color = color.withAlpha(_sector == 3 ? 96 : 70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _sector == 3 ? 3.2 : 2.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 5);
    canvas.drawPath(seam, glow);
    canvas.drawPath(
      seam,
      Paint()
        ..color = const Color(0xFFDDFDFF).withAlpha(100)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..strokeCap = StrokeCap.round,
    );

    for (var spark = 0; spark < 16; spark++) {
      final seed = spark * 12.9898;
      final x = (math.sin(seed) * 0.5 + 0.5) * width;
      final y =
          (spark * height / 16 + _scroll * (0.7 + (spark % 3) * 0.25)) % height;
      final pulse = (math.sin(_time * 2.0 + seed) * 0.5 + 0.5);
      canvas.drawCircle(
        Offset(x, y),
        0.7 + pulse * 1.2,
        Paint()..color = color.withAlpha((35 + pulse * 90).round()),
      );
    }
  }
}
