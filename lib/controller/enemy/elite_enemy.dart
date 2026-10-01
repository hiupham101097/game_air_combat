import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/enemy/boss_attack_patterns.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/controller/game/game_balance.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/controller/power/power_bar.dart';
import 'package:mini__game2/model/custom_actions.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

/// Enemy archetypes introduced gradually as the dimensional front expands.
enum EliteEnemyType {
  droneMite,
  plasmaWasp,
  cometRammer,
  siegeFighter,
  phaseStalker,
  riftBomber,
  voidSentinel,
  riftLeech,
  shardBrood,
  riftWarden,
  novaMiniBoss,
  phantomMiniBoss,
  warshipMiniBoss,
  titanBoss,
  colossusBoss,
}

class EliteEnemy extends Obstacle {
  EliteEnemy(GameObjectFactory f, this.type, this.threatLevel) : super(f) {
    // Elite/special enemies always grant a fixed bonus reward.
    scoreReward = 60 + threatLevel * 18;
    _configureSprite();
    _spriteBaseScale = _sprite.scale;
    _configureStats();
    if (type == EliteEnemyType.riftWarden) {
      _wardenAura = _RiftWardenAura();
      _wardenAura!.zPosition = -1.0;
      addChild(_wardenAura!);
    }
    addChild(_sprite);
    if (_isMiniBoss) {
      _powerBar = PowerBar(const Size(72.0, 10.0));
      _powerBar!.pivot = const Offset(0.5, 0.5);
      f.level.addChild(_powerBar!);
      _powerBar!.constraints = <Constraint>[
        ConstraintPositionToNode(
          targetNode: this,
          dampening: 0.5,
          offset: const Offset(0.0, -62.0),
        ),
      ];
    }
  }

  final EliteEnemyType type;
  final int threatLevel;
  late Sprite _sprite;
  late int _shotCount;
  late double _laserImpact;
  late double _moveRange;
  late double _moveDuration;
  int _countDown = 90;
  int _phaseFrame = 0;
  double _animationTime = 0.0;
  double _spriteBaseScale = 1.0;
  _RiftWardenAura? _wardenAura;
  PowerBar? _powerBar;

  bool get _isGiant =>
      type == EliteEnemyType.titanBoss || type == EliteEnemyType.colossusBoss;

  bool get _isMiniBoss =>
      type == EliteEnemyType.novaMiniBoss ||
      type == EliteEnemyType.phantomMiniBoss ||
      type == EliteEnemyType.warshipMiniBoss;

  void _configureSprite() {
    switch (type) {
      case EliteEnemyType.droneMite:
        _sprite = Sprite.fromImage(imageMap['assets/enemy_drone_mite.png']!);
        _sprite.scale = 0.22;
      case EliteEnemyType.plasmaWasp:
        _sprite = Sprite(texture: f.sheet['enemy_scout_1.png']!);
        _sprite.scale = 0.28;
        _sprite.colorOverlay = const Color(0x6651FFB0);
      case EliteEnemyType.cometRammer:
        _sprite = Sprite(texture: f.sheet['enemy_scout_2.png']!);
        _sprite.scale = 0.36;
        _sprite.colorOverlay = const Color(0x66FF5252);
      case EliteEnemyType.siegeFighter:
        _sprite = Sprite(texture: f.sheet['enemy_destroyer_2.png']!);
        _sprite.scale = 0.38;
        _sprite.colorOverlay = const Color(0x66FFAB40);
      case EliteEnemyType.phaseStalker:
        _sprite = Sprite.fromImage(imageMap['assets/boss_phantom_clean.png']!);
        _sprite.scale = 0.038;
        _sprite.colorOverlay = const Color(0x605F8CFF);
      case EliteEnemyType.riftBomber:
        _sprite = Sprite(texture: f.sheet['enemy_boss_2.png']!);
        _sprite.scale = 0.38;
        _sprite.rotation = -90.0;
        _sprite.colorOverlay = const Color(0x70D44CFF);
      case EliteEnemyType.voidSentinel:
        _sprite = Sprite.fromImage(imageMap['assets/boss_venom_clean.png']!);
        _sprite.scale = 0.034;
        _sprite.colorOverlay = const Color(0x6053E6C5);
      case EliteEnemyType.riftLeech:
        _sprite =
            Sprite.fromImage(imageMap['assets/enemies/enemy_rift_leech.png']!);
        _sprite.scale = 0.034;
      case EliteEnemyType.shardBrood:
        _sprite =
            Sprite.fromImage(imageMap['assets/enemies/enemy_shard_brood.png']!);
        _sprite.scale = 0.034;
      case EliteEnemyType.riftWarden:
        _sprite =
            Sprite.fromImage(imageMap['assets/enemies/enemy_rift_warden.png']!);
        _sprite.scale = 0.043;
        _sprite.colorOverlay = const Color(0x2255E8FF);
      case EliteEnemyType.novaMiniBoss:
        _sprite = Sprite.fromImage(imageMap['assets/boss_nova_clean.png']!);
        _sprite.scale = 0.065;
      case EliteEnemyType.phantomMiniBoss:
        _sprite = Sprite.fromImage(imageMap['assets/boss_phantom_clean.png']!);
        _sprite.scale = 0.065;
      case EliteEnemyType.warshipMiniBoss:
        _sprite = Sprite(texture: f.sheet['enemy_boss_2.png']!);
        _sprite.scale = 0.46;
        // The source atlas art faces left; mini-bosses enter from above and
        // should face down toward the player.
        _sprite.rotation = -90.0;
        _sprite.colorOverlay = const Color(0x66FF5A36);
      case EliteEnemyType.titanBoss:
        _sprite = Sprite.fromImage(imageMap['assets/boss_titan_clean.png']!);
        _sprite.scale = 0.145;
      case EliteEnemyType.colossusBoss:
        _sprite = Sprite(texture: f.sheet['enemy_boss_0.png']!);
        _sprite.scale = 0.52;
        _sprite.colorOverlay = const Color(0x66AA00FF);
    }
  }

  void _configureStats() {
    final scaling = GameBalance.enemyHealth(1, threatLevel);
    switch (type) {
      case EliteEnemyType.droneMite:
        radius = 10;
        maxDamage = 5 * scaling;
        _shotCount = 1;
        _laserImpact = 4;
        _moveRange = 35;
        _moveDuration = 2.4;
      case EliteEnemyType.plasmaWasp:
        radius = 13;
        maxDamage = 10 * scaling;
        _shotCount = 2;
        _laserImpact = 5;
        _moveRange = 55;
        _moveDuration = 2.8;
      case EliteEnemyType.cometRammer:
        radius = 18;
        maxDamage = 18 * scaling;
        _shotCount = 1;
        _laserImpact = 7;
        _moveRange = 90;
        _moveDuration = 1.8;
      case EliteEnemyType.siegeFighter:
        radius = 28;
        maxDamage = 35 * scaling;
        _shotCount = 3;
        _laserImpact = 9;
        _moveRange = 70;
        _moveDuration = 3.2;
      case EliteEnemyType.phaseStalker:
        radius = 16;
        maxDamage = 16 * scaling;
        _shotCount = 2;
        _laserImpact = 5;
        _moveRange = 100;
        _moveDuration = 1.7;
      case EliteEnemyType.riftBomber:
        radius = 27;
        maxDamage = 34 * scaling;
        _shotCount = 4;
        _laserImpact = 7;
        _moveRange = 55;
        _moveDuration = 3.1;
      case EliteEnemyType.voidSentinel:
        radius = 33;
        maxDamage = 58 * scaling;
        _shotCount = 6;
        _laserImpact = 8;
        _moveRange = 90;
        _moveDuration = 4.0;
      case EliteEnemyType.riftLeech:
        radius = 20;
        maxDamage = 24 * scaling;
        _shotCount = 3;
        _laserImpact = 6;
        _moveRange = 105;
        _moveDuration = 1.8;
      case EliteEnemyType.shardBrood:
        radius = 17;
        maxDamage = 22 * scaling;
        _shotCount = 3;
        _laserImpact = 5;
        _moveRange = 48;
        _moveDuration = 2.0;
      case EliteEnemyType.riftWarden:
        radius = 24;
        maxDamage = 32 * scaling;
        _shotCount = 8;
        _laserImpact = 6;
        _moveRange = 78;
        _moveDuration = 2.3;
      case EliteEnemyType.novaMiniBoss:
        radius = 34;
        maxDamage = 90 * scaling;
        _shotCount = 5;
        _laserImpact = 8;
        _moveRange = 55;
        _moveDuration = 4.0;
        explosionScale = 1.6;
      case EliteEnemyType.phantomMiniBoss:
        radius = 38;
        maxDamage = 120 * scaling;
        _shotCount = 3;
        _laserImpact = 11;
        _moveRange = 85;
        _moveDuration = 4.5;
        explosionScale = 1.8;
      case EliteEnemyType.warshipMiniBoss:
        radius = 46;
        maxDamage = 150 * scaling;
        _shotCount = 5;
        _laserImpact = 10;
        _moveRange = 70;
        _moveDuration = 3.5;
        explosionScale = 2.0;
      case EliteEnemyType.titanBoss:
        radius = 65;
        maxDamage = 260 * scaling;
        _shotCount = 8;
        _laserImpact = 12;
        _moveRange = 70;
        _moveDuration = 5.5;
        explosionScale = 2.5;
      case EliteEnemyType.colossusBoss:
        radius = 74;
        maxDamage = 360 * scaling;
        _shotCount = 10;
        _laserImpact = 14;
        _moveRange = 100;
        _moveDuration = 6.0;
        explosionScale = 3.0;
    }
    damageResistance = switch (type) {
      EliteEnemyType.siegeFighter => 0.08,
      EliteEnemyType.voidSentinel => 0.10,
      EliteEnemyType.titanBoss => 0.12,
      EliteEnemyType.colossusBoss => 0.15,
      _ => 0.0,
    };
    _countDown = switch (type) {
      EliteEnemyType.titanBoss || EliteEnemyType.colossusBoss => 65,
      EliteEnemyType.novaMiniBoss ||
      EliteEnemyType.phantomMiniBoss ||
      EliteEnemyType.warshipMiniBoss =>
        85,
      EliteEnemyType.phaseStalker => 52,
      EliteEnemyType.riftBomber => 104,
      EliteEnemyType.voidSentinel => 82,
      EliteEnemyType.riftLeech => 58,
      EliteEnemyType.shardBrood => 72,
      EliteEnemyType.riftWarden => 108,
      _ => 120,
    };
  }

  @override
  void setupActions() {
    final action = ActionOscillate(
      (Offset value) => position = value,
      position,
      _moveRange,
      _moveDuration,
    );
    motions.run(MotionRepeatForever(motion: action));
  }

  @override
  void move() {
    if (type != EliteEnemyType.riftLeech) return;
    final shipX = f.level.ship.position.dx;
    final horizontalStep =
        ((shipX - position.dx) * 0.014).clamp(-0.8, 0.8).toDouble();
    position += Offset(horizontalStep, 0.24);
  }

  @override
  void destroy() {
    if (type == EliteEnemyType.shardBrood && parent != null) {
      for (final direction in const [-1.0, 1.0]) {
        final shard = EliteEnemy(
          f,
          EliteEnemyType.droneMite,
          math.max(1, threatLevel - 1),
        )..scoreReward = 20;
        f.addGameObject(shard, position + Offset(direction * 22.0, 10.0));
      }
    }
    // A mini-boss is registered as the active level gate. Clear it only when
    // this instance dies, so the next level cannot start early.
    if (f.playerState.boss == this) {
      f.playerState.boss = null;
    }
    _powerBar?.removeFromParent();
    super.destroy();
  }

  @override
  void update(double dt) {
    _animationTime += dt;
    if (type == EliteEnemyType.riftWarden) {
      final charge = (1.0 - (_countDown / 24.0)).clamp(0.0, 1.0).toDouble();
      _wardenAura?.charge = charge;
      _sprite.scale = _spriteBaseScale *
          (1.0 + math.sin(_animationTime * 5.2) * 0.018 + charge * 0.035);
      _sprite.rotation = math.sin(_animationTime * 1.7) * 3.2;
    }

    if (type == EliteEnemyType.phaseStalker) {
      _phaseFrame = (_phaseFrame + 1) % 180;
      final phased = _phaseFrame >= 126 && _phaseFrame < 148;
      _sprite.visible = !phased;
      canBeDamaged = !phased;
      canDamageShip = !phased;
    }

    final isRadial = type == EliteEnemyType.novaMiniBoss ||
        type == EliteEnemyType.voidSentinel ||
        type == EliteEnemyType.riftWarden ||
        _isGiant;
    _countDown--;
    if (_countDown == 24) {
      if (isRadial) {
        BossAttackPatterns.telegraphRadial(f, position, color: _shotColor);
      } else {
        BossAttackPatterns.telegraphAim(f, position, color: _shotColor);
      }
    }
    if (_countDown > 0) return;

    f.sounds.playEffect('laser');
    // Each mini-boss has a different signature attack:
    // Nova: radial ring; Phantom: fast aimed tri-shot; Warship: heavy fan.
    final toShip = f.level.ship.position - position;
    final aimAngle = degrees(math.atan2(toShip.dy, toShip.dx));
    for (var index = 0; index < _shotCount; index++) {
      final angle = isRadial
          ? index * (360.0 / _shotCount) + rotation
          : aimAngle + (index - (_shotCount - 1) / 2) * 16.0;
      final laser = EnemyLaser(
        f,
        // EnemyLaser's 0° points up; this angle uses the math convention.
        angle + 90.0,
        _laserImpact + threatLevel * 0.5,
        _shotColor,
        motion: type == EliteEnemyType.riftWarden ||
                type == EliteEnemyType.riftBomber
            ? EnemyProjectileMotion.weaving
            : EnemyProjectileMotion.straight,
        weaveAmplitude: type == EliteEnemyType.riftWarden ? 3.0 : 0.0,
        shipDamage: type == EliteEnemyType.riftWarden ? 0.8 : 1.0,
        highVisibility: type == EliteEnemyType.phantomMiniBoss ||
            type == EliteEnemyType.phaseStalker ||
            type == EliteEnemyType.voidSentinel ||
            type == EliteEnemyType.riftLeech ||
            type == EliteEnemyType.riftWarden ||
            _isGiant,
      );
      final radiansValue = radians(angle);
      laser.position = position +
          Offset(math.cos(radiansValue) * radius * 0.6,
              math.sin(radiansValue) * radius * 0.6);
      f.level.addChild(laser);
    }
    final attackCooldown = switch (type) {
      EliteEnemyType.titanBoss || EliteEnemyType.colossusBoss => 42,
      EliteEnemyType.phantomMiniBoss || EliteEnemyType.phaseStalker => 48,
      EliteEnemyType.warshipMiniBoss => 68,
      EliteEnemyType.riftBomber => 102,
      EliteEnemyType.voidSentinel => 74,
      EliteEnemyType.riftLeech => 58,
      EliteEnemyType.shardBrood => 72,
      EliteEnemyType.riftWarden => 92,
      EliteEnemyType.novaMiniBoss => 55,
      _ => 90,
    };
    _countDown = attackCooldown - (threatLevel * 3).clamp(0, 25);
  }

  Color get _shotColor => switch (type) {
        EliteEnemyType.phaseStalker => const Color(0xFFFF4DFF),
        EliteEnemyType.riftBomber => const Color(0xFFFF6D4D),
        EliteEnemyType.voidSentinel => const Color(0xFF55E8FF),
        EliteEnemyType.riftLeech => const Color(0xFFB56CFF),
        EliteEnemyType.shardBrood => const Color(0xFFFFB44A),
        EliteEnemyType.riftWarden => const Color(0xFF55E8FF),
        EliteEnemyType.phantomMiniBoss => const Color(0xFFFF4DFF),
        EliteEnemyType.warshipMiniBoss => Colors.redAccent,
        EliteEnemyType.titanBoss ||
        EliteEnemyType.colossusBoss =>
          const Color(0xFFFF4DFF),
        _ => Colors.orangeAccent,
      };

  @override
  Collectable createPowerUp() => _isMiniBoss ? Coin(f, value: 100) : Coin(f);

  @override
  set damage(double value) {
    super.damage = value;
    _sprite.colorOverlay = colorForDamage(value, maxDamage);
    _powerBar?.power = (1.0 - value / maxDamage).clamp(0.0, 1.0);
  }
}

/// Three rotating rift arcs charge around the Warden before it fires a radial
/// volley, giving the player a clear visual cue to evade.
class _RiftWardenAura extends Node {
  double _time = 0.0;
  double charge = 0.0;

  @override
  void update(double dt) {
    _time += dt;
  }

  @override
  void paint(Canvas canvas) {
    final pulse = (math.sin(_time * 4.0) + 1.0) * 0.5;
    final brightness = 0.24 + pulse * 0.18 + charge * 0.52;
    canvas.save();
    for (var ring = 0; ring < 3; ring++) {
      canvas.save();
      canvas.rotate(_time * (ring.isEven ? 0.48 : -0.36) + ring * 1.9);
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: 66.0 + ring * 12.0,
        height: 34.0 + ring * 7.0,
      );
      final start = ring * 2.1;
      final sweep = math.pi * (0.92 + charge * 0.52);
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = const Color(0xFFB66CFF).withValues(alpha: brightness)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ring == 0 ? 2.2 + charge : 1.1
          ..strokeCap = StrokeCap.round
          ..maskFilter =
              ui.MaskFilter.blur(ui.BlurStyle.normal, ring == 0 ? 5.0 : 2.2),
      );
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = const Color(0xFF8AF7FF).withValues(alpha: brightness * 0.76)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ring == 0 ? 0.9 : 0.6
          ..strokeCap = StrokeCap.round,
      );
      canvas.restore();
    }
    canvas.restore();
  }
}
