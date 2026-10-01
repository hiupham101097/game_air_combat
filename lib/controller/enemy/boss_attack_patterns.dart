import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:spritewidget/spritewidget.dart';

/// Reusable patterns keep boss volleys consistent while leaving each boss its
/// own timing, damage, and projectile behavior.
class BossAttackPatterns {
  static double angleToShip(GameObjectFactory factory, Offset origin) {
    final direction = factory.level.ship.position - origin;
    return math.atan2(direction.dy, direction.dx) * 180.0 / math.pi;
  }

  static void telegraphAim(
    GameObjectFactory factory,
    Offset origin, {
    Color color = const Color(0xFFFF5B63),
    double extraLength = 54.0,
  }) {
    final direction = factory.level.ship.position - origin;
    if (direction.distanceSquared < 1.0) return;
    final length = direction.distance + extraLength;
    final ray = direction / direction.distance * length;
    factory.level.addChild(
      BossAimTelegraph(ray: ray, color: color)..position = origin,
    );
  }

  static void telegraphRadial(
    GameObjectFactory factory,
    Offset origin, {
    Color color = const Color(0xFFFFD35A),
  }) {
    factory.level.addChild(
      BossRadialTelegraph(color: color)..position = origin,
    );
  }

  static void fireFan(
    GameObjectFactory factory, {
    required Offset origin,
    required double centerAngle,
    required int count,
    required double spreadDegrees,
    required double speed,
    required Color color,
    EnemyProjectileMotion motion = EnemyProjectileMotion.straight,
    double shipDamage = 1.0,
    double hitRadius = 8.0,
    double turnRate = 0.012,
    double weaveAmplitude = 0.0,
    double spawnDistance = 24.0,
    bool highVisibility = false,
  }) {
    final safeCount = count.clamp(1, 24).toInt();
    final step = safeCount == 1 ? 0.0 : spreadDegrees / (safeCount - 1);
    for (var index = 0; index < safeCount; index++) {
      final angle = centerAngle - spreadDegrees * 0.5 + step * index;
      _fireShot(
        factory,
        origin: origin,
        angle: angle,
        speed: speed,
        color: color,
        motion: motion,
        shipDamage: shipDamage,
        hitRadius: hitRadius,
        turnRate: turnRate,
        weaveAmplitude: weaveAmplitude,
        spawnDistance: spawnDistance,
        highVisibility: highVisibility,
      );
    }
  }

  static void fireRadial(
    GameObjectFactory factory, {
    required Offset origin,
    required int count,
    required double startAngle,
    required double speed,
    required Color color,
    EnemyProjectileMotion motion = EnemyProjectileMotion.straight,
    double shipDamage = 1.0,
    double hitRadius = 8.0,
    double weaveAmplitude = 0.0,
    double spawnDistance = 38.0,
    bool highVisibility = false,
  }) {
    final safeCount = count.clamp(3, 32).toInt();
    final step = 360.0 / safeCount;
    for (var index = 0; index < safeCount; index++) {
      _fireShot(
        factory,
        origin: origin,
        angle: startAngle + step * index,
        speed: speed,
        color: color,
        motion: motion,
        shipDamage: shipDamage,
        hitRadius: hitRadius,
        turnRate: 0.012,
        weaveAmplitude: weaveAmplitude,
        spawnDistance: spawnDistance,
        highVisibility: highVisibility,
      );
    }
  }

  static void _fireShot(
    GameObjectFactory factory, {
    required Offset origin,
    required double angle,
    required double speed,
    required Color color,
    required EnemyProjectileMotion motion,
    required double shipDamage,
    required double hitRadius,
    required double turnRate,
    required double weaveAmplitude,
    required double spawnDistance,
    required bool highVisibility,
  }) {
    final radians = angle * math.pi / 180.0;
    final laser = EnemyLaser(
      factory,
      angle + 90.0,
      speed,
      color,
      motion: motion,
      shipDamage: shipDamage,
      turnRate: turnRate,
      weaveAmplitude: weaveAmplitude,
      highVisibility: highVisibility,
    )
      ..radius = hitRadius
      ..position = origin +
          Offset(math.cos(radians) * spawnDistance,
              math.sin(radians) * spawnDistance);
    factory.level.addChild(laser);
  }
}

/// A short lock-on line marks where a targeted boss volley is about to travel.
class BossAimTelegraph extends Node {
  BossAimTelegraph({required this.ray, required this.color}) {
    zPosition = 240.0;
  }

  final Offset ray;
  final Color color;
  double _elapsed = 0.0;

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= 0.42) removeFromParent();
  }

  @override
  void paint(Canvas canvas) {
    final fade = (1.0 - _elapsed / 0.42).clamp(0.0, 1.0).toDouble();
    final pulse = 0.42 + math.sin(_elapsed * 36.0).abs() * 0.45;
    final end = ray;
    canvas.drawLine(
      Offset.zero,
      end,
      Paint()
        ..color = color.withValues(alpha: fade * pulse * 0.55)
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0),
    );
    canvas.drawLine(
      Offset.zero,
      end,
      Paint()
        ..color = color.withValues(alpha: fade * pulse)
        ..strokeWidth = 1.7
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      end,
      7.0 + math.sin(_elapsed * 28.0).abs() * 3.0,
      Paint()
        ..color = color.withValues(alpha: fade * pulse)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }
}

/// Pulsing rings warn that the next boss attack will radiate in every direction.
class BossRadialTelegraph extends Node {
  BossRadialTelegraph({required this.color}) {
    zPosition = 240.0;
  }

  final Color color;
  double _elapsed = 0.0;

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= 0.42) removeFromParent();
  }

  @override
  void paint(Canvas canvas) {
    final fade = (1.0 - _elapsed / 0.42).clamp(0.0, 1.0).toDouble();
    final pulse = 0.3 + math.sin(_elapsed * 34.0).abs() * 0.5;
    for (var ring = 0; ring < 3; ring++) {
      final radius = 24.0 + ring * 15.0 + _elapsed * 14.0;
      canvas.drawCircle(
        Offset.zero,
        radius,
        Paint()
          ..color = color.withValues(alpha: fade * pulse * (0.82 - ring * 0.16))
          ..style = PaintingStyle.stroke
          ..strokeWidth = ring == 0 ? 2.0 : 1.0,
      );
    }
  }
}
