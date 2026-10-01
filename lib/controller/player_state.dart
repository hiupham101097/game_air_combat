import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_balance.dart';
import 'package:mini__game2/model/combat_damage.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/l10n/generated/app_localizations.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/quest.dart';
import 'package:mini__game2/model/weapon.dart';
import 'package:mini__game2/model/equipment.dart';
import 'package:mini__game2/model/combat_stats.dart';
import 'package:mini__game2/model/run_upgrade.dart';
import 'package:mini__game2/model/ship_model.dart';
import 'package:spritewidget/spritewidget.dart';

/// A permanent, run-only strength reward earned for defeating a boss.
enum BossBuffType { green, purple, gold }

class BossBuffReward {
  const BossBuffReward(this.type, this.percent);

  final BossBuffType type;
  final int percent;
}

class PlayerState extends Node {
  PlayerState(
      this._sheetUI, this._sheetGame, this._gameState, this._localizations) {
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

    _comboDisplay = ComboDisplay(_localizations)
      ..position = const Offset(160.0, 76.0);
    addChild(_comboDisplay);

    _runProgressDisplay = RunProgressDisplay(_localizations)
      ..position = const Offset(160.0, 100.0);
    addChild(_runProgressDisplay);

    laserLevel = _gameState.laserLevel;

    // Each fighter owns a fixed primary weapon. Pickups no longer replace it,
    // so choosing a ship always changes both the firing pattern and projectile.
    currentWeapon = equippedShip.weapon;

    _calculateEquipmentStats();
  }

  int droneEquipmentLevel = 1;
  late CombatStatBlock _equipmentStats;

  void _calculateEquipmentStats() {
    final entries = <EquipmentStatEntry>[];
    for (final id in _gameState.equippedLoadout.values) {
      final item = EquipmentItem.getById(id);
      if (item == null) continue;
      final level = _gameState.equipmentLevels[id] ?? 1;
      entries.add(EquipmentStatEntry(item, level));
      if (item.slot == EquipmentSlot.drone) {
        droneEquipment = item;
        droneEquipmentLevel = level;
      }
    }
    _equipmentStats = CombatStatBlock.fromLoadout(
      ship: equippedShip,
      equipment: entries,
    );

    maxHp = _equipmentStats.maxHp;
    hp = maxHp; // Start with full HP
    _hpDisplay
      ..hp = hp
      ..maxHp = maxHp;
    _equipmentDamageMultiplier = _equipmentStats.damageMultiplier;
    speedMultiplier = _equipmentStats.movementMultiplier;
    armorDamageReduction = _equipmentStats.armorReduction;
  }

  final SpriteSheet _sheetUI;
  final SpriteSheet _sheetGame;
  final PersistantGameState _gameState;
  final AppLocalizations _localizations;

  int laserLevel = 0;
  late WeaponType currentWeapon;
  Color projectileColor = Colors.white;
  int _ammoBuffFrames = 0;
  double ammoDamageMultiplier = 1.0;
  int _adPowerFrames = 0;
  double adDamageMultiplier = 1.0;

  bool get hasProjectileColor => projectileColor != Colors.white;

  Ship get equippedShip => ShipConfig
      .ships[_gameState.equippedShip.clamp(0, ShipConfig.ships.length - 1)];

  CombatStatBlock get combatStats => _equipmentStats.withRuntime(
        maxHp: maxHp,
        currentHp: hp,
        damageMultiplier: damageMultiplier,
        fireRateMultiplier:
            _equipmentStats.fireRateMultiplier * runFireRateMultiplier,
        criticalChance: criticalChance,
        projectileCount: _equipmentStats.projectileCount + extraVolleyShots,
        movementMultiplier: movementMultiplier,
        shieldActive: shieldActive,
        shieldFrames: activeShieldFrames,
      );

  double get criticalChance =>
      (_equipmentStats.criticalChance + _runCriticalChance)
          .clamp(0.0, 0.5)
          .toDouble();
  double get movementMultiplier =>
      _equipmentStats.movementMultiplier * (1.0 + _runMovementBonus);
  double get criticalDamageMultiplier =>
      _equipmentStats.criticalDamageMultiplier;
  double get skillChargeMultiplier => _equipmentStats.skillChargeMultiplier;
  double get skillCooldownMultiplier => _equipmentStats.skillCooldownMultiplier;
  ArmorPassive get armorPassive => _equipmentStats.armorPassive;

  final ValueNotifier<int> riftChargeNotifier = ValueNotifier<int>(0);
  int get riftCharge => riftChargeNotifier.value;

  void gainRiftCharge(int amount) {
    riftChargeNotifier.value = (riftCharge + amount).clamp(0, 100).toInt();
  }

  bool spendRiftCharge() {
    if (riftCharge < 100) return false;
    riftChargeNotifier.value = 0;
    return true;
  }

  void changeWeapon(WeaponType type) {
    // The ship keeps its own firing pattern. Ammo drops are a temporary
    // combat buff: +15% damage for 10 seconds, refreshing on every pickup.
    _ammoBuffFrames = 600;
    ammoDamageMultiplier = 1.15;
    projectileColor = switch (type) {
      WeaponType.spread => const Color(0xFFFFD54F),
      WeaponType.homing => const Color(0xFF29B6F6),
      WeaponType.piercing || WeaponType.nova => const Color(0xFFC77DFF),
      WeaponType.rapid => const Color(0xFF69F0AE),
      WeaponType.plasma => const Color(0xFFFF8A65),
      WeaponType.phase => const Color(0xFF55E8FF),
      WeaponType.arc => const Color(0xFFB56CFF),
      WeaponType.flak => const Color(0xFFFFB44A),
      WeaponType.basic => Colors.white,
    };
  }

  /// Rewarded-ad boost: rolls +3%, +4%, or +5% weapon damage for 15 seconds.
  int activateAdPowerBoost() {
    final percent = 3 + math.Random().nextInt(3);
    _adPowerFrames = 900;
    adDamageMultiplier = 1.0 + percent / 100;
    return percent;
  }

  double get weaponDamageMultiplier =>
      WeaponConfig.weapons[currentWeapon]?.damageMultiplier ?? 1.0;

  static const double normalScrollSpeed = 2.0;

  double scrollSpeed = normalScrollSpeed;

  double _scrollSpeedTarget = normalScrollSpeed;

  Obstacle? boss;

  late Sprite _spriteBackgroundScore;
  late ScoreDisplay _scoreDisplay;
  late Sprite _spriteBackgroundCoins;
  late ScoreDisplay _coinDisplay;
  late HpDisplay _hpDisplay;
  late ComboDisplay _comboDisplay;
  late RunProgressDisplay _runProgressDisplay;

  int get score => _scoreDisplay.score;

  set score(int score) {
    _scoreDisplay.score = score;
    flashBackgroundSprite(_spriteBackgroundScore);
  }

  void enemyKilled() {
    _gameState.updateQuestProgress(QuestType.killEnemies, 1);
  }

  static const int _maxCombo = 20;
  int combo = 0;
  int _comboFrames = 0;

  /// Consecutive kills reward clean flying with up to double score. The timer
  /// gives the player four seconds to find the next target; getting hit or
  /// waiting too long resets the streak.
  double get comboMultiplier => 1.0 + combo * 0.05;

  void awardKillScore(int baseScore) {
    gainRiftCharge((12 * skillChargeMultiplier).round());
    combo = (combo + 1).clamp(0, _maxCombo).toInt();
    _comboFrames = 240;
    score += (baseScore * comboMultiplier).round();
    _comboDisplay
      ..combo = combo
      ..pulse();
  }

  void resetCombo() {
    combo = 0;
    _comboFrames = 0;
    _comboDisplay.combo = 0;
  }

  /// Rewards a clean graze once per short window and gives an active streak
  /// a little breathing room. Close calls add score without inflating kills.
  int? awardNearMiss() {
    if (shieldActive || _nearMissCooldownFrames > 0) return null;

    _nearMissCooldownFrames = 12;
    gainRiftCharge((4 * skillChargeMultiplier).round());
    final bonus = (25 * comboMultiplier).round();
    score += bonus;

    if (combo > 0) {
      _comboFrames = (_comboFrames + 45).clamp(0, 300).toInt();
      _comboDisplay.pulse();
    }
    return bonus;
  }

  int _nearMissCooldownFrames = 0;

  int get coins => _coinDisplay.score;
  int coinMultiplier = 1;

  void addCoin(Coin c) {
    // Animate coin to the top of the screen
    Offset startPos = convertPointFromNode(Offset.zero, c);
    Offset finalPos = const Offset(30.0, 30.0);
    Offset middlePos = Offset((startPos.dx + finalPos.dx) / 2.0 + 50.0,
        (startPos.dy + finalPos.dy) / 2.0);

    List<Offset> path = <Offset>[startPos, middlePos, finalPos];

    Sprite sprite = Sprite(texture: _sheetGame["coin.png"]!);
    sprite.scale = c.displayScale;
    sprite.colorOverlay = c.color;

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
      start: c.displayScale,
      end: c.displayScale + 0.5,
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
              _coinDisplay.score += c.value * coinMultiplier;
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

  /// Returns hull points lost after armour has absorbed incoming damage.
  /// Fractional damage carries forward, so reduction is deterministic.
  int takeShipDamage(double rawDamage) {
    if (rawDamage <= 0 || shieldActive) return 0;
    _armorQuietFrames = 0;
    _armorShieldFrames = 0;
    resetCombo();
    final resolvedDamage = CombatDamagePipeline.resolve(
      baseDamage: rawDamage,
      targetResistance: armorDamageReduction,
    );
    _damageRemainder += resolvedDamage.finalDamage;
    final lostHp = _damageRemainder.floor();
    if (lostHp == 0) return 0;
    _damageRemainder -= lostHp;
    hp = (hp - lostHp).clamp(0, maxHp);
    return lostHp;
  }

  double get equipmentDamageMultiplier =>
      _equipmentDamageMultiplier +
      (_equipmentStats.armorPassive == ArmorPassive.berserker &&
              hp <= maxHp * 0.30
          ? 0.35
          : 0.0);

  /// Boss rewards add damage; level-up modules multiply it for a distinct
  /// build choice in the current run.
  double get damageMultiplier =>
      (equipmentDamageMultiplier + _bossDamageBonus) * (1.0 + _runDamageBonus);

  double get runDamageBuffMultiplier =>
      (1.0 + _bossDamageBonus / equipmentDamageMultiplier) *
      (1.0 + _runDamageBonus);

  double _equipmentDamageMultiplier = 1.0;
  double speedMultiplier = 1.0;
  double armorDamageReduction = 0.0;
  double _damageRemainder = 0.0;
  EquipmentItem? droneEquipment;

  int runLevel = 1;
  int experience = 0;
  int experienceToNextLevel = 150;
  double runFireRateMultiplier = 1.0;
  double _bossDamageBonus = 0.0;
  double _bossFireRateBonus = 0.0;
  double _runDamageBonus = 0.0;
  double _runFireRateBonus = 0.0;
  double _runCriticalChance = 0.0;
  double _runMovementBonus = 0.0;
  int extraVolleyShots = 0;
  void Function(List<BossBuffReward> choices)? onBossBuff;
  void Function(int level, List<RunUpgradeReward> choices)? onRunLevelUp;
  int _pendingRunLevelUps = 0;
  List<RunUpgradeReward>? _activeRunUpgradeChoices;

  bool get hasRunUpgradeChoice => _activeRunUpgradeChoices != null;

  int _armorReactiveCooldownFrames = 0;
  int _armorQuietFrames = 0;
  int _armorShieldFrames = 0;
  int _droneShieldCooldownFrames = 900;
  int _droneShieldFrames = 0;

  bool tryBlockReactiveHit() {
    if (_equipmentStats.armorPassive != ArmorPassive.reactive ||
        _armorReactiveCooldownFrames > 0) {
      return false;
    }
    _armorReactiveCooldownFrames = 1200;
    hpInvincibilityFrames = math.max(hpInvincibilityFrames, 75).toInt();
    return true;
  }

  void gainExperience(int amount) {
    if (amount <= 0) return;
    experience += amount;
    while (experience >= experienceToNextLevel) {
      experience -= experienceToNextLevel;
      runLevel++;
      experienceToNextLevel = 150 + (runLevel - 1) * 55;
      _pendingRunLevelUps++;
    }
    _offerNextRunLevelUp();
  }

  List<RunUpgradeType> _eligibleRunUpgrades() {
    final upgrades = <RunUpgradeType>[];
    if (_runDamageBonus < 0.5) {
      upgrades.add(RunUpgradeType.weaponDamage);
    }
    if (_bossFireRateBonus + _runFireRateBonus < 0.60) {
      upgrades.add(RunUpgradeType.fireRate);
    }
    if (extraVolleyShots < 2) upgrades.add(RunUpgradeType.multishot);
    if (criticalChance < 0.5) upgrades.add(RunUpgradeType.critical);
    if (_runMovementBonus < 0.5) upgrades.add(RunUpgradeType.thrusters);
    if (maxHp < _equipmentStats.maxHp + 2) upgrades.add(RunUpgradeType.hull);
    if (hp < maxHp) upgrades.add(RunUpgradeType.repair);
    if (riftCharge < 100) upgrades.add(RunUpgradeType.riftCharge);
    upgrades.add(RunUpgradeType.shield);
    return upgrades;
  }

  void _offerNextRunLevelUp() {
    if (_activeRunUpgradeChoices != null || _pendingRunLevelUps <= 0) return;
    final eligible = _eligibleRunUpgrades()..shuffle();
    _activeRunUpgradeChoices = eligible
        .take(3)
        .map((type) => RunUpgradeReward(type))
        .toList(growable: false);
    _pendingRunLevelUps--;
    onRunLevelUp?.call(runLevel, _activeRunUpgradeChoices!);
  }

  /// Applies the chosen run-only module. Returns true when another queued
  /// level-up needs a choice before combat can resume.
  bool applyRunUpgrade(RunUpgradeReward reward) {
    final choices = _activeRunUpgradeChoices;
    if (choices == null || !choices.contains(reward)) {
      return hasRunUpgradeChoice;
    }

    switch (reward.type) {
      case RunUpgradeType.weaponDamage:
        _runDamageBonus = (_runDamageBonus + 0.10)
            .clamp(
              0.0,
              0.5,
            )
            .toDouble();
        break;
      case RunUpgradeType.fireRate:
        _runFireRateBonus = (_runFireRateBonus + 0.08)
            .clamp(
              0.0,
              (0.60 - _bossFireRateBonus).clamp(0.0, 0.60),
            )
            .toDouble();
        runFireRateMultiplier = 1.0 + _bossFireRateBonus + _runFireRateBonus;
        break;
      case RunUpgradeType.multishot:
        extraVolleyShots = (extraVolleyShots + 1).clamp(0, 2).toInt();
        break;
      case RunUpgradeType.critical:
        _runCriticalChance =
            (_runCriticalChance + 0.05).clamp(0.0, 0.5).toDouble();
        break;
      case RunUpgradeType.thrusters:
        _runMovementBonus =
            (_runMovementBonus + 0.10).clamp(0.0, 0.5).toDouble();
        break;
      case RunUpgradeType.hull:
        maxHp++;
        hp = (hp + 1).clamp(0, maxHp).toInt();
        break;
      case RunUpgradeType.repair:
        hp = (hp + 1).clamp(0, maxHp).toInt();
        break;
      case RunUpgradeType.riftCharge:
        gainRiftCharge(25);
        break;
      case RunUpgradeType.shield:
        _shieldFrames += 90;
        break;
    }

    _activeRunUpgradeChoices = null;
    _offerNextRunLevelUp();
    return hasRunUpgradeChoice;
  }

  /// Offers both damage and fire-rate paths; gold is a rarer power spike.
  void offerBossBuffChoices() {
    final random = math.Random();
    final choices = <BossBuffReward>[
      const BossBuffReward(BossBuffType.green, 5),
      const BossBuffReward(BossBuffType.purple, 5),
      random.nextInt(100) < 15
          ? const BossBuffReward(BossBuffType.gold, 10)
          : BossBuffReward(
              random.nextBool() ? BossBuffType.green : BossBuffType.purple,
              4,
            ),
    ];
    onBossBuff?.call(choices);
  }

  void applyBossBuff(BossBuffReward reward) {
    switch (reward.type) {
      case BossBuffType.green:
      case BossBuffType.gold:
        _bossDamageBonus = (_bossDamageBonus + reward.percent / 100)
            .clamp(0.0, GameBalance.maxRunDamageBonus)
            .toDouble();
        break;
      case BossBuffType.purple:
        _bossFireRateBonus = (_bossFireRateBonus + reward.percent / 100)
            .clamp(
              0.0,
              (GameBalance.maxRunFireRateBonus - _runFireRateBonus).clamp(
                0.0,
                GameBalance.maxRunFireRateBonus,
              ),
            )
            .toDouble();
        runFireRateMultiplier = 1.0 + _bossFireRateBonus + _runFireRateBonus;
        break;
    }
  }

  bool activateNuke = false;

  int _magnetFrames = 0;
  bool get magnetActive => _magnetFrames > 0;

  int _shieldFrames = 0;
  bool get shieldActive =>
      _shieldFrames > 0 ||
      _speedBoostFrames > 0 ||
      _armorShieldFrames > 0 ||
      _droneShieldFrames > 0 ||
      hpInvincibilityFrames > 0;
  int get activeShieldFrames => math
      .max(
        math.max(_shieldFrames, _speedBoostFrames),
        math.max(
          math.max(_armorShieldFrames, _droneShieldFrames),
          hpInvincibilityFrames,
        ),
      )
      .toInt();
  bool get shieldDeactivating =>
      math.max(
            math.max(_shieldFrames, _speedBoostFrames),
            math.max(_armorShieldFrames, _droneShieldFrames),
          ) >
          0 &&
      math.max(
            math.max(_shieldFrames, _speedBoostFrames),
            math.max(_armorShieldFrames, _droneShieldFrames),
          ) <
          60;

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
    if (_comboFrames > 0 && --_comboFrames == 0) resetCombo();
    if (_nearMissCooldownFrames > 0) _nearMissCooldownFrames--;
    _comboDisplay.combo = combo;
    _runProgressDisplay
      ..level = runLevel
      ..progress = experience / experienceToNextLevel;
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
    if (_ammoBuffFrames > 0) {
      _ammoBuffFrames--;
      if (_ammoBuffFrames == 0) {
        ammoDamageMultiplier = 1.0;
        projectileColor = Colors.white;
      }
    }
    if (_adPowerFrames > 0 && --_adPowerFrames == 0) {
      adDamageMultiplier = 1.0;
    }
    if (_magnetFrames > 0) {
      _magnetFrames--;
    }
    if (hpInvincibilityFrames > 0) {
      hpInvincibilityFrames--;
    }
    if (_armorReactiveCooldownFrames > 0) _armorReactiveCooldownFrames--;

    if (_equipmentStats.armorPassive == ArmorPassive.energyShield) {
      if (_armorShieldFrames > 0) {
        _armorShieldFrames--;
      } else if (++_armorQuietFrames >= 300) {
        _armorQuietFrames = 0;
        _armorShieldFrames = 90;
      }
    }

    if (droneEquipment?.droneRole == DroneRole.shield) {
      if (_droneShieldFrames > 0) {
        _droneShieldFrames--;
      } else if (--_droneShieldCooldownFrames <= 0) {
        _droneShieldFrames = 90;
        _droneShieldCooldownFrames = 900;
      }
    }

    _hpDisplay
      ..hp = hp
      ..maxHp = maxHp;
    _runProgressDisplay
      ..level = runLevel
      ..progress = experience / experienceToNextLevel;

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

/// Compact run-level and XP progress indicator above the gameplay lane.
class RunProgressDisplay extends Node {
  RunProgressDisplay(this._localizations) {
    _rebuildLabel();
  }

  final AppLocalizations _localizations;
  int _level = 1;
  double progress = 0.0;
  late TextPainter _label;

  set level(int value) {
    if (_level == value) return;
    _level = value;
    _rebuildLabel();
  }

  void _rebuildLabel() {
    _label = TextPainter(
      text: TextSpan(
        text: _localizations.runLevelShort(_level),
        style: const TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 7.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  void paint(Canvas canvas) {
    final plate = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 104.0, height: 18.0),
      const Radius.circular(6.0),
    );
    canvas.drawRRect(plate, Paint()..color = const Color(0xCC07182A));
    canvas.drawRRect(
      plate,
      Paint()
        ..color = const Color(0x6655E8FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    _label.paint(canvas, const Offset(-46.0, -3.5));

    final rail = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-10.0, -2.0, 54.0, 4.0),
      const Radius.circular(2.0),
    );
    canvas.drawRRect(rail, Paint()..color = const Color(0x663A5269));
    final fillWidth = 54.0 * progress.clamp(0.0, 1.0).toDouble();
    if (fillWidth > 0.0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-10.0, -2.0, fillWidth, 4.0),
          const Radius.circular(2.0),
        ),
        Paint()..color = const Color(0xFF55E8FF),
      );
    }
  }
}

/// Compact, animated streak indicator kept between the health and score HUD.
class ComboDisplay extends Node {
  ComboDisplay(this._localizations);

  final AppLocalizations _localizations;
  int _combo = 0;
  double _pulseAmount = 0.0;
  TextPainter? _count;
  TextPainter? _multiplier;

  int get combo => _combo;

  set combo(int value) {
    if (_combo == value) return;
    _combo = value;
    _rebuildLabels();
  }

  void pulse() => _pulseAmount = 1.0;

  void _rebuildLabels() {
    if (_combo <= 0) {
      _count = null;
      _multiplier = null;
      return;
    }

    final color =
        _combo >= 10 ? const Color(0xFFFFD166) : const Color(0xFF72F5FF);
    _count = TextPainter(
      text: TextSpan(
        text: _localizations.comboLabel(_combo),
        style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: color,
          shadows: [
            Shadow(color: color.withOpacity(0.75), blurRadius: 9.0),
            const Shadow(color: Colors.black, blurRadius: 3.0),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    _multiplier = TextPainter(
      text: TextSpan(
        text: _localizations
            .scoreMultiplier((1.0 + _combo * 0.05).toStringAsFixed(2)),
        style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 7.0,
          letterSpacing: 1.2,
          color: Colors.white.withOpacity(0.76),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  void update(double dt) {
    _pulseAmount = (_pulseAmount - dt * 3.5).clamp(0.0, 1.0).toDouble();
  }

  @override
  void paint(Canvas canvas) {
    final count = _count;
    final multiplier = _multiplier;
    if (count == null || multiplier == null) return;

    final scale = 1.0 + _pulseAmount * 0.18;
    canvas.save();
    canvas.scale(scale, scale);
    count.paint(canvas, Offset(-count.width / 2.0, -count.height / 2.0 - 2.0));
    multiplier.paint(
        canvas, Offset(-multiplier.width / 2.0, count.height / 2.0 - 1.0));
    canvas.restore();
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
  int _maxHp = 3;

  int get hp => _hp;

  set hp(int hp) {
    if (_hp != hp) {
      _hp = hp;
      _dirtyHp = true;
    }
  }

  set maxHp(int maxHp) {
    final safeMaxHp = maxHp.clamp(1, 12).toInt();
    if (_maxHp != safeMaxHp) {
      _maxHp = safeMaxHp;
      _dirtyHp = true;
    }
  }

  final SpriteSheet _sheetUI;
  bool _dirtyHp = true;

  @override
  void update(double dt) {
    if (_dirtyHp) {
      removeAllChildren();
      final hpColor = _hp == 1
          ? const Color(0xFFFF4545)
          : _hp == 2
              ? const Color(0xFFFFB300)
              : const Color(0xFF36E7FF);
      for (var index = 0; index < _maxHp; index++) {
        final filled = index < _hp;
        final hpSprite = Sprite(texture: _sheetUI["powerup_0.png"]!)
          ..position = Offset(index * 17.0, 0.0)
          ..colorOverlay = filled ? hpColor : const Color(0xFF64748B)
          ..opacity = filled ? 1.0 : 0.3
          ..scale = 0.3;
        addChild(hpSprite);
      }
      _dirtyHp = false;
    }
  }
}
