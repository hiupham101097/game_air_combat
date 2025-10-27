import 'package:flutter/material.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/view/game/game_score.dart';
import 'package:mini__game2/view/main/main_view.dart';
import 'package:mini__game2/view/widgets.dart';

class GameDemo extends StatefulWidget {
  const GameDemo({Key? key}) : super(key: key);

  @override
  GameDemoState createState() => GameDemoState();
}

class GameDemoState extends State<GameDemo> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Title(
        title: 'Space Blast',
        color: const Color(0xFF9900FF),
        child: AppFrame(
          child: Navigator(
            key: _navigatorKey,
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/game':
                  return _buildGameSceneRoute();
                default:
                  return _buildMainSceneRoute();
              }
            },
          ),
        ),
      ),
    );
  }

  PageRoute _buildGameSceneRoute() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return GameScene(
          onGameOver: (int lastScore, int coins, int levelReached) {
            setState(() {
              gameState.lastScore = lastScore;
              gameState.coins += coins;
              gameState.reachedLevel(levelReached);
            });
          },
          gameState: gameState);
    });
  }

  PageRoute _buildMainSceneRoute() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return MainScene(
        gameState: gameState,
        onUpgradePowerUp: (PowerUpType type) {
          setState(() {
            if (gameState.upgradePowerUp(type)) {
              sounds.playEffect('buy_upgrade');
            } else {
              sounds.playEffect('click');
            }
          });
        },
        onUpgradeLaser: () {
          setState(() {
            if (gameState.upgradeLaser()) {
              sounds.playEffect('buy_upgrade');
            } else {
              sounds.playEffect('click');
            }
          });
        },
        onStartLevelUp: () {
          setState(() {
            gameState.currentStartingLevel++;
            sounds.playEffect('click');
          });
        },
        onStartLevelDown: () {
          setState(() {
            gameState.currentStartingLevel--;
            sounds.playEffect('click');
          });
        },
      );
    });
  }
}