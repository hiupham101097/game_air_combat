import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:spritewidget/spritewidget.dart';

class LevelLabel extends GameObject {
  LevelLabel(GameObjectFactory f, int level) : super(f) {
    canDamageShip = false;
    canBeDamaged = false;

    Label lbl = Label("LEVEL $level",
        textAlign: TextAlign.center,
        textStyle: const TextStyle(
            fontFamily: "Orbitron",
            letterSpacing: 10.0,
            color: Color(0xffffffff),
            fontSize: 24.0,
            fontWeight: FontWeight.w600));
    addChild(lbl);
  }
}
