import 'package:flutter/material.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/view/widgets.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    required this.onPlay,
    required this.gameState,
    required this.onStartLevelUp,
    required this.onStartLevelDown,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPlay;
  final VoidCallback onStartLevelUp;
  final VoidCallback onStartLevelDown;
  final PersistantGameState gameState;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 18.0,
          top: 14.0,
          child: TextureImage(
            texture: spriteSheetUI['level_display.png']!,
            width: 62.0,
            height: 62.0,
          ),
        ),
        Positioned(
          left: 18.0,
          top: 14.0,
          child: TextureImage(
            texture: spriteSheetUI[
                'level_display_${gameState.currentStartingLevel + 1}.png']!,
            width: 62.0,
            height: 62.0,
          ),
        ),
        Positioned(
          left: 85.0,
          top: 14.0,
          child: TextureButton(
            texture: spriteSheetUI['btn_level_up.png']!,
            width: 30.0,
            height: 30.0,
            onPressed: onStartLevelUp,
          ),
        ),
        Positioned(
          left: 85.0,
          top: 46.0,
          child: TextureButton(
            texture: spriteSheetUI['btn_level_down.png']!,
            width: 30.0,
            height: 30.0,
            onPressed: onStartLevelDown,
          ),
        ),
        Positioned(
          left: 120.0,
          top: 14.0,
          child: TextureButton(
            onPressed: onPlay,
            texture: spriteSheetUI['btn_play.png']!,
            label: "Bắt đầu",
            textStyle: const TextStyle(
              fontFamily: "Orbitron",
              fontSize: 28.0,
              letterSpacing: 3.0,
              color: Color(0xffffffff),
            ),
            textAlign: TextAlign.center,
            width: 181.0,
            height: 62.0,
          ),
        ),
      ],
    );
  }
}