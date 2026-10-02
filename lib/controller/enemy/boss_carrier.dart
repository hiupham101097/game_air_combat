import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/enemy/boss_attack_patterns.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/enemy/projectile_style.dart';
import 'package:mini__game2/controller/enemy/scout.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/model/custom_actions.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/flash.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_balance.dart';
import 'package:mini__game2/controller/power/power_bar.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart';

class BossCarrier extends Obstacle {
  BossCarrier(GameObjectFactory f, this._bossLevel) : super(f) {
    radius = 55.0;
    _sprite = Sprite(texture: f.sheet["enemy_boss_2.png"]!);
    _sprite.scale = 0.38; // Bigger than others
    _sprite.colorOverlay = const Color(0x3300FF00); // Greenish
    addChild(_sprite);

    maxDamage = GameBalance.bossHealth(_bossLevel, 1.05);

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

  final int _bossLevel;
  int _spawnTimer = 240;
  int _attackTimer = GameBalance.bossAttackCooldown(75);
  int _volley = 0;
  int _attackStyle = 0;
  double _lockedAngle = 0.0;

  int get _scoutLevel => (_bossLevel ~/ 3).clamp(0, 2).toInt();

  @override
  void update(double dt) {
    _spawnTimer--;
    _attackTimer--;

    // Slow rotation towards player instead of fast tracking
    double dx = f.level.ship.position.dx - position.dx;
    double dy = f.level.ship.position.dy - position.dy;
    double targetRotation = degrees(math.atan2(dy, dx));
    rotation = GameMath.filter(rotation, targetRotation, 0.02);

    // The carrier must pressure the player itself; its scouts are support,
    // not its only attack. Fire a short spread at the player's position.
    if (_attackTimer == 24) {
      final tier = GameBalance.bossAttackTier(_bossLevel);
      _attackStyle = tier >= 2
          ? _volley % 3
          : tier >= 1
              ? _volley % 2
              : 0;
      _lockedAngle = BossAttackPatterns.angleToShip(f, position);
      BossAttackPatterns.telegraphAim(f, position,
          color: const Color(0xFF72FF8A));
    }
    if (_attackTimer <= 0) {
      f.sounds.playEffect("laser");
      BossAttackPatterns.fireFan(
        f,
        origin: position,
        centerAngle: _lockedAngle,
        count: _attackStyle == 2
            ? 2
            : _attackStyle == 1
                ? 4
                : 3,
        spreadDegrees: _attackStyle == 1 ? 46.0 : 22.0,
        speed: _attackStyle == 2 ? 3.8 : 4.5,
        color: const Color(0xFF72FF8A),
        bossLevel: _bossLevel,
        style: EnemyProjectileStyle.plasmaOrb,
        motion: _attackStyle == 2
            ? EnemyProjectileMotion.seeking
            : EnemyProjectileMotion.weaving,
        turnRate: 0.006,
        weaveAmplitude: _attackStyle == 1 ? 1.8 : 3.0,
        shipDamage: 0.8,
        hitRadius: 7.0,
        spawnDistance: 42.0,
      );
      _volley++;
      _attackTimer = GameBalance.bossAttackCooldown(
        (84 - _bossLevel * 3).clamp(42, 84).toInt(),
        level: _bossLevel,
      );
    }

    if (_spawnTimer <= 0) {
      f.sounds.playEffect("laser");

      // Spawn escorts scaled to the boss level.
      EnemyScout scout1 = EnemyScout(f, _scoutLevel, _bossLevel);
      f.addGameObject(scout1, position + const Offset(-40.0, 20.0));

      EnemyScout scout2 = EnemyScout(f, _scoutLevel, _bossLevel);
      f.addGameObject(scout2, position + const Offset(40.0, 20.0));

      _spawnTimer = GameBalance.bossAttackCooldown(240, level: _bossLevel);
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
