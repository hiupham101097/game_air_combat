import 'package:flutter/material.dart';
import 'package:mini__game2/controller/coordinate/coordinate_system.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/view/body/back_ground.dart';
import 'package:mini__game2/view/body/bottom.dart';
import 'package:mini__game2/view/body/center.dart';
import 'package:mini__game2/view/body/top_bar.dart';

class MainScene extends StatefulWidget {
  const MainScene({
    Key? key,
    required this.gameState,
    required this.onUpgradePowerUp,
    required this.onUpgradeLaser,
    required this.onStartLevelUp,
    required this.onStartLevelDown,
  }) : super(key: key);

  final PersistantGameState gameState;
  final UpgradePowerUpCallback onUpgradePowerUp;
  final VoidCallback onUpgradeLaser;
  final VoidCallback onStartLevelUp;
  final VoidCallback onStartLevelDown;

  @override
  State<MainScene> createState() => MainSceneState();
}

class MainSceneState extends State<MainScene> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var notchOffset = MediaQuery.of(context).padding.top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          height: notchOffset,
        ),
        Expanded(
          child: CoordinateSystem(
            systemSize: const Size(320.0, 320.0),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontFamily: "Orbitron",
                fontSize: 20.0,
                color: Color(0xffffffff),
              ),
              child: Stack(
                children: <Widget>[
                  const MainSceneBackground(),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: 320.0,
                        height: 98.0,
                        child: TopBar(
                          gameState: widget.gameState,
                        ),
                      ),
                      Expanded(
                        child: CenterArea(
                          onUpgradeLaser: widget.onUpgradeLaser,
                          onUpgradePowerUp: widget.onUpgradePowerUp,
                          gameState: widget.gameState,
                        ),
                      ),
                      SizedBox(
                        width: 320.0,
                        height: 93.0,
                        child: BottomBar(
                          onPlay: () {
                            Navigator.pushNamed(context, '/game');
                            sounds.playMusic('music_game');
                          },
                          onPlayEvent: () {
                            Navigator.pushNamed(context, '/event');
                            sounds.playMusic('music_game');
                          },
                          onStartLevelUp: widget.onStartLevelUp,
                          onStartLevelDown: widget.onStartLevelDown,
                          gameState: widget.gameState,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}