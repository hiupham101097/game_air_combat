import 'package:flutter/material.dart';
import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:spritewidget/spritewidget.dart';

class EnemyScout extends Obstacle {
  EnemyScout(GameObjectFactory f, int level) : super(f) {
    _sprite = Sprite(texture: f.sheet["enemy_scout_$level.png"]!);
    _sprite.scale = 0.32;

    radius = 12.0 + level * 2.0;

    if (level == 0) {
      maxDamage = 1.0;
    } else if (level == 1) {
      maxDamage = 4.0;
    } else if (level == 2) {
      maxDamage = 8.0;
    }

    addChild(_sprite);

    constraints = <Constraint>[ConstraintRotationToMovement(dampening: 0.5)];
  }

  final double _swirlSpacing = 80.0;

  _addRandomSquare(List<Offset> offsets, double x, double y) {
    double xMove = (randomBool()) ? _swirlSpacing : -_swirlSpacing;
    double yMove = (randomBool()) ? _swirlSpacing : -_swirlSpacing;

    if (randomBool()) {
      offsets.addAll(<Offset>[
        Offset(x, y),
        Offset(xMove + x, y),
        Offset(xMove + x, yMove + y),
        Offset(x, yMove + y),
        Offset(x, y)
      ]);
    } else {
      offsets.addAll(<Offset>[
        Offset(x, y),
        Offset(x, y + yMove),
        Offset(xMove + x, yMove + y),
        Offset(xMove + x, y),
        Offset(x, y)
      ]);
    }
  }

  @override
  void setupActions() {
    List<Offset> offsets = <Offset>[];
    _addRandomSquare(offsets, -_swirlSpacing, 0.0);
    _addRandomSquare(offsets, _swirlSpacing, 0.0);
    offsets.add(Offset(-_swirlSpacing, 0.0));

    List<Offset> points = <Offset>[];
    for (Offset offset in offsets) {
      points.add(position + offset);
    }

    MotionSpline spline = MotionSpline(
      setter: (Offset a) => position = a,
      points: points,
      duration: 6.0,
    );
    spline.tension = 0.7;
    motions.run(MotionRepeatForever(motion: spline));
  }

  @override
  Collectable createPowerUp() {
    return Coin(f);
  }

  @override
  set damage(double d) {
    super.damage = d;
    _sprite.colorOverlay = colorForDamage(d, maxDamage);
  }

  late Sprite _sprite;
}


