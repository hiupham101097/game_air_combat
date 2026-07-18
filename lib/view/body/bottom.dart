import 'package:flutter/material.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/view/widgets.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    required this.onPlay,
    required this.onPlayEvent,
    required this.gameState,
    required this.onStartLevelUp,
    required this.onStartLevelDown,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPlay;
  final VoidCallback onPlayEvent;
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
          top: 5.0,
          child: TextureButton(
            onPressed: onPlay,
            texture: spriteSheetUI['btn_play.png']!,
            label: "Bắt đầu",
            textStyle: const TextStyle(
              fontFamily: "Orbitron",
              fontSize: 22.0,
              letterSpacing: 2.0,
              color: Color(0xffffffff),
            ),
            textAlign: TextAlign.center,
            width: 181.0,
            height: 46.0,
          ),
        ),
        Positioned(
          left: 120.0,
          top: 50.0,
          child: GestureDetector(
            onTap: onPlayEvent,
            child: Container(
              width: 181.0,
              height: 36.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6600), Color(0xFFFF0066)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Color(0xFFFF4400), blurRadius: 10, spreadRadius: 1)
                ],
              ),
              child: const Center(
                child: Text(
                  '⚡ EVENT MODE',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 13.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}