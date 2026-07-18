import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/model/custom_actions.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/controller/power/power_up.dart';
import 'package:mini__game2/controller/power/power_upda_type.dart';
import 'package:mini__game2/model/weapon.dart';
import 'package:mini__game2/controller/game/weapon_pickup.dart';
import 'package:spritewidget/spritewidget.dart';

class EnemyDestroyer extends Obstacle {
  EnemyDestroyer(GameObjectFactory f, int level, [this.threatLevel = 0])
      : super(f) {
    _sprite = Sprite(texture: f.sheet["enemy_destroyer_$level.png"]!);
    _sprite.scale = 0.32 + (threatLevel * 0.01).clamp(0.0, 0.06);

    radius = 24.0 + level * 2 + (threatLevel * 0.5).clamp(0.0, 5.0);

    if (level == 0) {
      maxDamage = 4.0;
    } else if (level == 1) {
      maxDamage = 8.0;
    } else if (level == 2) {
      maxDamage = 16.0;
    }
    maxDamage *= 1.0 + threatLevel * 0.45;
    _countDown = (180 - threatLevel * 8).clamp(60, 180) + randomInt(90);

    addChild(_sprite);

    constraints = <Constraint>[
      ConstraintRotationToNode(targetNode: f.level.ship, dampening: 0.05)
    ];
  }

  late int _countDown;
  final int threatLevel;

  @override
  void setupActions() {
    ActionCircularMove circle = ActionCircularMove((Offset a) {
      position = a;
    }, position, 40.0, 360.0 * randomDouble(), randomBool(), 3.0);
    motions.run(MotionRepeatForever(motion: circle));
  }

  @override
  Collectable? createPowerUp() {
    double rand = randomDouble();
    if (rand < 0.05) {
      // 5% chance to drop a weapon
      return WeaponPickup(
          f, WeaponType.values[randomInt(WeaponType.values.length)]);
    } else if (rand < 0.15) {
      // 10% chance to drop a powerup
      return PowerUp(f, nextPowerUpType());
    }
    return Coin(f);
  }

  @override
  void update(double dt) {
    _countDown -= 1;
    if (_countDown <= 0) {
      // Shoot at player
      f.sounds.playEffect("laser");

      EnemyLaser laser = EnemyLaser(
          f, rotation, 5.0 + threatLevel * 0.7, const Color(0xffffe38e));
      laser.position = position;
      f.level.addChild(laser);

      _countDown = (60 - threatLevel * 4).clamp(25, 60) + randomInt(90);
    }
  }

  @override
  set damage(double d) {
    super.damage = d;
    _sprite.colorOverlay = colorForDamage(d, maxDamage);
  }

  late Sprite _sprite;
}
