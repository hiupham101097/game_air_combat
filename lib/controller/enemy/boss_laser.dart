import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/model/custom_actions.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/flash.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_balance.dart';
import 'package:mini__game2/controller/power/power_bar.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart';

class BossLaser extends Obstacle {
  BossLaser(GameObjectFactory f, int level) : super(f) {
    radius = 40.0;
    _sprite = Sprite(texture: f.sheet["enemy_boss_1.png"]!);
    _sprite.scale = 0.28;
    _sprite.colorOverlay = const Color(0x66FF0000); // Reddish tint
    addChild(_sprite);

    maxDamage = GameBalance.bossHealth(level, 0.95);

    constraints = <Constraint>[
      ConstraintRotationToNode(targetNode: f.level.ship, dampening: 0.1)
    ];

    _powerBar = PowerBar(const Size(60.0, 10.0));
    _powerBar.pivot = const Offset(0.5, 0.5);
    f.level.addChild(_powerBar);
    _powerBar.constraints = <Constraint>[
      ConstraintPositionToNode(
        targetNode: this,
        dampening: 0.5,
        offset: const Offset(0.0, -70.0),
      )
    ];
  }

  late Sprite _sprite;
  late PowerBar _powerBar;

  int _stateTimer = 180;
  int _state = 0; // 0: moving, 1: charging, 2: firing

  @override
  void update(double dt) {
    _stateTimer--;

    // This boss has no rotation constraint, so explicitly aim its beam at
    // the ship rather than leaving it on the default right-facing angle.
    final toShip = f.level.ship.position - position;
    rotation = degrees(math.atan2(toShip.dy, toShip.dx));

    if (_state == 0) {
      // Moving randomly
      if (_stateTimer <= 0) {
        _state = 1; // Start charging
        _stateTimer = 60; // 1 second charge
        _sprite.colorOverlay =
            const Color.fromARGB(150, 255, 255, 0); // Yellow warning
      }
    } else if (_state == 1) {
      // Charging
      if (_stateTimer % 10 == 0) {
        f.sounds.playEffect("laser");
      }
      if (_stateTimer <= 0) {
        _state = 2; // Firing
        _stateTimer = 40; // Fire for ~0.6 seconds
        _sprite.colorOverlay = const Color(0x66FF0000); // Back to red
      }
    } else if (_state == 2) {
      // Firing beam (rapid small lasers)
      if (_stateTimer % 5 == 0) {
        f.sounds.playEffect("laser");
        // Convert the boss's math angle to EnemyLaser's SpriteWidget angle.
        EnemyLaser laser =
            EnemyLaser(f, rotation + 90.0, 9.0, const Color(0xffff0000));
        laser.radius = 11.0;
        laser.scale = 1.5;

        double rad = radians(rotation);
        Offset startOffset = Offset(math.cos(rad) * 30.0, math.sin(rad) * 30.0);
        laser.position = position + startOffset;
        f.level.addChild(laser);
      }
      if (_stateTimer <= 0) {
        _state = 0; // Back to moving
        _stateTimer = 120 + randomInt(60);

        // Teleport to a new random position
        position = Offset(randomSignedDouble() * 120,
            position.dy + randomSignedDouble() * 60);
      }
    }
  }

  @override
  void setupActions() {
    ActionOscillate oscillate = ActionOscillate((Offset a) {
      if (_state == 0) position = a;
    }, position, 160.0, 2.0);
    motions.run(MotionRepeatForever(motion: oscillate));
  }

  @override
  void destroy() {
    f.playerState.boss = null;
    if (_powerBar.parent != null) _powerBar.removeFromParent();

    NodeWithSize screen = f.playerState.parent as NodeWithSize;
    screen.addChild(Flash(screen.size, 1.0));
    super.destroy();

    for (int i = 0; i < 10; i++) {
      Coin coin = Coin(f, value: 10);
      Offset pos = Offset(randomSignedDouble() * 160,
          position.dy + randomSignedDouble() * 160.0);
      f.addGameObject(coin, pos);
    }
  }

  @override
  Explosion createExplosion() {
    f.sounds.playEffect("explosion_boss");
    ExplosionBig explo = ExplosionBig(f.sheet);
    explo.scale = 1.5;
    return explo;
  }

  @override
  set damage(double d) {
    super.damage = d;
    if (_state != 1) {
      // Don't override charge color
      _sprite.motions.stopAll();
      _sprite.motions.run(
        MotionTween<Color>(
          setter: (a) => _sprite.colorOverlay = a,
          start: const Color.fromARGB(180, 255, 255, 255),
          end: const Color(0x66FF0000),
          duration: 0.3,
        ),
      );
    }

    double hpRatio = 1.0 - (damage / maxDamage);
    _powerBar.power = hpRatio.clamp(0.0, 1.0);
  }
}
