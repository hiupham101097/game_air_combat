import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';

class LaserDisplay extends StatelessWidget {
  const LaserDisplay({
    required this.level,
    Key? key,
  }) : super(key: key);

  final int level;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: 26.0,
        height: 26.0,
        child: SpriteWidget(LaserDisplayNode(level)),
      ),
    );
  }
}

class LaserDisplayNode extends NodeWithSize {
  LaserDisplayNode(int level) : super(const Size(16.0, 16.0)) {
    Node placementNode = Node();
    placementNode.position = const Offset(8.0, 8.0);
    placementNode.scale = 0.7;
    addChild(placementNode);
    addLaserSprites(placementNode, level, 0.0, spriteSheet);
  }
}
