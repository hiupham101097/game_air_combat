import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:spritewidget/spritewidget.dart';

class AsteroidSmall extends Asteroid {
  AsteroidSmall(GameObjectFactory f, [int threatLevel = 0]) : super(f) {
    sprite = Sprite(texture: f.sheet["asteroid_small_${randomInt(3)}.png"]!);
    sprite.scale = 0.3 + (threatLevel * 0.01).clamp(0.0, 0.06);
    radius = 12.0 + (threatLevel * 0.5).clamp(0.0, 4.0);
    maxDamage = 3.0 * (1.0 + threatLevel * 0.28);
    addChild(sprite);
  }
}
