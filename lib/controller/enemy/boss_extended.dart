import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/enemy/boss_attack_patterns.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/model/custom_actions.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/flash.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_balance.dart';
import 'package:mini__game2/controller/power/power_bar.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

/// BOSS NOVA — Pulsing star core. Fires radial bursts.
class BossNova extends Obstacle {
  BossNova(GameObjectFactory f, int level) : super(f) {
    radius = 52.0;
    _sprite = Sprite.fromImage(imageMap['assets/boss_nova_clean.png']!);
    _sprite.scale = 0.12;
    addChild(_sprite);
    maxDamage = GameBalance.bossHealth(level, 1.0);

    _powerBar = PowerBar(const Size(70.0, 10.0));
    _powerBar.pivot = const Offset(0.5, 0.5);
    f.level.addChild(_powerBar);
    _powerBar.constraints = <Constraint>[
      ConstraintPositionToNode(
          targetNode: this, dampening: 0.5, offset: const Offset(0.0, -90.0))
    ];
  }

  late Sprite _sprite;
  late PowerBar _powerBar;
  int _countdown = 90;
  int _burstCount = 0;
  int _phase = 1;
  double _angle = 0.0;

  @override
  void setupActions() {
    ActionOscillate osc =
        ActionOscillate((Offset a) => position = a, position, 60.0, 5.0);
    motions.run(MotionRepeatForever(motion: osc));
    MotionTween spin = MotionTween<double>(
        setter: (a) => _sprite.rotation = a, start: 0, end: 360, duration: 3.0);
    _sprite.motions.run(MotionRepeatForever(motion: spin));
  }

  @override
  void update(double dt) {
    _countdown--;
    if (_countdown == 26) {
      BossAttackPatterns.telegraphRadial(f, position,
          color: const Color(0xFFFFD35A));
    }
    if (_countdown <= 0) {
      f.sounds.playEffect("laser");
      // Radial burst — fires N lasers outward
      int numShots = 6 + _phase * 2 + (_burstCount % 2) * 2;
      for (int i = 0; i < numShots; i++) {
        double angle = _angle + (360.0 / numShots) * i;
        EnemyLaser laser = EnemyLaser(
          f,
          angle + 90.0,
          3.8,
          const Color(0xFFFFDD44),
          motion: EnemyProjectileMotion.weaving,
          weaveAmplitude: 3.0,
          shipDamage: 0.75,
          highVisibility: true,
        );
        double rad = radians(angle);
        laser.position =
            position + Offset(math.cos(rad) * 40, math.sin(rad) * 40);
        f.level.addChild(laser);
      }
      _angle += 15; // Rotate pattern each burst
      _burstCount++;
      _countdown = 60;
    }
  }

  @override
  void destroy() {
    f.playerState.boss = null;
    if (_powerBar.parent != null) _powerBar.removeFromParent();
    NodeWithSize screen = f.playerState.parent as NodeWithSize;
    screen.addChild(Flash(screen.size, 1.5));
    super.destroy();
    for (int i = 0; i < 10; i++) {
      Coin coin = Coin(f, value: 10);
      f.addGameObject(
          coin,
          Offset(randomSignedDouble() * 160,
              position.dy + randomSignedDouble() * 180));
    }
  }

  @override
  Explosion createExplosion() {
    f.sounds.playEffect("explosion_boss");
    ExplosionBig explo = ExplosionBig(f.sheet);
    explo.scale = 2.5;
    return explo;
  }

  @override
  set damage(double d) {
    super.damage = d;
    _sprite.motions.stopAll();
    _sprite.motions.run(MotionTween<Color>(
        setter: (a) => _sprite.colorOverlay = a,
        start: const Color.fromARGB(200, 255, 255, 0),
        end: Colors.transparent,
        duration: 0.3));
    _powerBar.power = (1.0 - damage / maxDamage).clamp(0.0, 1.0);
    final hpRatio = 1.0 - damage / maxDamage;
    _phase = hpRatio < 0.33
        ? 3
        : hpRatio < 0.66
            ? 2
            : 1;
  }
}

/// BOSS PHANTOM — Cloaking boss. Periodically turns invisible.
class BossPhantom extends Obstacle {
  BossPhantom(GameObjectFactory f, int level) : super(f) {
    radius = 38.0;
    _sprite = Sprite.fromImage(imageMap['assets/boss_phantom_clean.png']!);
    _sprite.scale = 0.10;
    addChild(_sprite);
    maxDamage = GameBalance.bossHealth(level, 0.85);

    _powerBar = PowerBar(const Size(60.0, 10.0));
    _powerBar.pivot = const Offset(0.5, 0.5);
    f.level.addChild(_powerBar);
    _powerBar.constraints = <Constraint>[
      ConstraintPositionToNode(
          targetNode: this, dampening: 0.5, offset: const Offset(0.0, -75.0))
    ];
  }

  late Sprite _sprite;
  late PowerBar _powerBar;
  int _stateTimer = 150;
  int _state = 0; // 0: visible+moving, 1: cloaking, 2: cloaked+attacking
  bool _cloaked = false;
  double _lockedAngle = 0.0;

  @override
  void setupActions() {
    ActionOscillate osc =
        ActionOscillate((Offset a) => position = a, position, 140.0, 2.5);
    motions.run(MotionRepeatForever(motion: osc));
  }

  @override
  void update(double dt) {
    _stateTimer--;

    if (_state == 0 && _stateTimer <= 0) {
      // Start cloaking
      _state = 1;
      _stateTimer = 30;
      _sprite.motions.run(MotionTween<double>(
          setter: (a) => _sprite.opacity = a,
          start: 1.0,
          end: 0.0,
          duration: 0.5));
    } else if (_state == 1 && _stateTimer <= 0) {
      // Fully cloaked — fire triple burst
      _state = 2;
      _stateTimer = 89;
      _cloaked = true;
      canBeDamaged = false; // Immune while cloaked
    } else if (_state == 2 && _stateTimer <= 0) {
      // Decloak
      _state = 0;
      _stateTimer = 180;
      _cloaked = false;
      canBeDamaged = true;
      _sprite.motions.run(MotionTween<double>(
          setter: (a) => _sprite.opacity = a,
          start: 0.0,
          end: 1.0,
          duration: 0.5));
    }

    if (_cloaked && _stateTimer % 45 == 24) {
      _lockedAngle = BossAttackPatterns.angleToShip(f, position);
      BossAttackPatterns.telegraphAim(f, position,
          color: const Color(0xFFFF69DC));
    }
    if (_cloaked && _stateTimer % 45 == 0) {
      _fireTriple(_lockedAngle);
    }
  }

  void _fireTriple(double centerAngle) {
    f.sounds.playEffect("laser");
    BossAttackPatterns.fireFan(
      f,
      origin: position,
      centerAngle: centerAngle,
      count: 3,
      spreadDegrees: 30.0,
      speed: 5.5,
      color: const Color(0xFFFF4DFF),
      motion: EnemyProjectileMotion.weaving,
      weaveAmplitude: 3.5,
      shipDamage: 0.8,
      hitRadius: 7.0,
    );
  }

  @override
  void destroy() {
    canBeDamaged = true;
    _sprite.opacity = 1.0;
    f.playerState.boss = null;
    if (_powerBar.parent != null) _powerBar.removeFromParent();
    NodeWithSize screen = f.playerState.parent as NodeWithSize;
    screen.addChild(Flash(screen.size, 1.0));
    super.destroy();
    for (int i = 0; i < 10; i++) {
      Coin coin = Coin(f, value: 10);
      f.addGameObject(
          coin,
          Offset(randomSignedDouble() * 160,
              position.dy + randomSignedDouble() * 160));
    }
  }

  @override
  Explosion createExplosion() {
    f.sounds.playEffect("explosion_boss");
    ExplosionBig explo = ExplosionBig(f.sheet);
    explo.scale = 1.8;
    return explo;
  }

  @override
  set damage(double d) {
    if (!canBeDamaged) return;
    super.damage = d;
    if (!_cloaked) {
      _sprite.motions.run(MotionTween<Color>(
          setter: (a) => _sprite.colorOverlay = a,
          start: const Color.fromARGB(200, 180, 0, 255),
          end: Colors.transparent,
          duration: 0.3));
    }
    _powerBar.power = (1.0 - damage / maxDamage).clamp(0.0, 1.0);
  }
}

/// BOSS TITAN — Slow tank. Fires massive high-damage railgun shells.
class BossTitan extends Obstacle {
  BossTitan(GameObjectFactory f, int level) : super(f) {
    radius = 60.0;
    damageResistance = 0.12;
    _sprite = Sprite.fromImage(imageMap['assets/boss_titan_clean.png']!);
    _sprite.scale = 0.14;
    addChild(_sprite);
    maxDamage = GameBalance.bossHealth(level, 1.25);

    _powerBar = PowerBar(const Size(90.0, 12.0));
    _powerBar.pivot = const Offset(0.5, 0.5);
    f.level.addChild(_powerBar);
    _powerBar.constraints = <Constraint>[
      ConstraintPositionToNode(
          targetNode: this, dampening: 0.5, offset: const Offset(0.0, -100.0))
    ];
  }

  late Sprite _sprite;
  late PowerBar _powerBar;
  int _countdown = 200; // Slow fire rate
  int _phase = 1;
  double _lockedAngle = 0.0;

  @override
  void setupActions() {
    // Very slow horizontal movement
    ActionOscillate osc =
        ActionOscillate((Offset a) => position = a, position, 50.0, 8.0);
    motions.run(MotionRepeatForever(motion: osc));
  }

  @override
  void update(double dt) {
    _countdown--;
    if (_countdown == 30) {
      _lockedAngle = BossAttackPatterns.angleToShip(f, position);
      BossAttackPatterns.telegraphAim(f, position,
          color: const Color(0xFFFF563D), extraLength: 90.0);
    }
    if (_countdown <= 0) {
      f.sounds.playEffect("explosion_1"); // Heavy thud sound
      // Fire massive railgun burst toward player
      BossAttackPatterns.fireFan(
        f,
        origin: position,
        centerAngle: _lockedAngle,
        count: _phase,
        spreadDegrees: 8.0 + (_phase - 1) * 8.0,
        speed: 14.0,
        color: const Color(0xFFFF4400),
        shipDamage: 1.5,
        hitRadius: 15.0,
        spawnDistance: 50.0,
        highVisibility: true,
      );
      _countdown = 240 ~/ _phase;
    }
  }

  @override
  void destroy() {
    f.playerState.boss = null;
    if (_powerBar.parent != null) _powerBar.removeFromParent();
    NodeWithSize screen = f.playerState.parent as NodeWithSize;
    screen.addChild(Flash(screen.size, 2.0));
    super.destroy();
    for (int i = 0; i < 10; i++) {
      Coin coin = Coin(f, value: 10);
      f.addGameObject(
          coin,
          Offset(randomSignedDouble() * 160,
              position.dy + randomSignedDouble() * 200));
    }
  }

  @override
  Explosion createExplosion() {
    f.sounds.playEffect("explosion_boss");
    ExplosionBig explo = ExplosionBig(f.sheet);
    explo.scale = 3.0;
    return explo;
  }

  @override
  set damage(double d) {
    super.damage = d;
    _sprite.motions.stopAll();
    _sprite.motions.run(MotionTween<Color>(
        setter: (a) => _sprite.colorOverlay = a,
        start: const Color.fromARGB(200, 255, 80, 0),
        end: Colors.transparent,
        duration: 0.3));
    double hpRatio = 1.0 - (damage / maxDamage);
    _powerBar.power = hpRatio.clamp(0.0, 1.0);
    if (hpRatio < 0.5) _phase = 2;
    if (hpRatio < 0.25) _phase = 3;
  }
}

/// BOSS VENOM — Bio-mechanical alien. Fires toxic homing shots.
class BossVenom extends Obstacle {
  BossVenom(GameObjectFactory f, int level) : super(f) {
    radius = 44.0;
    // No custom image — draw with shader using boss_0 tinted green
    _sprite = Sprite.fromImage(imageMap['assets/boss_venom_clean.png']!);
    _sprite.scale = 0.09;
    addChild(_sprite);
    maxDamage = GameBalance.bossHealth(level, 0.95);

    _powerBar = PowerBar(const Size(65.0, 10.0));
    _powerBar.pivot = const Offset(0.5, 0.5);
    f.level.addChild(_powerBar);
    _powerBar.constraints = <Constraint>[
      ConstraintPositionToNode(
          targetNode: this, dampening: 0.5, offset: const Offset(0.0, -80.0))
    ];
  }

  late Sprite _sprite;
  late PowerBar _powerBar;
  int _countdown = 80;
  int _volley = 0;
  double _lockedAngle = 0.0;

  @override
  void setupActions() {
    // Organic wavering motion
    ActionOscillate oscH =
        ActionOscillate((Offset a) => position = a, position, 100.0, 3.0);
    motions.run(MotionRepeatForever(motion: oscH));
    // Pulse scale
    MotionTween<double> pulse = MotionTween<double>(
        setter: (a) => _sprite.scale = a,
        start: 0.085,
        end: 0.10,
        duration: 0.8);
    _sprite.motions.run(MotionRepeatForever(motion: pulse));
  }

  @override
  void update(double dt) {
    _countdown--;

    if (_countdown == 26) {
      _lockedAngle = BossAttackPatterns.angleToShip(f, position);
      BossAttackPatterns.telegraphAim(f, position,
          color: const Color(0xFF62FF7B));
    }
    if (_countdown <= 0) {
      f.sounds.playEffect("laser");
      // Fire toxic spread aimed at ship
      if (_volley.isEven) {
        BossAttackPatterns.fireFan(
          f,
          origin: position,
          centerAngle: _lockedAngle,
          count: 5,
          spreadDegrees: 46.0,
          speed: 5.0,
          color: const Color(0xFF44FF44),
          motion: EnemyProjectileMotion.weaving,
          weaveAmplitude: 5.0,
          shipDamage: 0.75,
          hitRadius: 7.0,
        );
      } else {
        BossAttackPatterns.fireFan(
          f,
          origin: position,
          centerAngle: _lockedAngle,
          count: 3,
          spreadDegrees: 26.0,
          speed: 3.8,
          color: const Color(0xFF7DFF54),
          motion: EnemyProjectileMotion.seeking,
          turnRate: 0.008,
          shipDamage: 0.8,
          hitRadius: 10.0,
          highVisibility: true,
        );
      }
      _volley++;
      _countdown = 76;
    }
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
      f.addGameObject(
          coin,
          Offset(randomSignedDouble() * 160,
              position.dy + randomSignedDouble() * 160));
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
    _sprite.motions.run(MotionTween<Color>(
        setter: (a) => _sprite.colorOverlay = a,
        start: const Color.fromARGB(220, 200, 255, 200),
        end: Colors.transparent,
        duration: 0.3));
    _powerBar.power = (1.0 - damage / maxDamage).clamp(0.0, 1.0);
  }
}

/// BOSS COLOSSUS — Massive siege platform. Fires volleys from multiple turrets.
class BossColossus extends Obstacle {
  BossColossus(GameObjectFactory f, int level) : super(f) {
    radius = 58.0;
    damageResistance = 0.15;
    // Draw using boss_2 tinted dark with orange highlights
    _sprite = Sprite.fromImage(imageMap['assets/boss_colossus_clean.png']!);
    _sprite.scale = 0.12;
    addChild(_sprite);
    maxDamage = GameBalance.bossHealth(level, 1.15);

    _powerBar = PowerBar(const Size(85.0, 12.0));
    _powerBar.pivot = const Offset(0.5, 0.5);
    f.level.addChild(_powerBar);
    _powerBar.constraints = <Constraint>[
      ConstraintPositionToNode(
          targetNode: this, dampening: 0.5, offset: const Offset(0.0, -95.0))
    ];
  }

  late Sprite _sprite;
  late PowerBar _powerBar;
  int _countdown = 56;
  int _volley = 0;
  int _phase = 1;
  double _lockedAngle = 0.0;
  int _targetTurret = 0;

  // Turret positions relative to center
  final List<Offset> _turrets = const [
    Offset(-50, 0),
    Offset(50, 0),
    Offset(-30, -30),
    Offset(30, -30),
    Offset(0, 40),
  ];

  @override
  void setupActions() {
    // Very slow drift — it's a platform
    ActionOscillate osc =
        ActionOscillate((Offset a) => position = a, position, 30.0, 12.0);
    motions.run(MotionRepeatForever(motion: osc));
  }

  @override
  void update(double dt) {
    _countdown--;
    if (_countdown == 26) {
      _targetTurret = _volley % _turrets.length;
      final turretPosition = position + _turrets[_targetTurret];
      _lockedAngle = BossAttackPatterns.angleToShip(f, turretPosition);
      BossAttackPatterns.telegraphAim(f, turretPosition,
          color: const Color(0xFFFFA341));
      if (_phase >= 2) {
        final pairedIndex =
            (_targetTurret + _turrets.length ~/ 2) % _turrets.length;
        BossAttackPatterns.telegraphAim(
          f,
          position + _turrets[pairedIndex],
          color: const Color(0xFFFFA341),
        );
      }
    }
    if (_countdown <= 0) {
      f.sounds.playEffect("laser");
      // Fire from one turret at a time, cycling through all
      final pairedIndex =
          (_targetTurret + _turrets.length ~/ 2) % _turrets.length;
      final selectedTurrets = _phase == 1
          ? <int>[_targetTurret]
          : <int>[_targetTurret, pairedIndex];
      for (var index = 0; index < selectedTurrets.length; index++) {
        final turretPosition = position + _turrets[selectedTurrets[index]];
        final centerAngle = index == 0
            ? _lockedAngle
            : BossAttackPatterns.angleToShip(f, turretPosition);
        BossAttackPatterns.fireFan(
          f,
          origin: turretPosition,
          centerAngle: centerAngle,
          count: _phase,
          spreadDegrees: 12.0 + _phase * 5.0,
          speed: 7.0 + _phase * 0.35,
          color: const Color(0xFFFF8800),
          motion: EnemyProjectileMotion.weaving,
          weaveAmplitude: 2.8,
          shipDamage: 0.9,
          hitRadius: 9.0,
          spawnDistance: 20.0,
        );
      }
      _volley++;
      _countdown = 56 - (_phase - 1) * 8;
    }
  }

  @override
  void destroy() {
    f.playerState.boss = null;
    if (_powerBar.parent != null) _powerBar.removeFromParent();
    NodeWithSize screen = f.playerState.parent as NodeWithSize;
    screen.addChild(Flash(screen.size, 2.0));
    super.destroy();
    for (int i = 0; i < 10; i++) {
      Coin coin = Coin(f, value: 10);
      f.addGameObject(
          coin,
          Offset(randomSignedDouble() * 160,
              position.dy + randomSignedDouble() * 200));
    }
  }

  @override
  Explosion createExplosion() {
    f.sounds.playEffect("explosion_boss");
    ExplosionBig explo = ExplosionBig(f.sheet);
    explo.scale = 3.5;
    return explo;
  }

  @override
  set damage(double d) {
    super.damage = d;
    _sprite.motions.run(MotionTween<Color>(
        setter: (a) => _sprite.colorOverlay = a,
        start: const Color.fromARGB(200, 255, 140, 0),
        end: const Color(0xAA222222),
        duration: 0.3));
    double hpRatio = 1.0 - (damage / maxDamage);
    _powerBar.power = hpRatio.clamp(0.0, 1.0);
    if (hpRatio < 0.66) _phase = 2;
    if (hpRatio < 0.33) _phase = 3;
  }
}
