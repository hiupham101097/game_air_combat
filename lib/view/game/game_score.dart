
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_demo_node.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/main.dart';
import 'package:spritewidget/spritewidget.dart';

class GameScene extends StatefulWidget {
  const GameScene({
    this.onGameOver,
    this.gameState,
    this.isEventMode = false,
    Key? key,
  }) : super(key: key);

  final GameOverCallback? onGameOver;
  final PersistantGameState? gameState;
  final bool isEventMode;

  @override
  State<GameScene> createState() => GameSceneState();
}

class GameSceneState extends State<GameScene> {
  late GameDemoNode _game;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    _game = GameDemoNode(
      imageMap,
      spriteSheet,
      spriteSheetUI,
      sounds,
      widget.gameState!,
      widget.isEventMode,
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

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _game.pause();
      } else {
        _game.resume();
      }
    });
  }

  void _quitGame() {
    _game.resume();
    Navigator.pop(context);
    sounds.playMusic('music_intro');
    if (widget.onGameOver != null) {
      widget.onGameOver!(0, 0, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Game canvas ──────────────────────────────────────────────
        SpriteWidget(
          _game,
          transformMode: SpriteBoxTransformMode.fixedWidth,
        ),

        // ── Pause button (top-right corner) ──────────────────────────
        Positioned(
          top: 12,
          right: 12,
          child: SafeArea(
            child: GestureDetector(
              onTap: _togglePause,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(160),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 1),
                ),
                child: Icon(
                  _isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ),

        // ── Pause overlay ─────────────────────────────────────────────
        if (_isPaused)
          Container(
            color: Colors.black.withAlpha(180),
            child: Center(
              child: Container(
                width: 260,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                decoration: BoxDecoration(
                  color: const Color(0xFF0d0d2b),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.cyanAccent.withAlpha(100), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withAlpha(30),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      'TẠM DỪNG',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        color: Colors.cyanAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 1,
                      color: Colors.cyanAccent.withAlpha(80),
                    ),
                    const SizedBox(height: 28),

                    // Resume button
                    _PauseMenuButton(
                      label: 'TIẾP TỤC',
                      icon: Icons.play_arrow,
                      color: Colors.cyanAccent,
                      onTap: _togglePause,
                    ),
                    const SizedBox(height: 14),

                    // Quit button
                    _PauseMenuButton(
                      label: 'THOÁT',
                      icon: Icons.exit_to_app,
                      color: Colors.redAccent,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            backgroundColor: const Color(0xFF0d0d2b),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: const Text('Thoát game?',
                                style: TextStyle(
                                    fontFamily: 'Orbitron',
                                    color: Colors.white,
                                    fontSize: 16)),
                            content: const Text(
                              'Trận đấu sẽ bị kết thúc và điểm sẽ không được lưu.',
                              style: TextStyle(color: Colors.white60, fontSize: 13),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Ở LẠI',
                                    style: TextStyle(
                                        fontFamily: 'Orbitron',
                                        color: Colors.cyanAccent)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext); // close dialog
                                  _quitGame();
                                },
                                child: const Text('THOÁT',
                                    style: TextStyle(
                                        fontFamily: 'Orbitron',
                                        color: Colors.redAccent)),
                              ),
                            ],
                          ),
                        );
                      },
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

class _PauseMenuButton extends StatelessWidget {
  const _PauseMenuButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(180), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Orbitron',
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}