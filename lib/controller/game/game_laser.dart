import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_balance.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/model/combat_damage.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math_64.dart';

var _gameSizeHeight = 320.0;

class Laser extends GameObject {
  double _baseDamage = 0.0;
  double _weaponModifier = 1.0;
  double _buffModifier = 1.0;
  int _remainingPierces = 0;
  double _explosionRadius = 0.0;
  final Set<GameObject> _hitTargets = <GameObject>{};
  late final Sprite _trail;
  bool lastHitWasCritical = false;
  double lastHitDamage = 0.0;

  double get impact => _baseDamage * _weaponModifier * _buffModifier;

  /// Retains a simple override for support projectiles such as drone shots.
  set impact(double value) {
    _baseDamage = value;
    _weaponModifier = 1.0;
    _buffModifier = 1.0;
  }

  double get explosionRadius => _explosionRadius;

  void setPierceCount(int count) => _remainingPierces = count;

  void setExplosionRadius(double radius) => _explosionRadius = radius;

  bool hasHitTarget(GameObject target) => _hitTargets.contains(target);

  /// Returns true when this projectile survives to hit another target.
  bool registerTargetHit(GameObject target) {
    _hitTargets.add(target);
    if (_remainingPierces < 0) return true;
    if (_remainingPierces > 0) {
      _remainingPierces--;
      return true;
    }
    return false;
  }

  double damageForHit({double targetResistance = 0.0, double scale = 1.0}) {
    final stats = f.playerState.combatStats;
    final result = CombatDamagePipeline.resolve(
      baseDamage: _baseDamage * scale,
      weaponModifier: _weaponModifier,
      buffModifier: _buffModifier,
      criticalChance: stats.criticalChance,
      criticalDamageMultiplier: stats.criticalDamageMultiplier,
      targetResistance: targetResistance,
    );
    lastHitWasCritical = result.isCritical;
    lastHitDamage = result.finalDamage;
    return result.finalDamage;
  }

  void configureWeaponDamage(int level, {double baseMultiplier = 1.0}) {
    _baseDamage = GameBalance.laserDamageMultiplier(level) * baseMultiplier;
    _weaponModifier = f.playerState.equipmentDamageMultiplier *
        f.playerState.weaponDamageMultiplier;
    _buffModifier = f.playerState.runDamageBuffMultiplier *
        f.playerState.ammoDamageMultiplier *
        f.playerState.adDamageMultiplier;
  }

  Laser(GameObjectFactory f, int level, double r) : super(f) {
    radius = 10.0; //Phạm vi đạn gây sát thương
    removeLimit = _gameSizeHeight * 5 + radius; //Tăng chiều dài đạn bắn ra
    canDamageShip = false;
    canBeDamaged = false;
    final stats = f.playerState.combatStats;
    configureWeaponDamage(level);
    _remainingPierces = stats.pierceCount;
    _explosionRadius = stats.explosionRadius;

    // Tăng tốc độ lase bắn
    final projectileSpeed = stats.projectileSpeedMultiplier;
    _offset = Offset(
      math.cos(radians(r)) * 8.0 * projectileSpeed,
      math.sin(radians(r)) * 8.0 * projectileSpeed - f.playerState.scrollSpeed,
    );

    // tăng kích thước đạn
    rotation = r + 90.0;

    _trail = Sprite(texture: f.sheet['explosion_particle.png']!)
      ..scaleX = 0.22
      ..scaleY = 0.75
      ..position = const Offset(0.0, 8.0)
      ..opacity = 0.34
      ..colorOverlay = const Color(0xFF83F7FF)
      ..blendMode = ui.BlendMode.plus;
    addChild(_trail);
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
    configureWeaponDamage(level, baseMultiplier: 10.0);

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
    configureWeaponDamage(level, baseMultiplier: 0.8);
    _trail
      ..scaleX = 0.30
      ..scaleY = 1.2
      ..position = const Offset(0.0, 11.0)
      ..opacity = 0.48
      ..colorOverlay = const Color(0xFF29B6F6);

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
    configureWeaponDamage(level, baseMultiplier: 3.0);
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
    configureWeaponDamage(level, baseMultiplier: 4.0);
    for (final child in children) {
      if (child is Sprite) {
        child.scale = 1.7;
        child.colorOverlay = const Color(0xFFB060FF);
      }
    }
    applyPickupTint();
  }
}

/// Heavy cyan shot used only by the Super Fighter's phase cannon.
class PhaseLanceLaser extends Laser {
  PhaseLanceLaser(GameObjectFactory f, int level, double r)
      : super(f, level, r) {
    radius = 18.0;
    for (final child in children) {
      if (child is Sprite) {
        child.scale = 1.45;
        child.colorOverlay = const Color(0xFF55E8FF);
        child.blendMode = ui.BlendMode.plus;
      }
    }

    final core = Sprite(texture: f.sheet['explosion_particle.png']!)
      ..scale = 0.48
      ..position = const Offset(0.0, 9.0)
      ..colorOverlay = const Color(0xFFC7FBFF)
      ..blendMode = ui.BlendMode.plus;
    addChild(core);
    applyPickupTint();
  }
}

/// Rift Dancer bolt curves inward as it climbs, sweeping back across a lane.
class RiftArcLaser extends Laser {
  RiftArcLaser(GameObjectFactory f, int level, double angle)
      : _curveDirection = angle < -90.0
            ? 1.0
            : angle > -90.0
                ? -1.0
                : 0.0,
        super(f, level, angle) {
    radius = 12.0;
    configureWeaponDamage(level, baseMultiplier: 0.65);
    for (final child in children) {
      if (child is Sprite) {
        child.scale = 1.05;
        child.colorOverlay = const Color(0xFF72F5FF);
        child.blendMode = ui.BlendMode.plus;
      }
    }
    applyPickupTint();
  }

  final double _curveDirection;
  double _age = 0.0;

  @override
  void move() {
    super.move();
    _age += 0.22;
    position += Offset(math.sin(_age) * _curveDirection * 1.25, 0.0);
  }
}

/// Bastion flak rounds trade single-shot damage for a five-lane burst.
class FlakLaser extends Laser {
  FlakLaser(GameObjectFactory f, int level, double angle)
      : super(f, level, angle) {
    radius = 16.0;
    configureWeaponDamage(level, baseMultiplier: 0.48);
    for (final child in children) {
      if (child is Sprite) {
        child.scale = 1.22;
        child.colorOverlay = const Color(0xFFFFB44A);
      }
    }
    applyPickupTint();
  }
}
