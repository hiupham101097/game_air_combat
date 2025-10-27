import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:spritewidget/spritewidget.dart';

class AsteroidBig extends Asteroid {
  late Sprite _sprite;

  AsteroidBig(GameObjectFactory f) : super(f) {
    _sprite = Sprite(texture: f.sheet["asteroid_big_${randomInt(3)}.png"]!);
    _sprite.scale = 0.3;
    radius = 25.0;
    maxDamage = 5.0;
    addChild(_sprite);
  }
}

