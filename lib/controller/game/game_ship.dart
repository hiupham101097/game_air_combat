import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:spritewidget/spritewidget.dart';

class Ship extends GameObject {
  Ship(GameObjectFactory f) : super(f) {
    // Add main ship sprite
    _sprite = Sprite(texture: f.sheet["ship.png"]!);
    _sprite.scale = 0.3;
    _sprite.rotation = -90.0;
    addChild(_sprite);

    _spriteShield = Sprite(texture: f.sheet["shield.png"]!);
    _spriteShield.scale = 0.35;
    _spriteShield.blendMode = ui.BlendMode.plus;
    addChild(_spriteShield);

    radius = 20.0;
    canBeDamaged = false;
    canDamageShip = false;

    // Set start position
    position = const Offset(0.0, 50.0);
  }

  late Sprite _sprite;
  late Sprite _spriteShield;

  void applyThrust(Offset joystickValue, double scroll) {
    Offset oldPos = position;
    Offset target = Offset(
        joystickValue.dx * 160.0, joystickValue.dy * 220.0 - 250.0 - scroll);
    double filterFactor = 0.2;

    position = Offset(GameMath.filter(oldPos.dx, target.dx, filterFactor),
        GameMath.filter(oldPos.dy, target.dy, filterFactor));
  }

  @override
  void setupActions() {
    MotionTween rotate = MotionTween<double>(
      setter: (a) => _spriteShield.rotation = a,
      start: 0.0,
      end: 360.0,
      duration: 1.0,
    );
    _spriteShield.motions.run(MotionRepeatForever(motion: rotate));
  }

  @override
  void update(double dt) {
    // Update shield
    if (f.playerState.shieldActive) {
      if (f.playerState.shieldDeactivating) {
        _spriteShield.visible = !_spriteShield.visible;
      } else {
        _spriteShield.visible = true;
      }
    } else {
      _spriteShield.visible = false;
    }
  }
}
