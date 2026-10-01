import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/l10n/game_localizations.dart';
import 'package:mini__game2/l10n/generated/app_localizations.dart';
import 'package:spritewidget/spritewidget.dart';

class LevelLabel extends GameObject {
  LevelLabel(GameObjectFactory f, int level, AppLocalizations localizations)
      : super(f) {
    canDamageShip = false;
    canBeDamaged = false;

    Label lbl = Label(localizations.level(level),
        textAlign: TextAlign.center,
        textStyle: const TextStyle(
            fontFamily: "Orbitron",
            letterSpacing: 7.0,
            color: Color(0xffffffff),
            fontSize: 21.0,
            fontWeight: FontWeight.w600));
    addChild(lbl);

    final sector = Label(localizations.campaignSector(level),
        textAlign: TextAlign.center,
        textStyle: const TextStyle(
          fontFamily: "Orbitron",
          letterSpacing: 2.0,
          color: Color(0xFF82E8FF),
          fontSize: 9.0,
          fontWeight: FontWeight.w500,
        ))
      ..position = const Offset(0, 25);
    addChild(sector);
  }
}
