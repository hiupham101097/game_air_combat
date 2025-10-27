import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:spritewidget/spritewidget.dart';

class Coin extends Collectable {
  Coin(GameObjectFactory f) : super(f) {
    sprite = Sprite(texture: f.sheet["coin.png"]!);
    sprite.scale = 0.7;
    addChild(sprite);

    radius = 7.5;
  }

  @override
  void setupActions() {
    // Rotate
    MotionTween rotate = MotionTween<double>(
      setter: (a) => sprite.rotation = a,
      start: 0.0,
      end: 360.0,
      duration: 1.0,
    );
    motions.run(MotionRepeatForever(motion: rotate));

    // Fade in
    MotionTween fadeIn = MotionTween<double>(
      setter: (a) => sprite.opacity = a,
      start: 0.0,
      end: 1.0,
      duration: 0.6,
    );
    motions.run(fadeIn);
  }

  @override
  void collect() {
    f.sounds.playEffect("pickup_0");
    f.playerState.addCoin(this);
    super.collect();
  }
}

