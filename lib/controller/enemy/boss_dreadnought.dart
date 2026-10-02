import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/boss_attack_patterns.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/enemy/projectile_style.dart';
import 'package:mini__game2/controller/enemy/scout.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/flash.dart';
import 'package:mini__game2/controller/game/game_balance.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/power/power_bar.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/custom_actions.dart';
import 'package:spritewidget/spritewidget.dart';

/// Huge carrier that alternates readable turret volleys and launches fighter
/// squadrons while the player attacks its hull.
class BossDreadnought extends Obstacle {
  BossDreadnought(GameObjectFactory f, this._bossLevel) : super(f) {
    radius = 82.0;
    damageResistance = 0.12;
    _sprite = Sprite.fromImage(imageMap['assets/boss_colossus_clean.png']!);
    _sprite.scale = 0.17;
    _sprite.colorOverlay = const Color(0x443CB8FF);
    addChild(_sprite);
    maxDamage = GameBalance.bossHealth(_bossLevel, 1.55);

    _powerBar = PowerBar(const Size(112.0, 14.0));
    _powerBar.pivot = const Offset(0.5, 0.5);
    f.level.addChild(_powerBar);
    _powerBar.constraints = <Constraint>[
      ConstraintPositionToNode(
        targetNode: this,
        dampening: 0.5,
        offset: const Offset(0.0, -128.0),
      ),
    ];
  }

  final int _bossLevel;
  late Sprite _sprite;
  late PowerBar _powerBar;
  final List<EnemyScout> _fighters = <EnemyScout>[];
  int _attackTimer = GameBalance.bossAttackCooldown(150);
  int _spawnTimer = 240;
  int _phase = 1;
  int _volley = 0;
  int _attackStyle = 0;
  double _lockedAngle = 0.0;
  double _leftLockedAngle = 0.0;
  double _rightLockedAngle = 0.0;

  int get _scoutLevel => (_bossLevel ~/ 3).clamp(0, 2).toInt();

  @override
  void setupActions() {
    final drift = ActionOscillate(
      (Offset value) => position = value,
      position,
      42.0,
      10.0,
    );
    motions.run(MotionRepeatForever(motion: drift));
  }

  @override
  void update(double dt) {
    _attackTimer--;
    _spawnTimer--;

    if (_attackTimer == 34) {
      _attackStyle = (_volley + _phase - 1) % 3;
      if (_attackStyle == 2) {
        BossAttackPatterns.telegraphRadial(
          f,
          position,
          color: const Color(0xFF5BCBFF),
        );
      } else if (_attackStyle == 0) {
        _leftLockedAngle = BossAttackPatterns.angleToShip(
          f,
          position + const Offset(-52.0, 18.0),
        );
        _rightLockedAngle = BossAttackPatterns.angleToShip(
          f,
          position + const Offset(52.0, 18.0),
        );
        BossAttackPatterns.telegraphAim(
          f,
          position + const Offset(-52.0, 18.0),
          color: const Color(0xFF5BCBFF),
          extraLength: 72.0,
        );
        BossAttackPatterns.telegraphAim(
          f,
          position + const Offset(52.0, 18.0),
          color: const Color(0xFF5BCBFF),
          extraLength: 72.0,
        );
      } else {
        _lockedAngle = BossAttackPatterns.angleToShip(f, position);
        BossAttackPatterns.telegraphAim(
          f,
          position,
          color: const Color(0xFF5BCBFF),
          extraLength: 90.0,
        );
      }
    }

    if (_attackTimer <= 0) {
      _fireAttack();
      _volley++;
      _attackTimer = GameBalance.bossAttackCooldown(
        168 - (_phase - 1) * 18,
        level: _bossLevel,
      );
    }

    if (_spawnTimer <= 0) {
      _launchFighters();
      _spawnTimer = GameBalance.bossAttackCooldown(
        216 - (_phase - 1) * 12,
        level: _bossLevel,
      );
    }
  }

  void _fireAttack() {
    f.sounds.playEffect('laser');
    switch (_attackStyle) {
      case 0:
        for (final turretIndex in [0, 1]) {
          final side = turretIndex == 0 ? -1.0 : 1.0;
          final turret = position + Offset(side * 52.0, 18.0);
          BossAttackPatterns.fireFan(
            f,
            origin: turret,
            centerAngle:
                turretIndex == 0 ? _leftLockedAngle : _rightLockedAngle,
            count: _phase + 1,
            spreadDegrees: 18.0,
            speed: 5.0,
            color: const Color(0xFF55C8FF),
            bossLevel: _bossLevel,
            style: EnemyProjectileStyle.riftShard,
            motion: EnemyProjectileMotion.weaving,
            weaveAmplitude: 1.6,
            shipDamage: 0.7,
            hitRadius: 8.0,
            spawnDistance: 20.0,
          );
        }
      case 1:
        BossAttackPatterns.fireFan(
          f,
          origin: position,
          centerAngle: _lockedAngle,
          count: 4 + _phase,
          spreadDegrees: 42.0,
          speed: 5.2,
          color: const Color(0xFF6DDEFF),
          bossLevel: _bossLevel,
          style: EnemyProjectileStyle.plasmaOrb,
          shipDamage: 0.65,
          hitRadius: 8.0,
          spawnDistance: 50.0,
        );
      default:
        BossAttackPatterns.fireRadial(
          f,
          origin: position,
          count: 8 + _phase,
          startAngle: _volley * 17.0,
          speed: 4.0,
          color: const Color(0xFF39AFFF),
          bossLevel: _bossLevel,
          style: EnemyProjectileStyle.riftShard,
          motion: EnemyProjectileMotion.weaving,
          weaveAmplitude: 1.4,
          shipDamage: 0.6,
          hitRadius: 8.0,
          spawnDistance: 54.0,
        );
    }
  }

  void _launchFighters() {
    _fighters.removeWhere((fighter) => fighter.parent == null);
    final fighterLimit = _phase == 1 ? 2 : 4;
    final freeSlots = fighterLimit - _fighters.length;
    if (freeSlots <= 0) return;

    final count = math.min(freeSlots, _phase == 1 ? 2 : 3).toInt();
    for (var index = 0; index < count; index++) {
      final horizontalOffset = (index - (count - 1) / 2.0).toDouble() * 68.0;
      final fighter = EnemyScout(f, _scoutLevel, _bossLevel);
      _fighters.add(fighter);
      f.addGameObject(
        fighter,
        position + Offset(horizontalOffset, 82.0 + (index.isOdd ? 10.0 : 0.0)),
      );
    }
    f.sounds.playEffect('laser');
  }

  @override
  void destroy() {
    f.playerState.boss = null;
    if (_powerBar.parent != null) _powerBar.removeFromParent();
    for (final fighter in _fighters) {
      fighter.removeFromParent();
    }

    final screen = f.playerState.parent as NodeWithSize;
    screen.addChild(Flash(screen.size, 2.2));
    super.destroy();

    for (var index = 0; index < 14; index++) {
      final coin = Coin(f, value: 15);
      final offset = Offset(
        randomSignedDouble() * 180.0,
        randomSignedDouble() * 180.0,
      );
      f.addGameObject(coin, position + offset);
    }
  }

  @override
  Explosion createExplosion() {
    f.sounds.playEffect('explosion_boss');
    final explosion = ExplosionBig(f.sheet)..scale = 4.0;
    return explosion;
  }

  @override
  set damage(double value) {
    super.damage = value;
    _sprite.motions.stopAll();
    _sprite.motions.run(
      MotionTween<Color>(
        setter: (color) => _sprite.colorOverlay = color,
        start: const Color(0xCCFFFFFF),
        end: const Color(0x443CB8FF),
        duration: 0.3,
      ),
    );

    final healthRatio = (1.0 - damage / maxDamage).clamp(0.0, 1.0).toDouble();
    _powerBar.power = healthRatio;
    _phase = healthRatio < 0.33
        ? 3
        : healthRatio < 0.66
            ? 2
            : 1;
  }
}
