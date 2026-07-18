import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart';

class EnemyLaser extends Obstacle {
  EnemyLaser(GameObjectFactory f, double rotation, double speed, Color color)
      : super(f) {
    _sprite = Sprite(texture: f.sheet["explosion_particle.png"]!);
    _sprite.scale = 0.5;
    _sprite.rotation = rotation + 190;
    _sprite.colorOverlay = color;
    addChild(_sprite);

    canDamageShip = true;
    canBeDamaged = false;

    // Convert SpriteWidget rotation (0 = UP) to Math angle (0 = RIGHT)
    double rad = radians(rotation - 90.0);
    _movement = Offset(math.cos(rad) * speed, math.sin(rad) * speed);
  }

  late Sprite _sprite;
  late Offset _movement;

  @override
  void move() {
    position += _movement;
  }
}



