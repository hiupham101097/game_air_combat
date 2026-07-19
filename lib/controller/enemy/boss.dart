import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/model/custom_actions.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/flash.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/power/power_bar.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart';

class EnemyBoss extends Obstacle {
  EnemyBoss(GameObjectFactory f, int level) : super(f) {
    radius = 48.0;
    _sprite = Sprite(texture: f.sheet["enemy_boss_${level % 3}.png"]!);
    _sprite.scale = 0.32;
    addChild(_sprite);
    maxDamage = 40.0 + 20.0 * level;

    constraints = <Constraint>[
      ConstraintRotationToNode(targetNode: f.level.ship, dampening: 0.05)
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

  int _countDown = randomInt(120) + 240;
  int _currentPhase = 1;

  @override
  void update(double dt) {
    _countDown -= 1;
    if (_countDown <= 0) {
      f.sounds.playEffect("laser");

      if (_currentPhase == 1) {
        fire(10.0);
        fire(0.0);
        fire(-10.0);
        _countDown = 60 + randomInt(60);
      } else if (_currentPhase == 2) {
        fire(20.0);
        fire(10.0);
        fire(0.0);
        fire(-10.0);
        fire(-20.0);
        _countDown = 40 + randomInt(40);
      } else if (_currentPhase == 3) {
        for (double a = 0; a < 360; a += 45) {
          fire(a);
        }
        _countDown = 30 + randomInt(30);
      }
    }
  }

  void fire(double r) {
    r += rotation;
    // EnemyLaser uses SpriteWidget angles (0° = up), while boss rotation
    // and the spawn offset use math angles (0° = right).
    EnemyLaser laser = EnemyLaser(f, r + 90.0, 5.0, const Color(0xffffe38e));

    double rad = radians(r);
    Offset startOffset = Offset(math.cos(rad) * 30.0, math.sin(rad) * 30.0);

    laser.position = position + startOffset;
    f.level.addChild(laser);
  }

  @override
  void setupActions() {
    ActionOscillate oscillate = ActionOscillate((Offset a) {
      position = a;
    }, position, 120.0, 3.0);
    motions.run(MotionRepeatForever(motion: oscillate));
  }

  @override
  void destroy() {
    f.playerState.boss = null;
    if (_powerBar.parent != null) _powerBar.removeFromParent();

    // Flash the screen
    NodeWithSize screen = f.playerState.parent as NodeWithSize;
    screen.addChild(Flash(screen.size, 1.0));
    super.destroy();

    // Add coins
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
    _sprite.motions.stopAll();
    _sprite.motions.run(
      MotionTween<Color>(
        setter: (a) => _sprite.colorOverlay = a,
        start: const Color.fromARGB(180, 255, 3, 86),
        end: const Color(0x00000000),
        duration: 0.3,
      ),
    );

    double hpRatio = 1.0 - (damage / maxDamage);
    _powerBar.power = hpRatio.clamp(0.0, 1.0);

    if (hpRatio <= 0.33) {
      _currentPhase = 3;
      _sprite.colorOverlay = const Color(0x66FF0000); // Boss turns reddish
    } else if (hpRatio <= 0.66) {
      _currentPhase = 2;
    }
  }
}
