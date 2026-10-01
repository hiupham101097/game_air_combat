import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/flash.dart';
import 'package:mini__game2/controller/game/game_laser.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/game/game_level.dart';
import 'package:mini__game2/controller/game/game_level_label.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/rift_atmosphere.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/controller/game/game_ship.dart';
import 'package:mini__game2/controller/game/near_miss_effect.dart';
import 'package:mini__game2/controller/game/phase_shift_effect.dart';
import 'package:mini__game2/controller/game/player_drone.dart';
import 'package:mini__game2/l10n/generated/app_localizations.dart';
import 'package:mini__game2/model/equipment.dart';
import 'package:mini__game2/model/run_upgrade.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/controller/player_state.dart';
import 'package:mini__game2/controller/repeated_image.dart';
import 'package:mini__game2/controller/setting/sound_assets.dart';
import 'package:mini__game2/controller/star_field.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/weapon.dart';
import 'package:spritewidget/spritewidget.dart';

typedef GameOverCallback = void Function(
    int score, int coins, int levelReached);
typedef BossBuffCallback = void Function(List<BossBuffReward> choices);
typedef RunLevelUpCallback = void Function(
    int level, List<RunUpgradeReward> choices);

class GameDemoNode extends NodeWithSize {
  final math.Random _shakeRandom = math.Random();

  GameDemoNode(
      this._images,
      this._spritesGame,
      this._spritesUI,
      this._sounds,
      this._gameState,
      this._isEventMode,
      this._localizations,
      this._gameOverCallback,
      {this.onBossBuff,
      this.onRunLevelUp,
      this.onReviveOffer})
      : super(const Size(320.0, 320.0)) {
    // Both modes share the dimensional warfront; event mode changes the rift
    // color and encounter pace instead of switching to an unrelated art style.
    _background = RepeatedImage(_images["assets/space_warfield.png"]!);
    addChild(_background);

    // Create starfield
    _starField = StarField(_spritesGame, 200);
    addChild(_starField);

    // Add nebula
    _nebula = RepeatedImage(_images["assets/nebula.png"]!, ui.BlendMode.plus);
    _nebula.opacity = 0.2;
    addChild(_nebula);

    _riftAtmosphere = RiftAtmosphere(eventMode: _isEventMode);
    addChild(_riftAtmosphere);

    // Setup game screen, it will always be anchored to the bottom of the screen
    _gameScreen = Node();
    addChild(_gameScreen);

    // Setup the level and add it to the screen, the level is the node where
    // all our game objects live. It is moved to scroll the game
    _level = Level();
    _gameScreen.addChild(_level);

    // Add heads up display
    _playerState =
        PlayerState(_spritesUI, _spritesGame, _gameState, _localizations);
    _playerState.coinMultiplier = _isEventMode ? 2 : 1;
    _playerState.onBossBuff = (choices) {
      if (onBossBuff == null) return;
      _bossBuffChoicePending = true;
      onBossBuff!(choices);
    };
    _playerState.onRunLevelUp = _presentRunLevelUp;
    _playerState.position = const Offset(0.0, 20.0);
    addChild(_playerState);

    _objectFactory =
        GameObjectFactory(_spritesGame, _sounds, _level, _playerState);

    _level.ship = Ship(_objectFactory);
    _level.ship.setupActions();
    _level.addChild(_level.ship);

    // Keep the original virtual joystick controls.
    _joystick = VirtualJoystick();
    _gameScreen.addChild(_joystick);

    // Spawn drones if equipped
    if (_playerState.droneEquipment != null) {
      PlayerDrone droneLeft = PlayerDrone(_objectFactory,
          _playerState.droneEquipment!, _playerState.droneEquipmentLevel, true);
      droneLeft.position = const Offset(-50, 0);
      _level.addChild(droneLeft);

      // If rarity is epic or legendary, spawn a second drone on the right!
      if (_playerState.droneEquipment!.rarity == Rarity.epic ||
          _playerState.droneEquipment!.rarity == Rarity.legendary) {
        PlayerDrone droneRight = PlayerDrone(
            _objectFactory,
            _playerState.droneEquipment!,
            _playerState.droneEquipmentLevel,
            false);
        droneRight.position = const Offset(50, 0);
        _level.addChild(droneRight);
      }
    }

    // Add initial game objects
    addObjects();
  }

  final PersistantGameState _gameState;
  final bool _isEventMode;
  final AppLocalizations _localizations;

  // Resources
  final ImageMap _images;
  final SoundAssets _sounds;
  final SpriteSheet _spritesGame;
  final SpriteSheet _spritesUI;

  // Callback
  final GameOverCallback _gameOverCallback;
  final BossBuffCallback? onBossBuff;
  final RunLevelUpCallback? onRunLevelUp;
  final VoidCallback? onReviveOffer;

  bool _bossBuffChoicePending = false;
  int? _deferredRunUpgradeLevel;
  List<RunUpgradeReward>? _deferredRunUpgradeChoices;

  bool chooseBossBuff(BossBuffReward reward) {
    _playerState.applyBossBuff(reward);
    _bossBuffChoicePending = false;
    final deferredChoices = _deferredRunUpgradeChoices;
    final deferredLevel = _deferredRunUpgradeLevel;
    if (deferredChoices != null && deferredLevel != null) {
      _deferredRunUpgradeChoices = null;
      _deferredRunUpgradeLevel = null;
      onRunLevelUp?.call(deferredLevel, deferredChoices);
      return true;
    }
    return false;
  }

  bool chooseRunUpgrade(RunUpgradeReward reward) =>
      _playerState.applyRunUpgrade(reward);

  void _presentRunLevelUp(int level, List<RunUpgradeReward> choices) {
    if (_bossBuffChoicePending) {
      _deferredRunUpgradeLevel = level;
      _deferredRunUpgradeChoices = choices;
      return;
    }
    onRunLevelUp?.call(level, choices);
  }

  // Game screen nodes
  late Node _gameScreen;
  late VirtualJoystick _joystick;

  late GameObjectFactory _objectFactory;
  late Level _level;
  int _topLevelReached = 0;
  late StarField _starField;
  late RepeatedImage _background;
  late RepeatedImage _nebula;
  late RiftAtmosphere _riftAtmosphere;
  late PlayerState _playerState;

  // Game properties
  double _scroll = 0.0;

  int _framesToFire = 0;
  final int _framesBetweenShots = 20;

  bool _gameOver = false;
  bool _reviveUsed = false;
  bool _gameOverReported = false;
  final List<Node> _combatFrozenForRevive = <Node>[];
  double _screenShakeRemaining = 0.0;
  double _screenShakeDuration = 0.0;
  double _screenShakeStrength = 0.0;
  Offset _screenShakeOffset = Offset.zero;

  @override
  void spriteBoxPerformedLayout() {
    gameSizeHeight = spriteBox!.visibleArea!.height;
    _gameScreen.position = Offset(0.0, gameSizeHeight) + _screenShakeOffset;
  }

  bool _isPaused = false;

  void pause() {
    _isPaused = true;
    _setGameplayTreePaused(true);
  }

  void resume() {
    _setGameplayTreePaused(false);
    _isPaused = false;
  }

  /// SpriteWidget advances child updates and MotionControllers independently
  /// of this root node. Freeze both recursively so a UI popup cannot leave
  /// boss movement, bullets, timers, or animations running in the background.
  void _setGameplayTreePaused(bool value) {
    for (final child in children) {
      _setNodePaused(child, value);
    }
  }

  void _setNodePaused(Node node, bool value) {
    node.paused = value;
    node.motions.paused = value;
    for (final child in node.children) {
      _setNodePaused(child, value);
    }
  }

  bool get isPaused => _isPaused;

  ValueListenable<int> get riftChargeNotifier =>
      _playerState.riftChargeNotifier;
  final ValueNotifier<int> phaseShiftCooldownNotifier = ValueNotifier<int>(0);
  int _phaseShiftCooldownFrames = 0;
  int _phaseShiftMovementFrames = 0;
  double _phaseShiftHorizontalOffset = 0.0;

  ValueListenable<int> get phaseShiftCooldown => phaseShiftCooldownNotifier;

  bool activatePhaseShift() {
    if (_gameOver || _isPaused || _phaseShiftCooldownFrames > 0) return false;

    final ship = _level.ship;
    final start = ship.position;
    var direction = _joystick.value.dx.abs() > 0.15
        ? _joystick.value.dx.sign
        : (start.dx <= 0.0 ? 1.0 : -1.0);
    var targetX = (start.dx + direction * 82.0).clamp(-145.0, 145.0);
    if ((targetX - start.dx).abs() < 2.0) {
      direction = -direction;
      targetX = (start.dx + direction * 82.0).clamp(-145.0, 145.0);
    }
    final end = Offset(targetX.toDouble(), start.dy);
    final distance = (end.dx - start.dx).abs();
    if (distance < 2.0) return false;

    _phaseShiftHorizontalOffset = end.dx - start.dx;
    _phaseShiftMovementFrames = 24;
    _phaseShiftCooldownFrames = (360.0 *
            _playerState.combatStats.skillCooldownMultiplier.clamp(0.5, 2.0))
        .round();
    phaseShiftCooldownNotifier.value =
        (_phaseShiftCooldownFrames / 60.0).ceil();
    _playerState.hpInvincibilityFrames =
        math.max(_playerState.hpInvincibilityFrames, 36).toInt();

    final directionSign = end.dx >= start.dx ? 1.0 : -1.0;
    _level.addChild(PhaseShiftTrail(
      direction: directionSign,
      distance: distance,
    )..position = Offset((start.dx + end.dx) / 2.0, start.dy));
    _level.addChild(PhaseShiftPulse()..position = end);

    // The phase blade erases projectiles along its lane and clips nearby
    // invaders, giving the dodge a clear offensive reward.
    final targets = List<Node>.from(_level.children);
    for (final node in targets) {
      if (node is! GameObject || node.parent == null) continue;
      final closestX = node.position.dx
          .clamp(math.min(start.dx, end.dx), math.max(start.dx, end.dx))
          .toDouble();
      final distanceToLane =
          (node.position - Offset(closestX, start.dy)).distance;
      if (distanceToLane > node.radius + 12.0) continue;

      if (node is EnemyLaser) {
        node.destroy();
      } else if (node.canBeDamaged &&
          node.canDamageShip &&
          !node.isEnemyProjectile &&
          !node.grantsBossBuff) {
        final damage = node.maxDamage *
            (0.3 * _playerState.combatStats.damageMultiplier)
                .clamp(0.1, 0.65)
                .toDouble();
        node.addDamage(damage);
        if (node.parent != null) {
          _level.addChild(DamageNumberEffect(damage, critical: false)
            ..position = node.position);
        }
      }
    }
    _sounds.playEffect('laser');
    return true;
  }

  bool activateRiftBurst() {
    if (_gameOver || _isPaused || !_playerState.spendRiftCharge()) return false;

    _objectFactory.clearEnemyProjectiles();
    _playerState.hpInvincibilityFrames =
        math.max(_playerState.hpInvincibilityFrames, 75).toInt();
    _sounds.playEffect('explosion_boss');
    addChild(Flash(size, 0.55));

    final targets = List<Node>.from(_level.children);
    for (final node in targets) {
      if (node is GameObject &&
          node.canBeDamaged &&
          node.canDamageShip &&
          !node.isEnemyProjectile &&
          !node.grantsBossBuff) {
        node.addDamage(node.maxDamage * 0.30);
      }
    }
    return true;
  }

  @override
  void update(double dt) {
    // A regular pause or popup freezes the entire simulation. During the
    // revival offer, only combat actors are frozen; fired projectiles keep
    // travelling naturally while the ship is destroyed.
    if (!_isPaused) _advanceScreenShake(dt);
    if (_isPaused || _gameOver) return;
    // Scroll the level
    _scroll = _level.scroll(_playerState.scrollSpeed);
    _starField.move(0.0, _playerState.scrollSpeed);

    _background.move(_playerState.scrollSpeed * 0.1);
    _nebula.move(_playerState.scrollSpeed);
    _riftAtmosphere.advance(dt, _playerState.scrollSpeed);

    if (_phaseShiftCooldownFrames > 0) {
      _phaseShiftCooldownFrames--;
      final secondsLeft = (_phaseShiftCooldownFrames / 60.0).ceil();
      if (phaseShiftCooldownNotifier.value != secondsLeft) {
        phaseShiftCooldownNotifier.value = secondsLeft;
      }
    }
    if (_phaseShiftMovementFrames > 0) {
      _phaseShiftMovementFrames--;
    } else {
      _phaseShiftHorizontalOffset = 0.0;
    }

    // Add objects
    addObjects();

    // Move the ship
    if (!_gameOver) {
      _level.ship.applyThrust(_joystick.value, _scroll,
          horizontalOffset: _phaseShiftHorizontalOffset);
    }

    // Add shots
    if (_framesToFire == 0 && _joystick.isDown && !_gameOver) {
      fire();
      int baseFrames = (_playerState.speedLaserActive)
          ? _framesBetweenShots ~/ 2
          : _framesBetweenShots;
      if (_playerState.currentWeapon == WeaponType.rapid) {
        baseFrames = (baseFrames * 0.45).round();
      }
      _framesToFire = (baseFrames / _playerState.combatStats.fireRateMultiplier)
          .round()
          .clamp(1, baseFrames);
    }

    if (_framesToFire > 0) _framesToFire--;

    // Move game objects
    for (Node node in _level.children) {
      if (node is GameObject) {
        node.move();
      }
    }

    // Remove offscreen game objects
    for (int i = _level.children.length - 1; i >= 0; i--) {
      Node node = _level.children[i];
      if (node is GameObject && node is! Ship) {
        node.removeIfOffscreen(_scroll);
      }
    }

    // Nuke Logic
    if (_playerState.activateNuke) {
      _playerState.activateNuke = false;
      _sounds.playEffect("explosion_boss");
      Flash flash = Flash(size, 1.0);
      addChild(flash);

      List<Node> nukeTargets = List<Node>.from(_level.children);
      for (Node node in nukeTargets) {
        if (node is GameObject &&
            node.canBeDamaged &&
            node.canDamageShip && // Only kill enemies (not power ups)
            !node.grantsBossBuff) {
          node.addDamage(node.maxDamage);
        }
      }
    }

    // Magnet Logic
    if (_playerState.magnetActive) {
      List<Node> collectables = List<Node>.from(_level.children);
      for (Node node in collectables) {
        if (node is GameObject && node.canBeCollected) {
          Offset dir = _level.ship.position - node.position;
          double dist = dir.distance;
          if (dist > 1.0 && dist < 300.0) {
            // Avoid div-by-zero when dist==0
            node.position += (dir / dist) * 8.0;
          }
        }
      }
    }

    // Check for collisions between lasers and objects that can take damage
    List<Laser> lasers = <Laser>[];
    for (Node node in _level.children) {
      if (node is Laser) lasers.add(node);
    }

    List<GameObject> damageables = <GameObject>[];
    for (Node node in _level.children) {
      if (node is GameObject && node.canBeDamaged) damageables.add(node);
    }

    for (Laser laser in lasers) {
      for (GameObject damageable in damageables) {
        if (damageable.parent == null ||
            laser.hasHitTarget(damageable) ||
            !laser.collidingWith(damageable)) {
          continue;
        }

        _applyDamageFromLaser(laser, damageable);
        if (laser.explosionRadius > 0.0) {
          for (final nearby in damageables) {
            if (nearby == damageable || nearby.parent == null) continue;
            if ((nearby.position - damageable.position).distance <=
                laser.explosionRadius + nearby.radius) {
              _applyDamageFromLaser(laser, nearby, scale: 0.35);
            }
          }
        }

        if (!laser.registerTargetHit(damageable)) {
          laser.destroy();
          break;
        }
      }
    }

    // Check for collsions between ship and objects that can damage the ship
    List<Node> nodes = List<Node>.from(_level.children);
    for (Node node in nodes) {
      if (node is GameObject && node.canDamageShip) {
        final distance = (node.position - _level.ship.position).distance;
        final contactDistance = node.radius + _level.ship.radius;

        // Reward a projectile only after it has passed the ship. The brief
        // cooldown prevents dense patterns from flooding the score and HUD.
        if (node is EnemyLaser &&
            !node.nearMissAwarded &&
            !_playerState.shieldActive &&
            distance > contactDistance &&
            distance <= contactDistance + 18.0 &&
            node.isMovingAwayFrom(_level.ship.position)) {
          final bonus = _playerState.awardNearMiss();
          if (bonus != null) {
            node.nearMissAwarded = true;
            _level.addChild(NearMissEffect(_localizations.nearMissBonus(bonus))
              ..position = node.position);
          }
        }

        if (distance < contactDistance) {
          if (_playerState.shieldActive) {
            // Hit, but saved by the shield! Only destroy non-boss enemies
            if (!node.grantsBossBuff) {
              node.destroy();
            }
          } else {
            // Armour reduces the incoming attack value before it reaches hull.
            takeShipDamage(node.shipDamage);
            if (node is EnemyLaser) node.destroy();
          }
        }
      } else if (node is GameObject && node.canBeCollected) {
        if (node.collidingWith(_level.ship)) {
          // The ship ran over something collectable
          node.collect();
        }
      }
    }
  }

  void _startScreenShake(double strength, double duration) {
    if (strength >= _screenShakeStrength || _screenShakeRemaining <= 0.0) {
      _screenShakeStrength = strength;
    }
    _screenShakeDuration = math.max(_screenShakeDuration, duration).toDouble();
    _screenShakeRemaining = math.max(_screenShakeRemaining, duration);
  }

  void _advanceScreenShake(double dt) {
    if (_screenShakeRemaining <= 0.0) {
      _screenShakeStrength = 0.0;
      _screenShakeOffset = Offset.zero;
      _gameScreen.position = Offset(0.0, gameSizeHeight);
      return;
    }

    _screenShakeRemaining =
        math.max(0.0, _screenShakeRemaining - dt).toDouble();
    final fade = _screenShakeDuration <= 0.0
        ? 0.0
        : _screenShakeRemaining / _screenShakeDuration;
    _screenShakeOffset = Offset(
      (_shakeRandom.nextDouble() * 2.0 - 1.0) * _screenShakeStrength * fade,
      (_shakeRandom.nextDouble() * 2.0 - 1.0) * _screenShakeStrength * fade,
    );
    _gameScreen.position = Offset(0.0, gameSizeHeight) + _screenShakeOffset;
  }

  void _applyDamageFromLaser(Laser laser, GameObject target,
      {double scale = 1.0}) {
    final damage = laser.damageForHit(
      targetResistance: target.damageResistance,
      scale: scale,
    );
    target.addDamage(damage);
    _level.addChild(
      DamageNumberEffect(damage, critical: laser.lastHitWasCritical)
        ..position = target.position,
    );
    if (laser.lastHitWasCritical) {
      _startScreenShake(1.5, 0.08);
      _level.addChild(
        NearMissEffect(_localizations.criticalHit,
            accentColor: Colors.amberAccent)
          ..position = target.position + const Offset(0.0, -12.0),
      );
    }
  }

  int _chunk = 0;

  void addObjects() {
    while (_scroll + chunkSpacing >= _chunk * chunkSpacing) {
      addLevelChunk(_chunk, -_chunk * chunkSpacing - chunkSpacing);

      _chunk += 1;
    }
  }

  void addLevelChunk(int chunk, double yPos) {
    int level = chunk ~/ chunksPerLevel + _gameState.currentStartingLevel;
    int part = chunk % chunksPerLevel;
    final displayedLevel = level + 1;
    _riftAtmosphere.setSector((level ~/ 3).clamp(0, 3).toInt());

    if (_isEventMode) {
      // ⚡ EVENT MODE: Boss Rush — faster and more intense
      if (part == 0) {
        LevelLabel lbl =
            LevelLabel(_objectFactory, displayedLevel, _localizations);
        lbl.position = Offset(0.0, yPos + chunkSpacing / 2.0 - 150.0);
        _topLevelReached = level;
        _level.addChild(lbl);
      } else if (part == 1) {
        _objectFactory.addEnemyDestroyerSwarm(level + 6, yPos);
      } else if (part == 2) {
        _objectFactory.addEnemyScoutSwarm(level + 6, yPos);
        _objectFactory.addAsteroids(level + 5, yPos);
      } else if (part == 3) {
        // EVENT: Mini boss wave
        _objectFactory.addBossFight(level + 6, yPos);
      } else if (part == 4) {
        _objectFactory.addEnemyDestroyerSwarm(level + 7, yPos);
        _objectFactory.addEnemyScoutSwarm(level + 5, yPos);
        _objectFactory.addEliteEnemyWave(level + 5, yPos);
      } else if (part == 5) {
        _objectFactory.addAsteroids(level + 6, yPos);
        _objectFactory.addEnemyScoutSwarm(level + 6, yPos);
      } else if (part == 6) {
        _objectFactory.addEnemyDestroyerSwarm(level + 7, yPos);
        _objectFactory.addEliteEnemyWave(level + 6, yPos);
      } else if (part == 7) {
        // EVENT: Double everything
        _objectFactory.addAsteroids(level + 7, yPos);
        _objectFactory.addEnemyDestroyerSwarm(level + 7, yPos);
        _objectFactory.addEnemyScoutSwarm(level + 5, yPos);
      } else if (part == 8) {
        // EVENT: High-level Boss every single loop
        _objectFactory.addBossFight(level + 10, yPos);
      }
    } else {
      // Normal Mode
      if (part == 0) {
        LevelLabel lbl =
            LevelLabel(_objectFactory, displayedLevel, _localizations);
        lbl.position = Offset(0.0, yPos + chunkSpacing / 2.0 - 150.0);
        _topLevelReached = level;
        _level.addChild(lbl);
      } else if (part == 1) {
        _objectFactory.addAsteroids(level, yPos);
      } else if (part == 2) {
        _objectFactory.addEnemyScoutSwarm(level, yPos);
        if (level >= 2) {
          _objectFactory.addEliteEnemyWave(level, yPos);
        }
      } else if (part == 3) {
        // Recovery beat: a light hazard group, never a stacked wave.
        _objectFactory.addAsteroids(level ~/ 2, yPos);
      } else if (part == 4) {
        _objectFactory.addEnemyDestroyerSwarm(level, yPos);
      } else if (part == 5) {
        _objectFactory.addAsteroids(level, yPos);
      } else if (part == 6) {
        _objectFactory.addEnemyScoutSwarm(level, yPos);
        if (level >= 6) {
          _objectFactory.addEliteEnemyWave(level, yPos);
        }
      } else if (part == 7) {
        _objectFactory.addAsteroids(level, yPos);
        if (level >= 5) {
          _objectFactory.addEnemyScoutSwarm(level - 2, yPos);
        }
      } else if (part == 8) {
        // Every level ends with a mini-boss. Each tenth level upgrades that
        // encounter to a full boss.
        if (displayedLevel % 10 == 0) {
          _objectFactory.addBossFight(displayedLevel, yPos);
        } else {
          _objectFactory.addMiniBossFight(displayedLevel, yPos);
        }
      }
    }
  }

  void fire() {
    int laserLevel = _objectFactory.playerState.laserLevel;
    WeaponType currentWeapon = _playerState.currentWeapon;
    final weaponProfile = WeaponConfig.weapons[currentWeapon]!;
    final weaponAngles = _fanAngles(weaponProfile);

    if (currentWeapon == WeaponType.spread) {
      for (final angle in weaponAngles) {
        Laser shot = Laser(_objectFactory, laserLevel, angle);
        shot.position = _level.ship.position + const Offset(0, -10.0);
        _level.addChild(shot);
      }
    } else if (currentWeapon == WeaponType.piercing) {
      // Piercing Beam
      Laser shot = PiercingLaser(_objectFactory, laserLevel, -90.0);
      shot.position = _level.ship.position + const Offset(0, -10.0);
      _level.addChild(shot);
    } else if (currentWeapon == WeaponType.homing) {
      for (final angle in weaponAngles) {
        final side = angle < -90.0 ? -17.0 : 17.0;
        final shot = HomingLaser(_objectFactory, laserLevel, angle)
          ..position = _level.ship.position + Offset(side, -10.0);
        _level.addChild(shot);
      }
    } else if (currentWeapon == WeaponType.plasma) {
      for (final angle in weaponAngles) {
        final shot = PlasmaLaser(_objectFactory, laserLevel, angle);
        shot.position =
            _level.ship.position + Offset(angle < -90.0 ? -14.0 : 14.0, -14.0);
        _level.addChild(shot);
      }
    } else if (currentWeapon == WeaponType.nova) {
      for (final angle in weaponAngles) {
        final shot = NovaLaser(_objectFactory, laserLevel, angle);
        shot.position =
            _level.ship.position + Offset(angle < -90.0 ? -12.0 : 12.0, -12.0);
        _level.addChild(shot);
      }
    } else if (currentWeapon == WeaponType.phase) {
      final shot = PhaseLanceLaser(_objectFactory, laserLevel, -90.0);
      shot.position = _level.ship.position + const Offset(0.0, -14.0);
      _level.addChild(shot);
    } else if (currentWeapon == WeaponType.arc) {
      for (final angle in weaponAngles) {
        final shot = RiftArcLaser(_objectFactory, laserLevel, angle);
        shot.position = _level.ship.position +
            Offset(
                angle < -90.0
                    ? -12.0
                    : angle > -90.0
                        ? 12.0
                        : 0.0,
                -12.0);
        _level.addChild(shot);
      }
    } else if (currentWeapon == WeaponType.flak) {
      for (final angle in weaponAngles) {
        final shot = FlakLaser(_objectFactory, laserLevel, angle);
        shot.position = _level.ship.position +
            Offset(
                angle < -90.0
                    ? -14.0
                    : angle > -90.0
                        ? 14.0
                        : 0.0,
                -12.0);
        _level.addChild(shot);
      }
    } else {
      for (var index = 0; index < weaponAngles.length; index++) {
        final side = index.isEven ? -17.0 : 17.0;
        final shot = Laser(_objectFactory, laserLevel, weaponAngles[index])
          ..position = _level.ship.position + Offset(side, -10.0);
        _level.addChild(shot);
      }
    }

    if (_playerState.sideLaserActive) {
      Laser shot2 = Laser(_objectFactory, laserLevel, -108.0);
      shot2.position = _level.ship.position + const Offset(17.0, -10.0);
      _level.addChild(shot2);

      Laser shot3 = Laser(_objectFactory, laserLevel, -72.0);
      shot3.position = _level.ship.position + const Offset(-17.0, -10.0);
      _level.addChild(shot3);
    }

    final extraShotCount = _playerState.extraVolleyShots;
    final extraShotStep =
        extraShotCount <= 1 ? 0.0 : 56.0 / (extraShotCount - 1);
    for (var index = 0; index < extraShotCount; index++) {
      final angle =
          extraShotCount == 1 ? -90.0 : -118.0 + index * extraShotStep;
      final shot = Laser(_objectFactory, laserLevel, angle);
      shot.position = _level.ship.position + const Offset(0.0, -8.0);
      _level.addChild(shot);
    }
  }

  List<double> _fanAngles(Weapon weapon) {
    final count = weapon.projectileCount.clamp(1, 16).toInt();
    if (count == 1 || weapon.spreadDegrees <= 0) {
      return List<double>.filled(count, -90.0, growable: false);
    }
    final start = -90.0 - weapon.spreadDegrees / 2.0;
    final step = weapon.spreadDegrees / (count - 1);
    return List<double>.generate(count, (index) => start + step * index,
        growable: false);
  }

  void takeShipDamage(double rawDamage) {
    // Several projectiles can overlap in one frame. The first fatal hit owns
    // the game-over flow; later hits must not create extra end-run timers.
    if (_gameOver) return;
    if (_playerState.tryBlockReactiveHit()) {
      _startScreenShake(2.5, 0.10);
      _sounds.playEffect("pickup_powerup");
      final blockEffect = ExplosionMini(_spritesGame)
        ..position = _level.ship.position;
      _level.addChild(blockEffect);
      return;
    }
    final lostHp = _playerState.takeShipDamage(rawDamage);
    if (lostHp == 0) return;

    _startScreenShake(5.0, 0.16);
    _playerState.hpInvincibilityFrames = 75;
    _sounds.playEffect("explosion_player");

    if (_playerState.hp > 0) {
      final explo = ExplosionBig(_spritesGame)
        ..scale = 0.5
        ..position = _level.ship.position;
      _level.addChild(explo);
      return;
    }

    // Hide ship
    _level.ship.visible = false;

    // Add explosion
    ExplosionBig explo = ExplosionBig(_spritesGame);
    explo.scale = 1.5;
    explo.position = _level.ship.position;
    _level.addChild(explo);

    // Add flash
    Flash flash = Flash(size, 1.0);
    addChild(flash);

    // Set the state to game over
    _gameOver = true;
    _freezeCombatForRevive();

    // Offer one optional rewarded revival before ending the run.
    Timer(const Duration(seconds: 2), () {
      if (!_reviveUsed && onReviveOffer != null) {
        onReviveOffer!();
      } else {
        endRun();
      }
    });
  }

  void reviveFromRewardedAd() {
    if (!_gameOver || _reviveUsed) return;
    _reviveUsed = true;
    _gameOver = false;
    _playerState.hp =
        (_playerState.maxHp * 0.5).ceil().clamp(1, _playerState.maxHp);
    _playerState.hpInvincibilityFrames = 180;
    _level.ship.visible = true;
    _resumeCombatAfterRevive();
  }

  /// Stops every enemy from moving or firing after the ship explodes, but
  /// deliberately leaves existing enemy projectiles active so they finish
  /// their trajectory instead of freezing above the player.
  void _freezeCombatForRevive() {
    _combatFrozenForRevive.clear();
    for (final node in _level.children) {
      if (node is GameObject && node.canDamageShip && !node.isEnemyProjectile) {
        node.paused = true;
        node.motions.paused = true;
        _combatFrozenForRevive.add(node);
      }
    }
  }

  void _resumeCombatAfterRevive() {
    for (final node in _combatFrozenForRevive) {
      if (node.parent != null) {
        node.paused = false;
        node.motions.paused = false;
      }
    }
    _combatFrozenForRevive.clear();
  }

  int grantRewardedAdPowerBoost() => _playerState.activateAdPowerBoost();

  void endRun() {
    if (_gameOverReported) return;
    _gameOverReported = true;
    _gameOverCallback(_playerState.score, _playerState.coins, _topLevelReached);
  }
}

// class Level extends Node {
//   Level() {
//     position = const Offset(160.0, 0.0);
//   }

//   late Ship ship;

//   double scroll(double scrollSpeed) {
//     position += Offset(0.0, scrollSpeed);
//     return position.dy;
//   }
// }
