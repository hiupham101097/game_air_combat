import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';

class PowerUp extends Collectable {
  PowerUp(GameObjectFactory f, this.type) : super(f) {
    _sprite = Sprite(texture: f.sheet["powerup.png"]!);
    _sprite.scale = 0.3;
    addChild(_sprite);

    // Check if it's a standard power up or a new buff
    int iconIndex = type.index < 4 ? type.index : 0;
    Sprite powerUpIcon = Sprite(texture: f.sheet["powerup_$iconIndex.png"]!);
    
    if (type == PowerUpType.heal) {
      powerUpIcon.colorOverlay = const Color.fromARGB(200, 0, 255, 0); // Green
    } else if (type == PowerUpType.magnet) {
      powerUpIcon.colorOverlay = const Color.fromARGB(200, 50, 50, 255); // Blue
    } else if (type == PowerUpType.nuke) {
      powerUpIcon.colorOverlay = const Color.fromARGB(200, 255, 0, 0); // Red
    }
    
    powerUpIcon.scale = 0.3;
    addChild(powerUpIcon);

    radius = 10.0;
  }

  late Sprite _sprite;
  PowerUpType type;

  @override
  void setupActions() {
    MotionTween rotate = MotionTween<double>(
      setter: (a) => _sprite.rotation = a,
      start: 0.0,
      end: 360.0,
      duration: 1.0,
    );
    motions.run(MotionRepeatForever(motion: rotate));

    // Fade in
    MotionTween fadeIn = MotionTween<double>(
      setter: (a) => _sprite.opacity = a,
      start: 0.0,
      end: 1.0,
      duration: 0.6,
    );
    motions.run(fadeIn);
  }

  @override
  void collect() {
    f.sounds.playEffect("buy_upgrade");
    f.playerState.activatePowerUp(type);
    super.collect();
  }
}
