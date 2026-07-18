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
  bool canBeDamaged = true;
  bool canBeCollected = false;
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
    if (-position.dy > scroll + removeLimit || -position.dy < scroll - 50.0) {
      removeFromParent();
    }
  }

  void destroy() {
    if (parent != null) {
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
      f.playerState.score += (maxDamage * 10).ceil();
      f.playerState.enemyKilled();
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
}
