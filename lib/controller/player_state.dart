import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/quest.dart';
import 'package:mini__game2/model/weapon.dart';
import 'package:mini__game2/model/equipment.dart';
import 'package:spritewidget/spritewidget.dart';



class PlayerState extends Node {
  PlayerState(this._sheetUI, this._sheetGame, this._gameState) {
    // Score display
    _spriteBackgroundScore = Sprite(texture: _sheetUI["scoreboard.png"]!);
    _spriteBackgroundScore.pivot = const Offset(1.0, 0.0);
    _spriteBackgroundScore.scale = 0.35;
    _spriteBackgroundScore.position = const Offset(240.0, 10.0);
    addChild(_spriteBackgroundScore);

    _scoreDisplay = ScoreDisplay(_sheetUI);
    _scoreDisplay.position = const Offset(349.0, 49.0);
    _spriteBackgroundScore.addChild(_scoreDisplay);

    // Coin display
    _spriteBackgroundCoins = Sprite(texture: _sheetUI["coinboard.png"]!);
    _spriteBackgroundCoins.pivot = const Offset(1.0, 0.0);
    _spriteBackgroundCoins.scale = 0.35;
    _spriteBackgroundCoins.position = const Offset(105.0, 10.0);
    addChild(_spriteBackgroundCoins);

    _coinDisplay = ScoreDisplay(_sheetUI);
    _coinDisplay.position = const Offset(252.0, 49.0);
    _spriteBackgroundCoins.addChild(_coinDisplay);

    // HP display
    _hpDisplay = HpDisplay(_sheetGame);
    _hpDisplay.position = const Offset(10.0, 15.0); // Top left
    addChild(_hpDisplay);

    laserLevel = _gameState.laserLevel;

    // Fix: WeaponConfig.weapons keys are WeaponType, not int.
    // Use WeaponType.values[index] to get the correct enum then look up.
    int weaponIdx = _gameState.equippedWeapon.clamp(0, WeaponType.values.length - 1);
    currentWeapon = WeaponType.values[weaponIdx];

    _calculateEquipmentStats();
  }

  int droneEquipmentLevel = 1;

  void _calculateEquipmentStats() {
    int bonusHp = 0;
    double bonusDamage = 0.0;
    double bonusSpeed = 0.0;
    
    _gameState.equippedLoadout.forEach((slot, id) {
      EquipmentItem? item = EquipmentItem.getById(id);
      if (item != null) {
        int level = _gameState.equipmentLevels[id] ?? 1;
        bonusHp += item.getHpBonus(level);
        bonusDamage += item.getDamageMultiplier(level);
        bonusSpeed += item.getSpeedMultiplier(level);
        if (item.slot == EquipmentSlot.drone) {
          droneEquipment = item;
          droneEquipmentLevel = level;
        }
      }
    });

    maxHp = 3 + bonusHp;
    hp = maxHp; // Start with full HP
    damageMultiplier = 1.0 + bonusDamage;
    speedMultiplier = 1.0 + bonusSpeed;
    
    // Adjust scroll speed with engine speed multiplier
    scrollSpeed = normalScrollSpeed * speedMultiplier;
  }

  final SpriteSheet _sheetUI;
  final SpriteSheet _sheetGame;
  final PersistantGameState _gameState;

  int laserLevel = 0;
  late WeaponType currentWeapon;

  void changeWeapon(WeaponType type) {
    currentWeapon = type;
    // Maybe show a flash or effect later
  }

  static const double normalScrollSpeed = 2.0;

  double scrollSpeed = normalScrollSpeed;

  double _scrollSpeedTarget = normalScrollSpeed;

  Obstacle? boss;

  late Sprite _spriteBackgroundScore;
  late ScoreDisplay _scoreDisplay;
  late Sprite _spriteBackgroundCoins;
  late ScoreDisplay _coinDisplay;
  late HpDisplay _hpDisplay;

  int get score => _scoreDisplay.score;

  set score(int score) {
    _scoreDisplay.score = score;
    flashBackgroundSprite(_spriteBackgroundScore);
  }

  void enemyKilled() {
    _gameState.updateQuestProgress(QuestType.killEnemies, 1);
  }

  int get coins => _coinDisplay.score;

  void addCoin(Coin c) {
    // Animate coin to the top of the screen
    Offset startPos = convertPointFromNode(Offset.zero, c);
    Offset finalPos = const Offset(30.0, 30.0);
    Offset middlePos = Offset((startPos.dx + finalPos.dx) / 2.0 + 50.0,
        (startPos.dy + finalPos.dy) / 2.0);

    List<Offset> path = <Offset>[startPos, middlePos, finalPos];

    Sprite sprite = Sprite(texture: _sheetGame["coin.png"]!);
    sprite.scale = 0.7;

    MotionSpline spline = MotionSpline(
      setter: (Offset a) => sprite.position = a,
      points: path,
      duration: 0.5,
    );
    spline.tension = 0.25;
    MotionTween rotate = MotionTween<double>(
      setter: (a) => sprite.rotation = a,
      start: 0.0,
      end: 360.0,
      duration: 0.5,
    );
    MotionTween scale = MotionTween<double>(
      setter: (a) => sprite.scale = a,
      start: 0.7,
      end: 1.2,
      duration: 0.5,
    );
    MotionGroup group = MotionGroup(motions: [spline, rotate, scale]);
    sprite.motions.run(
      MotionSequence(
        motions: [
          group,
          MotionRemoveNode(node: sprite),
          MotionCallFunction(
            callback: () {
              _coinDisplay.score += 1;
              flashBackgroundSprite(_spriteBackgroundCoins);
            },
          ),
        ],
      ),
    );

    addChild(sprite);
  }

  void activatePowerUp(PowerUpType type) {
    if (type == PowerUpType.shield) {
      _shieldFrames += _gameState.powerUpFrames(type);
    } else if (type == PowerUpType.sideLaser) {
      _sideLaserFrames += _gameState.powerUpFrames(type);
    } else if (type == PowerUpType.speedLaser) {
      _speedLaserFrames += _gameState.powerUpFrames(type);
    } else if (type == PowerUpType.speedBoost) {
      _speedBoostFrames += _gameState.powerUpFrames(type);
      _shieldFrames += _gameState.powerUpFrames(type) + 60;
    } else if (type == PowerUpType.heal) {
      hp = (hp + 1).clamp(0, maxHp);
    } else if (type == PowerUpType.magnet) {
      _magnetFrames += 600; // 10 seconds at 60fps
    } else if (type == PowerUpType.nuke) {
      activateNuke = true;
    }
  }

  int hp = 3;
  int maxHp = 3;

  double damageMultiplier = 1.0;
  double speedMultiplier = 1.0;
  EquipmentItem? droneEquipment;

  bool activateNuke = false;

  int _magnetFrames = 0;
  bool get magnetActive => _magnetFrames > 0;

  int _shieldFrames = 0;
  bool get shieldActive => _shieldFrames > 0 || _speedBoostFrames > 0 || hpInvincibilityFrames > 0;
  bool get shieldDeactivating =>
      math.max(_shieldFrames, _speedBoostFrames) > 0 &&
      math.max(_shieldFrames, _speedBoostFrames) < 60;

  int hpInvincibilityFrames = 0; // Temp invincibility after taking a hit

  int _sideLaserFrames = 0;
  bool get sideLaserActive => _sideLaserFrames > 0;

  int _speedLaserFrames = 0;
  bool get speedLaserActive => _speedLaserFrames > 0;

  int _speedBoostFrames = 0;
  bool get speedBoostActive => _speedBoostFrames > 0;

  void flashBackgroundSprite(Sprite sprite) {
    sprite.motions.stopAll();
    MotionTween flash = MotionTween<Color>(
      setter: (a) => sprite.colorOverlay = a,
      start: const Color(0x66ccfff0),
      end: const Color(0x00ccfff0),
      duration: 0.3,
    );
    sprite.motions.run(flash);
  }

  @override
  void update(double dt) {
    if (_shieldFrames > 0) {
      _shieldFrames--;
    }
    if (_sideLaserFrames > 0) {
      _sideLaserFrames--;
    }
    if (_speedLaserFrames > 0) {
      _speedLaserFrames--;
    }
    if (_speedBoostFrames > 0) {
      _speedBoostFrames--;
    }
    if (_magnetFrames > 0) {
      _magnetFrames--;
    }
    if (hpInvincibilityFrames > 0) {
      hpInvincibilityFrames--;
    }
    
    _hpDisplay.hp = hp; // Sync HP display

    // Update speed
    if (boss != null) {
      Offset globalBossPos = boss!.convertPointToBoxSpace(Offset.zero);
      if (globalBossPos.dy > (gameSizeHeight - 400.0)) {
        _scrollSpeedTarget = 0.0;
      } else {
        _scrollSpeedTarget = normalScrollSpeed;
      }
    } else {
      if (speedBoostActive) {
        _scrollSpeedTarget = normalScrollSpeed * 6.0;
      } else {
        _scrollSpeedTarget = normalScrollSpeed;
      }
    }

    scrollSpeed = GameMath.filter(scrollSpeed, _scrollSpeedTarget, 0.1);
  }
}

class ScoreDisplay extends Node {
  ScoreDisplay(this._sheetUI);

  int _score = 0;

  int get score => _score;

  set score(int score) {
    _score = score;
    _dirtyScore = true;
  }

  final SpriteSheet _sheetUI;

  bool _dirtyScore = true;

  @override
  void update(double dt) {
    if (_dirtyScore) {
      removeAllChildren();

      String scoreStr = _score.toString();
      double xPos = -37.0;
      for (int i = scoreStr.length - 1; i >= 0; i--) {
        String numStr = scoreStr.substring(i, i + 1);
        Sprite numSprite = Sprite(texture: _sheetUI["number_$numStr.png"]!);
        numSprite.position = Offset(xPos, 0.0);
        addChild(numSprite);
        xPos -= 37.0;
      }
      _dirtyScore = false;
    }
  }
}

class HpDisplay extends Node {
  HpDisplay(this._sheetUI); // receives _sheetGame which has powerup_0.png

  int _hp = 3;

  int get hp => _hp;

  set hp(int hp) {
    if (_hp != hp) {
      _hp = hp;
      _dirtyHp = true;
    }
  }

  final SpriteSheet _sheetUI;
  bool _dirtyHp = true;

  @override
  void update(double dt) {
    if (_dirtyHp) {
      removeAllChildren();
      double xPos = 0.0;
      for (int i = 0; i < _hp; i++) {
        // We'll use a powerup shield icon as a makeshift heart/health icon since we don't have hearts
        Sprite hpSprite = Sprite(texture: _sheetUI["powerup_0.png"]!);
        hpSprite.colorOverlay = const Color.fromARGB(255, 255, 50, 50); // Red tint
        hpSprite.scale = 0.3;
        hpSprite.position = Offset(xPos, 0.0);
        addChild(hpSprite);
        xPos += 20.0;
      }
      _dirtyHp = false;
    }
  }
}
