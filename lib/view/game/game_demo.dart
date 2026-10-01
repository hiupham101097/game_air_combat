import 'package:flutter/material.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/quest.dart';
import 'package:mini__game2/model/ship_model.dart';
import 'package:mini__game2/l10n/generated/app_localizations.dart';
import 'package:mini__game2/view/game/game_score.dart';
import 'package:mini__game2/view/main/main_view.dart';
import 'package:mini__game2/view/main/inventory_screen.dart';
import 'package:mini__game2/view/main/quests_screen.dart';
import 'package:mini__game2/view/main/leaderboard_screen.dart';
import 'package:mini__game2/view/main/login_screen.dart';
import 'package:mini__game2/view/main/story_screen.dart';
import 'package:mini__game2/view/widgets.dart';

class GameDemo extends StatefulWidget {
  const GameDemo({required this.onLocaleChanged, Key? key}) : super(key: key);

  final ValueChanged<String> onLocaleChanged;

  @override
  GameDemoState createState() => GameDemoState();
}

class GameDemoState extends State<GameDemo> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _unlockSuperFighterAtCampaignMilestone(int levelReached) {
    if (levelReached < 9) return;
    final shipIndex = ShipConfig.ships
        .indexWhere((ship) => ship.model == ShipModel.superFighter);
    if (shipIndex >= 0 && !gameState.unlockedShips.contains(shipIndex)) {
      gameState.unlockedShips.add(shipIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Title(
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
                return MaterialPageRoute(
                    builder: (context) => const InventoryScreen());
              case '/quests':
                return MaterialPageRoute(
                    builder: (context) => const QuestsScreen());
              case '/leaderboard':
                return MaterialPageRoute(
                    builder: (context) => const LeaderboardScreen());
              case '/account':
                return MaterialPageRoute(
                    builder: (context) => const LoginScreen());
              case '/story':
                return MaterialPageRoute(
                    builder: (context) => const StoryScreen());
              default:
                return _buildMainSceneRoute();
            }
          },
        ),
      ),
    );
  }

  PageRoute _buildGameSceneRoute() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return GameScene(
          localizations: AppLocalizations.of(context)!,
          onGameOver: (int lastScore, int coins, int levelReached) {
            setState(() {
              gameState.lastScore = lastScore;
              gameState.coins += coins;
              _unlockSuperFighterAtCampaignMilestone(levelReached);
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
          localizations: AppLocalizations.of(context)!,
          isEventMode: true,
          onGameOver: (int lastScore, int coins, int levelReached) {
            setState(() {
              // Bonus coin reward for completing Event Mode
              gameState.lastScore = lastScore;
              gameState.coins += (coins * 1.5).toInt(); // 50% bonus
              _unlockSuperFighterAtCampaignMilestone(levelReached);
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
        onLocaleChanged: widget.onLocaleChanged,
      );
    });
  }
}
