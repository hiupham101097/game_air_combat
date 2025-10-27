import 'package:flutter/material.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/view/widgets.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    required this.gameState,
    Key? key,
  }) : super(key: key);

  final PersistantGameState gameState;

  @override
  Widget build(BuildContext context) {
    TextStyle scoreLabelStyle = const TextStyle(
        fontFamily: "Orbitron",
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: darkTextColor);

    return Stack(
      children: <Widget>[
        Positioned(
          left: 18.0,
          top: 13.0,
          child: Text("Điểm mới nhất", style: scoreLabelStyle),
        ),
        Positioned(
          left: 18.0,
          top: 39.0,
          child: Text("Điểm cao nhất", style: scoreLabelStyle),
        ),
        Positioned(
          right: 18.0,
          top: 13.0,
          child: Text("${gameState.lastScore}", style: scoreLabelStyle),
        ),
        Positioned(
          right: 18.0,
          top: 39.0,
          child: Text("${gameState.weeklyBestScore}", style: scoreLabelStyle),
        ),
        Positioned(
          left: 18.0,
          top: 80.0,
          child: TextureImage(
              texture: spriteSheetUI['icn_crystal.png']!,
              width: 12.0,
              height: 18.0),
        ),
        Positioned(
          left: 36.0,
          top: 82.5,
          child: Text(
            "${gameState.coins}",
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: darkTextColor,
            ),
          ),
        ),
      ],
    );
  }
}