import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart';

enum EnemyProjectileMotion { straight, seeking, weaving }

class EnemyLaser extends Obstacle {
  /// [spriteRotation] uses SpriteWidget's orientation: 0° points up.
  /// Convert a normal math angle (0° points right) with `angle + 90`.
  EnemyLaser(
    GameObjectFactory f,
    double spriteRotation,
    double speed,
    Color color, {
    bool highVisibility = false,
    double shipDamage = 1.0,
    EnemyProjectileMotion motion = EnemyProjectileMotion.straight,
    double turnRate = 0.012,
    double weaveAmplitude = 0.0,
    double weaveFrequency = 0.075,
  })  : _motion = motion,
        _turnRate = turnRate,
        _speed = speed,
        _weaveAmplitude = weaveAmplitude,
        _weaveFrequency = weaveFrequency,
        super(f) {
    _sprite = Sprite(texture: f.sheet["explosion_particle.png"]!);
    _sprite.scale = highVisibility ? 0.78 : 0.5;
    _sprite.rotation = spriteRotation + 190;
    _sprite.colorOverlay = color;
    addChild(_sprite);

    // Projectiles need an actual hitbox; a zero radius made them require a
    // near-perfect centre overlap with the ship and appear harmless.
    radius = 8.0;
    canDamageShip = true;
    canBeDamaged = false;
    isEnemyProjectile = true;
    this.shipDamage = shipDamage;

    // Convert SpriteWidget rotation (0 = UP) to Math angle (0 = RIGHT)
    _heading = radians(spriteRotation - 90.0);
    _movement = Offset(math.cos(_heading) * speed, math.sin(_heading) * speed);
  }

  late Sprite _sprite;
  late Offset _movement;
  final EnemyProjectileMotion _motion;
  final double _turnRate;
  final double _speed;
  final double _weaveAmplitude;
  final double _weaveFrequency;
  double _heading = 0.0;
  int _age = 0;
  bool nearMissAwarded = false;

  bool isMovingAwayFrom(Offset target) {
    final dx = position.dx - target.dx;
    final dy = position.dy - target.dy;
    return dx * _movement.dx + dy * _movement.dy > 0.0;
  }

  @override
  void move() {
    if (_motion == EnemyProjectileMotion.seeking &&
        f.level.ship.parent != null) {
      final toShip = f.level.ship.position - position;
      if (toShip.distanceSquared > 1.0) {
        final targetHeading = math.atan2(toShip.dy, toShip.dx);
        var difference = targetHeading - _heading;
        while (difference > math.pi) {
          difference -= math.pi * 2.0;
        }
        while (difference < -math.pi) {
          difference += math.pi * 2.0;
        }
        _heading += difference.clamp(-_turnRate, _turnRate);
        _movement = Offset(
          math.cos(_heading) * _speed,
          math.sin(_heading) * _speed,
        );
        _sprite.rotation = degrees(_heading) + 280.0;
      }
    }

    final previousAge = _age;
    position += _movement;
    _age++;
    if (_motion == EnemyProjectileMotion.weaving && _weaveAmplitude > 0.0) {
      final side = Offset(-_movement.dy / _speed, _movement.dx / _speed);
      final previousWave = math.sin(previousAge * _weaveFrequency);
      final currentWave = math.sin(_age * _weaveFrequency);
      position += side * ((currentWave - previousWave) * _weaveAmplitude);
    }
  }
}
