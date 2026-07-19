import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/ship_model.dart';
import 'package:spritewidget/spritewidget.dart';

class Ship extends GameObject {
  Ship(GameObjectFactory f) : super(f) {
    // Load ship based on equipped ship selection
    final shipConfig = ShipConfig
        .ships[gameState.equippedShip.clamp(0, ShipConfig.ships.length - 1)];

    if (shipConfig.customAsset != null) {
      // Custom fighters are normalized to the original 188px sprite canvas.
      final spriteName = shipConfig.customAsset!.split('/').last;
      _sprite = Sprite(texture: shipSpriteSheet[spriteName]!);
      // The original atlas ship points right; the new fighter art points up.
      _sprite.rotation = 0.0;
    } else {
      // Load default from sprite sheet
      _sprite = Sprite(texture: f.sheet["ship.png"]!);
      _sprite.rotation = -90.0;
    }
    _sprite.scale = 0.3;
    addChild(_sprite);

    _spriteShield = Sprite(texture: f.sheet["shield.png"]!);
    _spriteShield.scale = 0.35;
    _spriteShield.blendMode = ui.BlendMode.plus;
    addChild(_spriteShield);

    radius = 20.0 * shipConfig.sizeMultiplier;
    canBeDamaged = false;
    canDamageShip = false;

    // Apply ship multipliers
    _speedMultiplier = shipConfig.speedMultiplier;
    _fireRateMultiplier = shipConfig.fireRateMultiplier;

    // Set start position
    position = const Offset(0.0, 50.0);
  }

  late Sprite _sprite;
  late Sprite _spriteShield;
  double _speedMultiplier = 1.0;
  double _fireRateMultiplier = 1.0;

  double get fireRateMultiplier => _fireRateMultiplier;

  void applyThrust(Offset joystickValue, double scroll) {
    Offset target = Offset(joystickValue.dx * 160.0 * _speedMultiplier,
        joystickValue.dy * 220.0 - 250.0 - scroll);
    applyTarget(target);
  }

  void applyTarget(Offset target) {
    Offset oldPos = position;
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
