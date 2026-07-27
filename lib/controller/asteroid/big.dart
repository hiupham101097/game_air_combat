import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_balance.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:spritewidget/spritewidget.dart';

class AsteroidBig extends Asteroid {
  late Sprite _sprite;

  AsteroidBig(GameObjectFactory f, [int threatLevel = 0]) : super(f) {
    _sprite = Sprite(texture: f.sheet["asteroid_big_${randomInt(3)}.png"]!);
    _sprite.scale = 0.3 + (threatLevel * 0.012).clamp(0.0, 0.08);
    radius = 25.0 + (threatLevel * 0.75).clamp(0.0, 6.0);
    maxDamage = GameBalance.enemyHealth(5, threatLevel, 1.15);
    scoreReward = 12 + threatLevel * 4;
    addChild(_sprite);
  }
}
