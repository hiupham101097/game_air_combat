import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_ship.dart';
import 'package:spritewidget/spritewidget.dart';

class Level extends Node {
  Level() {
    position = const Offset(160.0, 0.0);
  }

  late Ship ship;

  double scroll(double scrollSpeed) {
    position += Offset(0.0, scrollSpeed);
    return position.dy;
  }
}