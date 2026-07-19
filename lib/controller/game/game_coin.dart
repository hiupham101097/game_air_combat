import 'dart:math' as math;
import 'dart:ui';

import 'package:mini__game2/controller/enemy/obstacle.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:spritewidget/spritewidget.dart';

class Coin extends Collectable {
  Coin(GameObjectFactory f, {int? value})
      : value = value ?? _randomCoinValue(),
        super(f) {
    sprite = Sprite(texture: f.sheet["coin.png"]!);
    sprite.scale = displayScale;
    sprite.blendMode = BlendMode.plus;
    sprite.colorOverlay = color;
    addChild(sprite);

    radius = isLarge
        ? 14.0
        : isMedium
            ? 10.0
            : 8.0;
  }

  static final math.Random _random = math.Random();

  /// Large coins appear in drops and award 5–10 coins instead of one.
  static int _randomCoinValue() {
    final roll = _random.nextInt(100);
    if (roll < 12) return 50;
    if (roll < 42) return 20;
    return 10;
  }

  final int value;

  bool get isMedium => value >= 20 && value < 50;
  bool get isLarge => value >= 50;
  double get displayScale => isLarge
      ? 1.28
      : isMedium
          ? 1.02
          : 0.80;
  Color get color => isLarge
      ? const Color(0xFFFFFF70)
      : isMedium
          ? const Color(0xFFFFC247)
          : const Color(0xFFFFF3A0);

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

    MotionTween pulse = MotionTween<double>(
      setter: (a) => sprite.scale = a,
      start: displayScale * 0.9,
      end: displayScale * 1.16,
      duration: 0.55,
    );
    motions.run(MotionRepeatForever(motion: pulse));
  }

  @override
  void collect() {
    f.sounds.playEffect("pickup_0");
    f.playerState.addCoin(this);
    super.collect();
  }
}
