import 'package:flutter/material.dart';
import 'package:mini__game2/controller/asteroid/big.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/controller/power/power_up.dart';
import 'package:mini__game2/controller/power/power_upda_type.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';

class AsteroidPowerUp extends AsteroidBig {
  late PowerUpType _powerUpType;

  AsteroidPowerUp(GameObjectFactory f, [int threatLevel = 0])
      : super(f, threatLevel) {
    _powerUpType = nextPowerUpType();

    removeAllChildren();

    Sprite powerUpBg = Sprite(
      texture: f.sheet["powerup.png"]!,
    );
    powerUpBg.scale = 0.3;
    addChild(powerUpBg);

    int iconIndex = _powerUpType.index < 4 ? _powerUpType.index : 0;
    Sprite powerUpIcon = Sprite(
      texture: f.sheet["powerup_$iconIndex.png"]!,
    );
    if (_powerUpType == PowerUpType.heal) {
      powerUpIcon.colorOverlay = const Color.fromARGB(200, 0, 255, 0);
    } else if (_powerUpType == PowerUpType.magnet) {
      powerUpIcon.colorOverlay = const Color.fromARGB(200, 50, 50, 255);
    } else if (_powerUpType == PowerUpType.nuke) {
      powerUpIcon.colorOverlay = const Color.fromARGB(200, 255, 0, 0);
    }
    powerUpIcon.scale = 0.3;
    addChild(powerUpIcon);

    sprite = Sprite(
      texture: f.sheet["crystal_${randomInt(2)}.png"]!,
    );
    sprite.scale = 0.3;
    addChild(sprite);
  }

  @override
  void setupActions() {}

  @override
  Collectable createPowerUp() {
    return PowerUp(f, _powerUpType);
  }

  @override
  set damage(double d) {
    super.damage = d;
    sprite.colorOverlay =
        colorForDamage(d, maxDamage, const Color.fromARGB(255, 200, 200, 255));
  }
}
