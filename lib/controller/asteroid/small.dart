import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:spritewidget/spritewidget.dart';


class AsteroidSmall extends Asteroid {

  AsteroidSmall(GameObjectFactory f) : super(f) {
    sprite = Sprite(texture: f.sheet["asteroid_small_${randomInt(3)}.png"]!);
    sprite.scale = 0.3;
    radius = 12.0;
    maxDamage = 3.0;
    addChild(sprite);
  }
}
