import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:vector_math/vector_math_64.dart';

var _gameSizeHeight = 320.0;
class Laser extends GameObject {
  double impact = 0.0;

  Laser(GameObjectFactory f, int level, double r) : super(f) {
    
    radius = 10.0;  //Phạm vi đạn gây sát thương
    removeLimit = _gameSizeHeight*5 + radius; //Tăng chiều dài đạn bắn ra
    canDamageShip = false;
    canBeDamaged = false;
    impact = 1.0 + level * 0.5;

    // Tăng tốc độ lase bắn
    _offset = Offset(math.cos(radians(r)) * 80.0,
        math.sin(radians(r)) * 8.0 - f.playerState.scrollSpeed); 

    // tăng kích thước đạn
    rotation = r + 90.0;

    addLaserSprites(this, level, r, f.sheet);
  }

  late Offset _offset;

  @override
  void move() {
    position += _offset;
  }

  @override
  Explosion createExplosion() {
    return ExplosionMini(f.sheet);
  }
}
