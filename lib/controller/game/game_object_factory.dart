// ignore_for_file: unused_element

import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mini__game2/controller/asteroid/big.dart';
import 'package:mini__game2/controller/asteroid/power.dart';
import 'package:mini__game2/controller/asteroid/small.dart';
import 'package:mini__game2/controller/enemy/boss.dart';
import 'package:mini__game2/controller/enemy/boss_laser.dart';
import 'package:mini__game2/controller/enemy/boss_carrier.dart';
import 'package:mini__game2/controller/enemy/boss_extended.dart';
import 'package:mini__game2/controller/enemy/destroyer.dart';
import 'package:mini__game2/controller/enemy/elite_enemy.dart';
import 'package:mini__game2/controller/enemy/scout.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
// import 'package:mini__game2/controller/game/game_demo_node.dart';
import 'package:mini__game2/controller/game/game_level.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/controller/player_state.dart';
import 'package:mini__game2/controller/setting/set__color.dart';
import 'package:mini__game2/controller/setting/sound_assets.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';

class GameObjectFactory {
  GameObjectFactory(this.sheet, this.sounds, this.level, this.playerState);

  SpriteSheet sheet;
  SoundAssets sounds;
  Level level;
  PlayerState playerState;

  void addAsteroids(int level, double yPos) {
    final int numAsteroids = (10 + level * 5).clamp(10, 42);
    final double distribution = (0.20 + level * 0.07).clamp(0.20, 0.78);

    for (int i = 0; i < numAsteroids; i++) {
      GameObject obj;
      if (i == 0) {
        obj = AsteroidPowerUp(this, level);
      } else if (randomDouble() < distribution) {
        obj = AsteroidBig(this, level);
      } else {
        obj = AsteroidSmall(this, level);
      }

      Offset pos = Offset(
          randomSignedDouble() * 160.0, yPos + chunkSpacing * randomDouble());
      addGameObject(obj, pos);
    }
  }

  void addEnemyScoutSwarm(int level, double yPos) {
    final int numEnemies = (4 + level * 3).clamp(4, 18);
    late List<int> types;
    int swarmLevel = level % maxLevel;

    if (swarmLevel == 0) {
      types = [0, 0, 0];
    } else if (swarmLevel == 1) {
      types = [0, 1, 0];
    } else if (swarmLevel == 2) {
      types = [1, 0, 1];
    } else if (swarmLevel == 3) {
      types = [1, 1, 1];
    } else if (swarmLevel == 4) {
      types = [0, 1, 2];
    } else if (swarmLevel == 5) {
      types = [1, 2, 1];
    } else if (swarmLevel == 6) {
      types = [2, 1, 2];
    } else if (swarmLevel == 7) {
      types = [2, 1, 2];
    } else if (swarmLevel == 8) {
      types = [2, 2, 2];
    }

    for (int i = 0; i < numEnemies; i++) {
      final int type = types[(i + level) % types.length];
      double spacing = math.max(chunkSpacing / (numEnemies + 1.0), 80.0);
      double y = yPos +
          chunkSpacing / 2.0 -
          (numEnemies - 1) * spacing / 2.0 +
          i * spacing;
      final double formationWidth = (level * 12.0).clamp(25.0, 135.0);
      addGameObject(EnemyScout(this, type, level),
          Offset(randomSignedDouble() * formationWidth, y));
    }
  }

  void addEnemyDestroyerSwarm(int level, double yPos) {
    final int numEnemies = (2 + level * 2).clamp(2, 12);
    late List<int> types;
    int swarmLevel = level % maxLevel;

    if (swarmLevel == 0) {
      types = [0, 0, 0];
    } else if (swarmLevel == 1) {
      types = [0, 1, 0];
    } else if (swarmLevel == 2) {
      types = [1, 0, 1];
    } else if (swarmLevel == 3) {
      types = [1, 1, 1];
    } else if (swarmLevel == 4) {
      types = [0, 1, 2];
    } else if (swarmLevel == 5) {
      types = [1, 2, 1];
    } else if (swarmLevel == 6) {
      types = [2, 1, 2];
    } else if (swarmLevel == 7) {
      types = [2, 1, 2];
    } else if (swarmLevel == 8) {
      types = [2, 2, 2];
    }

    for (int i = 0; i < numEnemies; i++) {
      final int type = types[(i + level) % types.length];
      addGameObject(
          EnemyDestroyer(this, type, level),
          Offset(randomSignedDouble() * 120.0,
              yPos + chunkSpacing * randomDouble()));
    }
  }

  void addEliteEnemyWave(int level, double yPos) {
    final unlockedTypes = (level - 1).clamp(1, EliteEnemyType.values.length);
    final count = level >= 7 ? 2 : 1;
    for (var index = 0; index < count; index++) {
      final typeIndex = ((level - 2) + index * 3) % unlockedTypes;
      final enemy = EliteEnemy(this, EliteEnemyType.values[typeIndex], level);
      addGameObject(
        enemy,
        Offset(randomSignedDouble() * 105.0,
            yPos + chunkSpacing * (0.25 + randomDouble() * 0.5)),
      );
    }
  }

  void addGameObject(GameObject obj, Offset pos) {
    obj.position = pos;
    obj.setupActions();

    level.addChild(obj);
  }

  void addBossFight(int level, double yPos) {
    Obstacle boss;
    int bossType = level % 8; // Rotate through 8 boss types

    switch (bossType) {
      case 0:
        boss = EnemyBoss(this, level);
        break;
      case 1:
        boss = BossLaser(this, level);
        break;
      case 2:
        boss = BossCarrier(this, level);
        break;
      case 3:
        boss = BossNova(this, level);
        break;
      case 4:
        boss = BossPhantom(this, level);
        break;
      case 5:
        boss = BossTitan(this, level);
        break;
      case 6:
        boss = BossVenom(this, level);
        break;
      default:
        boss = BossColossus(this, level);
    }

    Offset pos = Offset(0.0, yPos + chunkSpacing / 2.0);
    addGameObject(boss, pos);
    playerState.boss = boss;

    int destroyerLevel = (level - 1 ~/ 3).clamp(0, 2);

    // Add boss's helpers
    if (level >= 1) {
      EnemyDestroyer destroyer0 = EnemyDestroyer(this, destroyerLevel, level);
      addGameObject(
          destroyer0, Offset(-80.0, yPos + chunkSpacing / 2.0 + 70.0));

      EnemyDestroyer destroyer1 = EnemyDestroyer(this, destroyerLevel, level);
      addGameObject(destroyer1, Offset(80.0, yPos + chunkSpacing / 2.0 + 70.0));

      if (level >= 2) {
        EnemyDestroyer destroyer0 = EnemyDestroyer(this, destroyerLevel, level);
        addGameObject(
            destroyer0, Offset(-80.0, yPos + chunkSpacing / 2.0 - 70.0));

        EnemyDestroyer destroyer1 = EnemyDestroyer(this, destroyerLevel, level);
        addGameObject(
            destroyer1, Offset(80.0, yPos + chunkSpacing / 2.0 - 70.0));
      }
    }
  }
}

void addLaserSprites(Node node, int level, double r, SpriteSheet sheet) {
  int numLasers = level % 3 + 1;
  Color laserColor = AppStyle.colors[(level ~/ 3) % AppStyle.colors.length];

  // Add sprites
  List<Sprite> sprites = <Sprite>[];
  for (int i = 0; i < numLasers; i++) {
    Sprite sprite = Sprite(texture: sheet["explosion_particle.png"]!);
    sprite.scale = 0.5;
    sprite.colorOverlay = laserColor;
    sprite.blendMode = ui.BlendMode.plus;
    node.addChild(sprite);
    sprites.add(sprite);
  }

  // Position the individual sprites
  if (numLasers == 2) {
    sprites[0].position = const Offset(-3.0, 0.0);
    sprites[1].position = const Offset(3.0, 0.0);
  } else if (numLasers == 3) {
    sprites[0].position = const Offset(-4.0, 0.0);
    sprites[1].position = const Offset(4.0, 0.0);
    sprites[2].position = const Offset(0.0, -2.0);
  }
}
