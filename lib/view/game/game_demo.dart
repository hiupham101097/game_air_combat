import 'package:flutter/material.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/quest.dart';
import 'package:mini__game2/view/game/game_score.dart';
import 'package:mini__game2/view/main/main_view.dart';
import 'package:mini__game2/view/main/inventory_screen.dart';
import 'package:mini__game2/view/main/quests_screen.dart';
import 'package:mini__game2/view/main/leaderboard_screen.dart';
import 'package:mini__game2/view/main/login_screen.dart';
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
                case '/event':
                  return _buildEventSceneRoute();
                case '/inventory':
                  return MaterialPageRoute(builder: (context) => const InventoryScreen());
                case '/quests':
                  return MaterialPageRoute(builder: (context) => const QuestsScreen());
                case '/leaderboard':
                  return MaterialPageRoute(builder: (context) => const LeaderboardScreen());
                case '/account':
                  return MaterialPageRoute(builder: (context) => const LoginScreen());
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
              gameState.updateQuestProgress(QuestType.playGames, 1);
              gameState.updateQuestProgress(QuestType.collectCoins, coins);
            });
          },
          gameState: gameState);
    });
  }

  PageRoute _buildEventSceneRoute() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return GameScene(
          isEventMode: true,
          onGameOver: (int lastScore, int coins, int levelReached) {
            setState(() {
              // Bonus coin reward for completing Event Mode
              gameState.lastScore = lastScore;
              gameState.coins += (coins * 1.5).toInt(); // 50% bonus
              gameState.reachedLevel(levelReached);
              gameState.updateQuestProgress(QuestType.playGames, 1);
              gameState.updateQuestProgress(QuestType.collectCoins, coins);
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