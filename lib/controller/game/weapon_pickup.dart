import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/model/weapon.dart';
import 'package:spritewidget/spritewidget.dart';

class WeaponPickup extends Collectable {
  WeaponPickup(GameObjectFactory f, this.type) : super(f) {
    radius = 20.0;

    // Background glow
    Sprite glow = Sprite(texture: f.sheet["explosion_particle.png"]!);
    glow.scale = 2.0;
    glow.blendMode = ui.BlendMode.plus;

    // Weapon icon (we reuse a generic powerup icon or ship icon)
    Sprite icon = Sprite(
        texture: f.sheet["powerup_1.png"]!); // Use speedLaser icon as base
    icon.scale = 0.5;

    // Tint based on type
    Color weaponColor;
    switch (type) {
      case WeaponType.spread:
        weaponColor = const Color(0xFFFFFF00); // Yellow
        break;
      case WeaponType.piercing:
        weaponColor = const Color(0xFFFF00FF); // Purple
        break;
      case WeaponType.homing:
        weaponColor = const Color(0xFF00FFFF); // Cyan
        break;
      case WeaponType.rapid:
        weaponColor = const Color(0xFF80FF80); // Green
        break;
      case WeaponType.plasma:
        weaponColor = const Color(0xFFFF7A18); // Orange
        break;
      case WeaponType.nova:
        weaponColor = const Color(0xFFB060FF); // Violet
        break;
      case WeaponType.phase:
        weaponColor = const Color(0xFF55E8FF); // Phase cyan
        break;
      case WeaponType.arc:
        weaponColor = const Color(0xFFB56CFF);
        break;
      case WeaponType.flak:
        weaponColor = const Color(0xFFFFB44A);
        break;
      default:
        weaponColor = const Color(0xFFFFFFFF); // White
    }

    glow.colorOverlay = weaponColor.withOpacity(0.5);
    icon.colorOverlay = weaponColor;

    addChild(glow);
    addChild(icon);

    // Floating animation
    MotionTween scaleUp = MotionTween<double>(
      setter: (a) => icon.scale = a,
      start: 0.4,
      end: 0.6,
      duration: 0.5,
    );
    MotionTween scaleDown = MotionTween<double>(
      setter: (a) => icon.scale = a,
      start: 0.6,
      end: 0.4,
      duration: 0.5,
    );
    icon.motions.run(MotionRepeatForever(
        motion: MotionSequence(motions: [scaleUp, scaleDown])));
  }

  final WeaponType type;

  @override
  void collect() {
    f.sounds.playEffect("pickup_powerup");
    f.playerState.changeWeapon(type);
    super.collect();
  }

  @override
  void move() {
    position += const Offset(0.0, 2.0); // Fall down slowly
    super.move();
  }
}
