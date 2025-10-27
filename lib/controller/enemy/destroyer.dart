import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/model/custom_actions.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:spritewidget/spritewidget.dart';

class EnemyDestroyer extends Obstacle {
  EnemyDestroyer(GameObjectFactory f, int level) : super(f) {
    _sprite = Sprite(texture: f.sheet["enemy_destroyer_$level.png"]!);
    _sprite.scale = 0.32;

    radius = 24.0 + level * 2;

    if (level == 0) {
      maxDamage = 4.0;
    } else if (level == 1) {
      maxDamage = 8.0;
    } else if (level == 2) {
      maxDamage = 16.0;
    }

    addChild(_sprite);

    constraints = <Constraint>[
      ConstraintRotationToNode(targetNode: f.level.ship, dampening: 0.05)
    ];
  }

  int _countDown = randomInt(120) + 240;

  @override
  void setupActions() {
    ActionCircularMove circle = ActionCircularMove((Offset a) {
      position = a;
    }, position, 40.0, 360.0 * randomDouble(), randomBool(), 3.0);
    motions.run(MotionRepeatForever(motion: circle));
  }

  @override
  Collectable createPowerUp() {
    return Coin(f);
  }

  @override
  void update(double dt) {
    _countDown -= 1;
    if (_countDown <= 0) {
      // Shoot at player
      f.sounds.playEffect("laser");

      EnemyLaser laser = EnemyLaser(f, rotation, 5.0, const Color(0xffffe38e));
      laser.position = position;
      f.level.addChild(laser);

      _countDown = 60 + randomInt(120);
    }
  }

  @override
  set damage(double d) {
    super.damage = d;
    _sprite.colorOverlay = colorForDamage(d, maxDamage);
  }

  late Sprite _sprite;
}


