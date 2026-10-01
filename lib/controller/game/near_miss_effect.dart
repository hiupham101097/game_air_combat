import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

/// Brief score callout shown where a hostile projectile narrowly missed.
class NearMissEffect extends Node {
  NearMissEffect(String label, {Color accentColor = const Color(0xFF83F7FF)}) {
    _label = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: accentColor,
          shadows: [
            Shadow(color: accentColor.withAlpha(204), blurRadius: 10.0),
            const Shadow(color: Color(0xDD000000), blurRadius: 3.0),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    zPosition = 200.0;
  }

  late final TextPainter _label;
  double _elapsed = 0.0;

  @override
  void update(double dt) {
    _elapsed += dt;
    position += Offset(0.0, -24.0 * dt);
    if (_elapsed >= 0.7) removeFromParent();
  }

  @override
  void paint(Canvas canvas) {
    final progress = (_elapsed / 0.7).clamp(0.0, 1.0).toDouble();
    final opacity = (1.0 - progress * progress).clamp(0.0, 1.0).toDouble();
    canvas.save();
    canvas.scale(0.92 + progress * 0.08);
    canvas.drawRect(
      Rect.fromLTWH(
        -_label.width / 2.0 - 5.0,
        -_label.height / 2.0 - 3.0,
        _label.width + 10.0,
        _label.height + 6.0,
      ),
      Paint()..color = const Color(0xAA061528).withOpacity(opacity),
    );
    canvas.saveLayer(
      Rect.fromCenter(
        center: Offset.zero,
        width: _label.width + 12.0,
        height: _label.height + 8.0,
      ),
      Paint()..color = Colors.white.withOpacity(opacity),
    );
    _label.paint(canvas, Offset(-_label.width / 2.0, -_label.height / 2.0));
    canvas.restore();
    canvas.restore();
  }
}

/// Small floating hit value; critical hits use an amber, larger treatment.
class DamageNumberEffect extends Node {
  DamageNumberEffect(double damage, {required bool critical}) {
    final color = critical ? Colors.amberAccent : Colors.white;
    _label = TextPainter(
      text: TextSpan(
        text: damage.round().clamp(1, 999999).toString(),
        style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: critical ? 12.0 : 9.0,
          fontWeight: FontWeight.w900,
          color: color,
          shadows: [
            Shadow(color: color.withAlpha(210), blurRadius: 8.0),
            const Shadow(color: Color(0xDD000000), blurRadius: 3.0),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    zPosition = 210.0;
  }

  late final TextPainter _label;
  double _elapsed = 0.0;

  @override
  void update(double dt) {
    _elapsed += dt;
    position += Offset(0.0, -28.0 * dt);
    if (_elapsed >= 0.65) removeFromParent();
  }

  @override
  void paint(Canvas canvas) {
    final progress = (_elapsed / 0.65).clamp(0.0, 1.0).toDouble();
    final opacity = (1.0 - progress * progress).clamp(0.0, 1.0).toDouble();
    canvas.saveLayer(
      Rect.fromCenter(
        center: Offset.zero,
        width: _label.width + 10.0,
        height: _label.height + 8.0,
      ),
      Paint()..color = Colors.white.withOpacity(opacity),
    );
    _label.paint(canvas, Offset(-_label.width / 2.0, -_label.height / 2.0));
    canvas.restore();
  }
}
