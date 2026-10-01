import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_laser.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/equipment.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:vector_math/vector_math.dart';

class PlayerDrone extends GameObject {
  final EquipmentItem equipment;
  final int level;
  final bool isLeftSide;

  PlayerDrone(GameObjectFactory f, this.equipment, this.level, this.isLeftSide)
      : super(f) {
    canBeDamaged = false;
    canDamageShip = false;

    // Drone body using ship sprite but scaled very small
    _sprite = Sprite.fromImage(imageMap['assets/drone_sprite.png']!);
    _sprite.scale = 0.18; // Much smaller than before — real "mini" drone size
    _sprite.rotation = isLeftSide ? -15.0 : 15.0; // Slight tilt for personality
    addChild(_sprite);

    // Engine glow effect below drone
    Sprite engineGlow = Sprite(texture: f.sheet["explosion_particle.png"]!);
    engineGlow.scale = 0.25;
    engineGlow.position = const Offset(0, 8);
    engineGlow.colorOverlay = equipment.color;
    engineGlow.blendMode = BlendMode.plus;
    addChild(engineGlow);

    // Pulsing animation on engine glow
    MotionTween<double> pulse = MotionTween<double>(
      setter: (v) => engineGlow.scale = v,
      start: 0.15,
      end: 0.28,
      duration: 0.4,
    );
    engineGlow.motions.run(MotionRepeatForever(motion: pulse));

    // Guard against zero or negative fire rate
    final fireRate = f.playerState.combatStats.droneFireRate;
    _fireDelay = fireRate > 0 ? (60.0 / fireRate).round() : 60;
  }

  late Sprite _sprite;
  int _fireCooldown = 0;
  int _fireDelay = 60;
  int _repairCooldownFrames = 1800;

  // Visual bobbing effect
  double _time = 0.0;

  @override
  void update(double dt) {
    _time += dt;

    // Guard: if ship is gone (e.g., player died), skip update
    try {
      // Calculate target position (hovering next to the ship)
      Offset shipPos = f.level.ship.position;
      double offsetX = isLeftSide ? -35.0 : 35.0;
      double offsetY = 10.0 + math.sin(_time * 4.0) * 5.0; // Bobbing effect

      Offset targetPos = shipPos + Offset(offsetX, offsetY);

      // Smoothly follow the ship
      position += (targetPos - position) * 0.2;
    } catch (_) {
      return;
    }

    if (equipment.droneRole == DroneRole.shield) return;
    if (equipment.droneRole == DroneRole.repair) {
      // Only the left drone repairs, preventing duplicate passive healing.
      if (isLeftSide && --_repairCooldownFrames <= 0) {
        if (f.playerState.hp < f.playerState.maxHp) f.playerState.hp++;
        _repairCooldownFrames = 1800;
      }
      return;
    }

    // Handle firing
    _fireCooldown--;
    if (_fireCooldown <= 0) {
      _fire();
      _fireCooldown = _fireDelay;
    }
  }

  void _fire() {
    // Determine target
    double angle = -90.0; // Default shoot up

    if (equipment.droneRole == DroneRole.missile) {
      // Find nearest enemy
      double minD = double.infinity;
      GameObject? target;

      for (Node n in f.level.children) {
        if (n is GameObject && n.canBeDamaged && n.canDamageShip) {
          double d = (n.position - position).distance;
          if (d < minD && d < 300.0) {
            // Search radius
            minD = d;
            target = n;
          }
        }
      }

      if (target != null) {
        Offset dir = target.position - position;
        angle = degrees(math.atan2(dir.dy, dir.dx));
      }
    }

    // Spawn laser
    Laser shot;
    if (equipment.droneRole == DroneRole.missile) {
      shot = HomingLaser(f, f.playerState.laserLevel, angle);
    } else {
      shot = Laser(f, f.playerState.laserLevel, angle);
    }

    // Override damage with drone damage
    final stats = f.playerState.combatStats;
    shot.impact = stats.droneDamage *
        f.playerState.equipmentDamageMultiplier *
        f.playerState.runDamageBuffMultiplier;
    shot.setPierceCount(0);
    shot.setExplosionRadius(0.0);
    shot.position = position + const Offset(0, -10.0);

    // Make drone lasers visually distinct (smaller or colored)
    for (Node child in shot.children) {
      if (child is Sprite) {
        child.scale = 0.3; // smaller than player laser
        child.colorOverlay = equipment.color;
      }
    }

    f.level.addChild(shot);
    f.sounds.playEffect("laser");
  }
}
