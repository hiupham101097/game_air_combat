
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_demo_node.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';

class GameScene extends StatefulWidget {
  const GameScene({
    this.onGameOver,
    this.gameState,
    Key? key,
  }) : super(key: key);

  final GameOverCallback? onGameOver;
  final PersistantGameState? gameState;

  @override
  State<GameScene> createState() => GameSceneState();
}

class GameSceneState extends State<GameScene> {
  late NodeWithSize _game;

  @override
  void initState() {
    super.initState();

    _game = GameDemoNode(
      imageMap,
      spriteSheet,
      spriteSheetUI,
      sounds,
      widget.gameState!,
      (
        int score,
        int coins,
        int levelReached,
      ) {
        Navigator.pop(context);
        widget.onGameOver!(score, coins, levelReached);
        sounds.playMusic('music_intro');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpriteWidget(
      _game,
      transformMode: SpriteBoxTransformMode.fixedWidth,
    );
  }
}