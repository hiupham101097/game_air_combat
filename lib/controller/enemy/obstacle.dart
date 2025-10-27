import 'package:mini__game2/controller/explosions.dart';
import 'package:mini__game2/controller/game/game_coin.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:spritewidget/spritewidget.dart';

import '../game/game_objects.dart';

late Sprite sprite;

abstract class Obstacle extends GameObject {
  Obstacle(GameObjectFactory f) : super(f);

  double explosionScale = 1.0;

  @override
  Explosion createExplosion() {
    f.sounds.playEffect("explosion_${randomInt(3)}");
    Explosion explo = ExplosionBig(f.sheet);
    explo.scale = explosionScale;
    return explo;
  }
}

abstract class Asteroid extends Obstacle {
  Asteroid(GameObjectFactory f) : super(f);

  

  @override
  void setupActions() {
    // Rotate obstacle
    int direction = 1;
    if (randomBool()) direction = -1;
    MotionTween rotate = MotionTween<double>(
      setter: (a) => sprite.rotation = a,
      start: 0.0,
      end: 360.0 * direction,
      duration: 5.0 + 5.0 * randomDouble(),
    );
    sprite.motions.run(MotionRepeatForever(motion: rotate));
  }

  @override
  set damage(double d) {
    super.damage = d;
    sprite.colorOverlay = colorForDamage(d, maxDamage);
  }

  @override
  Collectable createPowerUp() {
    return Coin(f);
  }
}