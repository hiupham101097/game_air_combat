import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/flash.dart';
import 'package:mini__game2/controller/game/game_laser.dart';
import 'package:mini__game2/controller/enemy/laser.dart';
import 'package:mini__game2/controller/game/game_level.dart';
import 'package:mini__game2/controller/game/game_level_label.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/controller/game/game_ship.dart';
import 'package:mini__game2/controller/game/player_drone.dart';
import 'package:mini__game2/model/equipment.dart';
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

class GameDemoNode extends NodeWithSize {
  GameDemoNode(this._images, this._spritesGame, this._spritesUI, this._sounds,
      this._gameState, this._isEventMode, this._gameOverCallback,
      {this.onBossBuff, this.onReviveOffer})
      : super(const Size(320.0, 320.0)) {
    // Add background - use fiery event background in Event Mode
    if (_isEventMode) {
      _background = RepeatedImage(_images["assets/event_bg.png"]!);
    } else {
      _background = RepeatedImage(_images["assets/starfield.png"]!);
    }
    addChild(_background);

    // Create starfield
    _starField = StarField(_spritesGame, 200);
    addChild(_starField);

    // Add nebula
    _nebula = RepeatedImage(_images["assets/nebula.png"]!, ui.BlendMode.plus);
    addChild(_nebula);

    // Setup game screen, it will always be anchored to the bottom of the screen
    _gameScreen = Node();
    addChild(_gameScreen);

    // Setup the level and add it to the screen, the level is the node where
    // all our game objects live. It is moved to scroll the game
    _level = Level();
    _gameScreen.addChild(_level);

    // Add heads up display
    _playerState = PlayerState(_spritesUI, _spritesGame, _gameState);
    _playerState.coinMultiplier = _isEventMode ? 2 : 1;
    _playerState.onBossBuff = onBossBuff;
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

  // Resources
  final ImageMap _images;
  final SoundAssets _sounds;
  final SpriteSheet _spritesGame;
  final SpriteSheet _spritesUI;

  // Callback
  final GameOverCallback _gameOverCallback;
  final BossBuffCallback? onBossBuff;
  final VoidCallback? onReviveOffer;

  void chooseBossBuff(BossBuffReward reward) {
    _playerState.applyBossBuff(reward);
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
  late PlayerState _playerState;

  // Game properties
  double _scroll = 0.0;

  int _framesToFire = 0;
  final int _framesBetweenShots = 20;

  bool _gameOver = false;
  bool _reviveUsed = false;
  bool _gameOverReported = false;
  final List<Node> _combatFrozenForRevive = <Node>[];

  @override
  void spriteBoxPerformedLayout() {
    gameSizeHeight = spriteBox!.visibleArea!.height;
    _gameScreen.position = Offset(0.0, gameSizeHeight);
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

  @override
  void update(double dt) {
    // A regular pause or popup freezes the entire simulation. During the
    // revival offer, only combat actors are frozen; fired projectiles keep
    // travelling naturally while the ship is destroyed.
    if (_isPaused || _gameOver) return;
    // Scroll the level
    _scroll = _level.scroll(_playerState.scrollSpeed);
    _starField.move(0.0, _playerState.scrollSpeed);

    _background.move(_playerState.scrollSpeed * 0.1);
    _nebula.move(_playerState.scrollSpeed);

    // Add objects
    addObjects();

    // Move the ship
    if (!_gameOver) {
      _level.ship.applyThrust(_joystick.value, _scroll);
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
      _framesToFire = (baseFrames /
              (_level.ship.fireRateMultiplier *
                  _playerState.runFireRateMultiplier))
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
        if (laser.collidingWith(damageable)) {
          // Hit something that can take damage
          damageable.addDamage(laser.impact);
          laser.destroy();
        }
      }
    }

    // Check for collsions between ship and objects that can damage the ship
    List<Node> nodes = List<Node>.from(_level.children);
    for (Node node in nodes) {
      if (node is GameObject && node.canDamageShip) {
        if (node.collidingWith(_level.ship)) {
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

    if (_isEventMode) {
      // ⚡ EVENT MODE: Boss Rush — faster and more intense
      if (part == 0) {
        LevelLabel lbl = LevelLabel(_objectFactory, displayedLevel);
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
        LevelLabel lbl = LevelLabel(_objectFactory, displayedLevel);
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

    if (currentWeapon == WeaponType.spread) {
      // Spread Gun
      for (double angle in [-110.0, -90.0, -70.0]) {
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
      // Homing Missiles
      Laser shot0 = HomingLaser(_objectFactory, laserLevel, -100.0);
      shot0.position = _level.ship.position + const Offset(17.0, -10.0);
      _level.addChild(shot0);

      Laser shot1 = HomingLaser(_objectFactory, laserLevel, -80.0);
      shot1.position = _level.ship.position + const Offset(-17.0, -10.0);
      _level.addChild(shot1);
    } else if (currentWeapon == WeaponType.plasma) {
      // Phoenix: twin heavy plasma cannons.
      for (final angle in [-96.0, -84.0]) {
        final shot = PlasmaLaser(_objectFactory, laserLevel, angle);
        shot.position =
            _level.ship.position + Offset(angle < -90.0 ? -14.0 : 14.0, -14.0);
        _level.addChild(shot);
      }
    } else if (currentWeapon == WeaponType.nova) {
      // Guardian: four broad Nova beams.
      for (final angle in [-112.0, -97.0, -83.0, -68.0]) {
        final shot = NovaLaser(_objectFactory, laserLevel, angle);
        shot.position =
            _level.ship.position + Offset(angle < -90.0 ? -12.0 : 12.0, -12.0);
        _level.addChild(shot);
      }
    } else {
      // Basic Laser
      Laser shot0 = Laser(_objectFactory, laserLevel, -90.0);
      shot0.position = _level.ship.position + const Offset(17.0, -10.0);
      _level.addChild(shot0);

      Laser shot1 = Laser(_objectFactory, laserLevel, -90.0);
      shot1.position = _level.ship.position + const Offset(-17.0, -10.0);
      _level.addChild(shot1);
    }

    if (_playerState.sideLaserActive) {
      Laser shot2 = Laser(_objectFactory, laserLevel, -108.0);
      shot2.position = _level.ship.position + const Offset(17.0, -10.0);
      _level.addChild(shot2);

      Laser shot3 = Laser(_objectFactory, laserLevel, -72.0);
      shot3.position = _level.ship.position + const Offset(-17.0, -10.0);
      _level.addChild(shot3);
    }

    for (var index = 0; index < _playerState.extraVolleyShots; index++) {
      final angle = -118.0 +
          (index * (56.0 / (_playerState.extraVolleyShots - 1).clamp(1, 99)));
      final shot = Laser(_objectFactory, laserLevel, angle);
      shot.position = _level.ship.position + const Offset(0.0, -8.0);
      _level.addChild(shot);
    }
  }

  void takeShipDamage(double rawDamage) {
    // Several projectiles can overlap in one frame. The first fatal hit owns
    // the game-over flow; later hits must not create extra end-run timers.
    if (_gameOver) return;
    final lostHp = _playerState.takeShipDamage(rawDamage);
    if (lostHp == 0) return;

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
