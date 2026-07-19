import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart';

var _gameSizeHeight = 320.0;

class Laser extends GameObject {
  double impact = 0.0;

  Laser(GameObjectFactory f, int level, double r) : super(f) {
    radius = 10.0; //Phạm vi đạn gây sát thương
    removeLimit = _gameSizeHeight * 5 + radius; //Tăng chiều dài đạn bắn ra
    canDamageShip = false;
    canBeDamaged = false;
    impact = (1.0 + level * 0.5) *
        f.playerState.damageMultiplier *
        f.playerState.weaponDamageMultiplier *
        f.playerState.ammoDamageMultiplier;

    // Tăng tốc độ lase bắn
    _offset = Offset(math.cos(radians(r)) * 8.0,
        math.sin(radians(r)) * 8.0 - f.playerState.scrollSpeed);

    // tăng kích thước đạn
    rotation = r + 90.0;

    addLaserSprites(this, level, r, f.sheet);
    applyPickupTint();
  }

  late Offset _offset;

  void applyPickupTint() {
    if (!f.playerState.hasProjectileColor) return;
    for (final child in children) {
      if (child is Sprite) {
        child.colorOverlay = f.playerState.projectileColor;
      }
    }
  }

  @override
  void move() {
    position += _offset;
  }

  @override
  Explosion createExplosion() {
    return ExplosionMini(f.sheet);
  }
}

class PiercingLaser extends Laser {
  PiercingLaser(GameObjectFactory f, int level, double r) : super(f, level, r) {
    canBeDamaged = false; // Never destroyed by impacts
    impact = (10.0 + level * 2.0) *
        f.playerState.damageMultiplier *
        f.playerState.weaponDamageMultiplier *
        f.playerState.ammoDamageMultiplier; // High damage

    // Tint the piercing laser purple
    for (Node child in children) {
      if (child is Sprite) {
        child.colorOverlay = const Color(0xFFFF00FF);
      }
    }
    applyPickupTint();
  }

  @override
  void addDamage(double d) {
    // Piercing laser takes no damage, passes through enemies
  }
}

class HomingLaser extends Laser {
  GameObject? target;

  HomingLaser(GameObjectFactory f, int level, double r) : super(f, level, r) {
    impact = (0.8 + level * 0.4) *
        f.playerState.damageMultiplier *
        f.playerState.weaponDamageMultiplier *
        f.playerState.ammoDamageMultiplier; // Slightly lower damage for homing

    // Tint the homing laser cyan
    for (Node child in children) {
      if (child is Sprite) {
        child.colorOverlay = const Color(0xFF00FFFF);
      }
    }
    applyPickupTint();
  }

  @override
  void move() {
    if (target != null && target!.parent != null && target!.canBeDamaged) {
      // Steer towards target
      Offset dir = target!.position - position;
      double currentAngle = math.atan2(_offset.dy, _offset.dx);
      double targetAngle = math.atan2(dir.dy, dir.dx);

      // Simple steering: just interpolate angle slightly towards target
      double diff = targetAngle - currentAngle;
      // Normalize angle diff
      while (diff > math.pi) diff -= 2 * math.pi;
      while (diff < -math.pi) diff += 2 * math.pi;

      double maxTurn = 0.15; // turn speed
      if (diff > maxTurn) diff = maxTurn;
      if (diff < -maxTurn) diff = -maxTurn;

      double newAngle = currentAngle + diff;
      double speed = _offset.distance;
      _offset = Offset(math.cos(newAngle) * speed, math.sin(newAngle) * speed);

      // Update visual rotation
      rotation = degrees(newAngle) + 90.0;
    } else {
      // Find new target
      double minD = double.infinity;
      for (Node n in f.level.children) {
        if (n is GameObject && n.canBeDamaged && n.canDamageShip) {
          double d = (n.position - position).distance;
          if (d < minD && d < 400.0) {
            // Search radius
            minD = d;
            target = n;
          }
        }
      }
    }

    super.move();
  }
}

class PlasmaLaser extends Laser {
  PlasmaLaser(GameObjectFactory f, int level, double r) : super(f, level, r) {
    radius = 18.0;
    impact = (3.0 + level * 1.2) *
        f.playerState.damageMultiplier *
        f.playerState.weaponDamageMultiplier *
        f.playerState.ammoDamageMultiplier;
    for (final child in children) {
      if (child is Sprite) {
        child.scale = 1.35;
        child.colorOverlay = const Color(0xFFFF7A18);
      }
    }
    applyPickupTint();
  }
}

class NovaLaser extends Laser {
  NovaLaser(GameObjectFactory f, int level, double r) : super(f, level, r) {
    radius = 26.0;
    impact = (4.0 + level * 1.5) *
        f.playerState.damageMultiplier *
        f.playerState.weaponDamageMultiplier *
        f.playerState.ammoDamageMultiplier;
    for (final child in children) {
      if (child is Sprite) {
        child.scale = 1.7;
        child.colorOverlay = const Color(0xFFB060FF);
      }
    }
    applyPickupTint();
  }
}
