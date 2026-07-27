import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart';

class EnemyLaser extends Obstacle {
  /// [spriteRotation] uses SpriteWidget's orientation: 0° points up.
  /// Convert a normal math angle (0° points right) with `angle + 90`.
  EnemyLaser(
      GameObjectFactory f, double spriteRotation, double speed, Color color,
      {bool highVisibility = false, double shipDamage = 1.0})
      : super(f) {
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
    double rad = radians(spriteRotation - 90.0);
    _movement = Offset(math.cos(rad) * speed, math.sin(rad) * speed);
  }

  late Sprite _sprite;
  late Offset _movement;

  @override
  void move() {
    position += _movement;
  }
}
