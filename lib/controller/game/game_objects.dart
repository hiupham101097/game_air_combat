import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';

abstract class GameObject extends Node {
  GameObject(this.f);

  double radius = 0.0;
  double removeLimit = 1280.0;
  bool canDamageShip = true;

  /// Contact damage. Enemy lasers override this with their attack strength.
  double shipDamage = 1.0;
  bool canBeDamaged = true;
  bool canBeCollected = false;
  // Only bosses opt into this. It keeps run-strength buffs tied strictly to
  // defeating a boss rather than normal enemy kills or XP milestones.
  bool grantsBossBuff = false;
  // Boss encounters clear all hostile projectiles the instant they end.
  bool clearsEnemyProjectilesOnDeath = false;
  bool isEnemyProjectile = false;
  // Leave this null for the normal health-based score calculation. Enemies
  // with a fixed reward (bosses and elite enemies) set a specific value.
  int? scoreReward;
  double maxDamage = 3000.0;
  // Accumulated damage received. Starting at zero is essential for maxDamage
  // to represent actual health rather than every target dying on the first hit.
  double damage = 0.0;

  final GameObjectFactory f;

  final Paint _paintDebug = Paint()
    ..color = const Color(0xffff0000)
    ..strokeWidth = 1.0
    ..style = ui.PaintingStyle.stroke;

  bool collidingWith(GameObject obj) {
    return (GameMath.distanceBetweenPoints(position, obj.position) <
        radius + obj.radius);
  }

  void move() {}

  void removeIfOffscreen(double scroll) {
    // The active boss is the level gate. It must remain in the scene until
    // the player defeats it, never disappear because of scroll cleanup.
    if (f.playerState.boss == this) return;
    if (-position.dy > scroll + removeLimit || -position.dy < scroll - 50.0) {
      removeFromParent();
    }
  }

  void destroy() {
    if (parent != null) {
      if (clearsEnemyProjectilesOnDeath) {
        f.clearEnemyProjectiles();
      }
      // Mini-bosses and full bosses both register here. Clearing the active
      // encounter lets the level resume after either one is defeated.
      if (f.playerState.boss == this) {
        f.playerState.boss = null;
      }
      Explosion? explo = createExplosion();
      if (explo != null) {
        explo.position = position;
        parent!.addChild(explo);
      }

      Collectable? powerUp = createPowerUp();
      if (powerUp != null) {
        f.addGameObject(powerUp, position);
      }

      removeFromParent();
    }
  }

  void collect() {
    removeFromParent();
  }

  void addDamage(double d) {
    if (!canBeDamaged) return;

    damage += d;
    if (damage >= maxDamage) {
      destroy();
      f.playerState.awardKillScore(scoreReward ?? (maxDamage * 10).ceil());
      f.playerState.enemyKilled();
      f.playerState.gainExperience((maxDamage / 10).ceil().clamp(1, 50));
      if (grantsBossBuff) {
        f.playerState.offerBossBuffChoices();
      }
    } else {
      f.sounds.playEffect("hit");
    }
  }

  Explosion? createExplosion() {
    return null;
  }

  Collectable? createPowerUp() {
    return null;
  }

  @override
  void paint(Canvas canvas) {
    if (drawDebug) {
      canvas.drawCircle(Offset.zero, radius, _paintDebug);
    }
    super.paint(canvas);
  }

  void setupActions() {}
}

Color colorForDamage(double damage, double maxDamage, [Color? toColor]) {
  int r, g, b;
  if (toColor == null) {
    r = 255;
    g = 30;
    b = 86;
  } else {
    r = toColor.red;
    g = toColor.green;
    b = toColor.blue;
  }

  int alpha = ((200.0 * damage) ~/ maxDamage).clamp(0, 200);
  return Color.fromARGB(alpha, r, g, b);
}

class Collectable extends GameObject {
  Collectable(GameObjectFactory f) : super(f) {
    canDamageShip = false;
    canBeDamaged = false;
    canBeCollected = true;

    zPosition = 20.0;
  }

  @override
  void move() {
    // The level stops scrolling while a boss is on screen. Collectables used
    // to rely entirely on that scroll, so coins and power-ups froze in place.
    // Offset the lost scroll here so their on-screen falling speed is stable.
    if (f.playerState.boss != null) {
      const normalScrollSpeed = 2.0;
      final lostScroll = normalScrollSpeed - f.playerState.scrollSpeed;
      if (lostScroll > 0) position += Offset(0.0, lostScroll);
    }
  }
}
