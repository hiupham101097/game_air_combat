import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/model/custom_actions.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

/// Eight enemy archetypes introduced gradually from level 2 onward.
enum EliteEnemyType {
  droneMite,
  plasmaWasp,
  cometRammer,
  siegeFighter,
  novaMiniBoss,
  phantomMiniBoss,
  titanBoss,
  colossusBoss,
}

class EliteEnemy extends Obstacle {
  EliteEnemy(GameObjectFactory f, this.type, this.threatLevel) : super(f) {
    _configureSprite();
    _configureStats();
    addChild(_sprite);
  }

  final EliteEnemyType type;
  final int threatLevel;
  late Sprite _sprite;
  late int _shotCount;
  late double _laserImpact;
  late double _moveRange;
  late double _moveDuration;
  int _countDown = 90;

  bool get _isGiant =>
      type == EliteEnemyType.titanBoss || type == EliteEnemyType.colossusBoss;

  bool get _isMiniBoss =>
      type == EliteEnemyType.novaMiniBoss ||
      type == EliteEnemyType.phantomMiniBoss;

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
      case EliteEnemyType.novaMiniBoss:
        _sprite = Sprite.fromImage(imageMap['assets/boss_nova.png']!);
        _sprite.scale = 0.075;
      case EliteEnemyType.phantomMiniBoss:
        _sprite = Sprite.fromImage(imageMap['assets/boss_phantom.png']!);
        _sprite.scale = 0.075;
      case EliteEnemyType.titanBoss:
        _sprite = Sprite.fromImage(imageMap['assets/boss_titan.png']!);
        _sprite.scale = 0.18;
      case EliteEnemyType.colossusBoss:
        _sprite = Sprite(texture: f.sheet['enemy_boss_0.png']!);
        _sprite.scale = 0.52;
        _sprite.colorOverlay = const Color(0x66AA00FF);
    }
  }

  void _configureStats() {
    final scaling = 1.0 + threatLevel * 0.22;
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
        _shotCount = 6;
        _laserImpact = 9;
        _moveRange = 85;
        _moveDuration = 4.5;
        explosionScale = 1.8;
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
    _countDown = _isGiant ? 65 : (_isMiniBoss ? 85 : 120);
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
  void update(double dt) {
    _countDown--;
    if (_countDown > 0) return;

    f.sounds.playEffect('laser');
    final isRadial = _isMiniBoss || _isGiant;
    for (var index = 0; index < _shotCount; index++) {
      final angle = isRadial
          ? index * (360.0 / _shotCount) + rotation
          : rotation + (index - (_shotCount - 1) / 2) * 16.0;
      final laser = EnemyLaser(
        f,
        angle,
        _laserImpact + threatLevel * 0.5,
        _isGiant ? Colors.deepPurpleAccent : Colors.orangeAccent,
      );
      final radiansValue = radians(angle);
      laser.position = position +
          Offset(math.cos(radiansValue) * radius * 0.6,
              math.sin(radiansValue) * radius * 0.6);
      f.level.addChild(laser);
    }
    _countDown = (_isGiant ? 42 : (_isMiniBoss ? 55 : 90)) -
        (threatLevel * 3).clamp(0, 25);
  }

  @override
  Collectable createPowerUp() => Coin(f);

  @override
  set damage(double value) {
    super.damage = value;
    _sprite.colorOverlay = colorForDamage(value, maxDamage);
  }
}
