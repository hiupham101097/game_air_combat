import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/enemy/scout.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/model/custom_actions.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/flash.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/power/power_bar.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart';

class BossCarrier extends Obstacle {
  BossCarrier(GameObjectFactory f, int level) : super(f) {
    radius = 55.0;
    _sprite = Sprite(texture: f.sheet["enemy_boss_2.png"]!);
    _sprite.scale = 0.38; // Bigger than others
    _sprite.colorOverlay = const Color(0x3300FF00); // Greenish
    addChild(_sprite);
    
    maxDamage = 70.0 + 30.0 * level; // Very tanky

    _powerBar = PowerBar(const Size(80.0, 10.0));
    _powerBar.pivot = const Offset(0.5, 0.5);
    f.level.addChild(_powerBar);
    _powerBar.constraints = <Constraint>[
      ConstraintPositionToNode(
        targetNode: this,
        dampening: 0.5,
        offset: const Offset(0.0, -85.0),
      )
    ];
  }

  late Sprite _sprite;
  late PowerBar _powerBar;

  int _spawnTimer = 120;
  final int _levelLevel = 1;

  @override
  void update(double dt) {
    _spawnTimer--;
    
    // Slow rotation towards player instead of fast tracking
    double dx = f.level.ship.position.dx - position.dx;
    double dy = f.level.ship.position.dy - position.dy;
    double targetRotation = degrees(math.atan2(dy, dx));
    rotation = GameMath.filter(rotation, targetRotation, 0.02);

    if (_spawnTimer <= 0) {
      f.sounds.playEffect("laser");
      
      // Spawn 2 scouts
      EnemyScout scout1 = EnemyScout(f, _levelLevel);
      scout1.position = position + const Offset(-40.0, 20.0);
      f.level.addChild(scout1);

      EnemyScout scout2 = EnemyScout(f, _levelLevel);
      scout2.position = position + const Offset(40.0, 20.0);
      f.level.addChild(scout2);

      _spawnTimer = 180; // 3 seconds
    }
  }

  @override
  void setupActions() {
    ActionOscillate oscillate = ActionOscillate((Offset a) {
      position = a;
    }, position, 80.0, 4.0); // Slow horizontal movement
    motions.run(MotionRepeatForever(motion: oscillate));
  }

  @override
  void destroy() {
    f.playerState.boss = null;
    if (_powerBar.parent != null) _powerBar.removeFromParent();

    NodeWithSize screen = f.playerState.parent as NodeWithSize;
    screen.addChild(Flash(screen.size, 1.0));
    super.destroy();

    for (int i = 0; i < 30; i++) {
      Coin coin = Coin(f);
      Offset pos = Offset(randomSignedDouble() * 160, position.dy + randomSignedDouble() * 160.0);
      f.addGameObject(coin, pos);
    }
  }

  @override
  Explosion createExplosion() {
    f.sounds.playEffect("explosion_boss");
    ExplosionBig explo = ExplosionBig(f.sheet);
    explo.scale = 2.0;
    return explo;
  }

  @override
  set damage(double d) {
    super.damage = d;
    _sprite.motions.stopAll();
    _sprite.motions.run(
      MotionTween<Color>(
        setter: (a) => _sprite.colorOverlay = a,
        start: const Color.fromARGB(180, 255, 255, 255),
        end: const Color(0x3300FF00),
        duration: 0.3,
      ),
    );

    double hpRatio = 1.0 - (damage / maxDamage);
    _powerBar.power = hpRatio.clamp(0.0, 1.0);
  }
}
