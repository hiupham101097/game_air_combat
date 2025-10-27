import 'package:flutter/material.dart';
import 'package:mini__game2/controller/repeated_image.dart';
import 'package:mini__game2/controller/star_field.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';

class MainSceneBackground extends StatefulWidget {
  const MainSceneBackground({Key? key}) : super(key: key);

  @override
  MainSceneBackgroundState createState() => MainSceneBackgroundState();
}

class MainSceneBackgroundState extends State<MainSceneBackground> {
  late MainSceneBackgroundNode _backgroundNode;

  @override
  void initState() {
    super.initState();
    _backgroundNode = MainSceneBackgroundNode();
  }

  @override
  Widget build(BuildContext context) {
    return SpriteWidget(
      _backgroundNode,
      transformMode: SpriteBoxTransformMode.fixedWidth,
    );
  }
}

class MainSceneBackgroundNode extends NodeWithSize {
  late Sprite _bgTop;
  late Sprite _bgBottom;
  late RepeatedImage _background;
  late RepeatedImage _nebula;

  MainSceneBackgroundNode() : super(const Size(320.0, 320.0)) {
    // Add background
    _background = RepeatedImage(imageMap["assets/starfield.png"]!);
    addChild(_background);

    StarField starField = StarField(spriteSheet, 200, true);
    addChild(starField);

    // Add nebula
    _nebula = RepeatedImage(imageMap["assets/nebula.png"]!, BlendMode.plus);
    addChild(_nebula);

    _bgTop = Sprite.fromImage(imageMap["assets/ui_bg_top.png"]!);
    _bgTop.pivot = Offset.zero;
    _bgTop.size = const Size(320.0, 108.0);
    addChild(_bgTop);

    _bgBottom = Sprite.fromImage(imageMap["assets/ui_bg_bottom.png"]!);
    _bgBottom.pivot = const Offset(0.0, 1.0);
    _bgBottom.size = const Size(320.0, 97.0);
    addChild(_bgBottom);
  }

  @override
  void paint(Canvas canvas) {
    canvas.drawRect(const Rect.fromLTWH(0.0, 0.0, 320.0, 320.0),
        Paint()..color = const Color(0xff000000));
    super.paint(canvas);
  }

  @override
  void spriteBoxPerformedLayout() {
    _bgBottom.position = Offset(0.0, spriteBox!.visibleArea!.size.height);
  }

  @override
  void update(double dt) {
    _background.move(10.0 * dt);
    _nebula.move(100.0 * dt);
  }
}
