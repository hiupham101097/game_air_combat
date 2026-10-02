import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_demo_node.dart';
import 'package:mini__game2/controller/player_state.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/controller/rewarded_ad_service.dart';
import 'package:mini__game2/l10n/generated/app_localizations.dart';
import 'package:mini__game2/l10n/game_localizations.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/run_upgrade.dart';
import 'package:spritewidget/spritewidget.dart';

class GameScene extends StatefulWidget {
  const GameScene({
    this.onGameOver,
    this.gameState,
    required this.localizations,
    this.isEventMode = false,
    Key? key,
  }) : super(key: key);

  final GameOverCallback? onGameOver;
  final PersistantGameState? gameState;
  final AppLocalizations localizations;
  final bool isEventMode;

  @override
  State<GameScene> createState() => GameSceneState();
}

class GameSceneState extends State<GameScene> {
  late GameDemoNode _game;
  bool _isPaused = false;
  List<BossBuffReward>? _bossBuffChoices;
  int? _runUpgradeLevel;
  List<RunUpgradeReward>? _runUpgradeChoices;
  bool _showReviveOffer = false;
  bool _powerAdUsed = false;
  bool _showingRewardedAd = false;

  @override
  void initState() {
    super.initState();

    _game = GameDemoNode(
      imageMap,
      spriteSheet,
      spriteSheetUI,
      enemyProjectileAnimations,
      sounds,
      widget.gameState!,
      widget.isEventMode,
      widget.localizations,
      (
        int score,
        int coins,
        int levelReached,
      ) {
        Navigator.pop(context);
        widget.onGameOver!(score, coins, levelReached);
        sounds.playMusic('music_intro');
      },
      onBossBuff: (choices) {
        if (!mounted) return;
        _game.pause();
        setState(() => _bossBuffChoices = choices);
      },
      onRunLevelUp: (level, choices) {
        if (!mounted) return;
        sounds.playEffect('levelup');
        _game.pause();
        setState(() {
          _runUpgradeLevel = level;
          _runUpgradeChoices = choices;
        });
      },
      onReviveOffer: () {
        if (mounted) setState(() => _showReviveOffer = true);
      },
    );
  }

  Future<void> _watchReviveAd() async {
    if (_showingRewardedAd) return;
    setState(() => _showingRewardedAd = true);
    final earned = await RewardedAdService.instance.showRewardedAd();
    if (!mounted) return;
    setState(() {
      _showingRewardedAd = false;
      _showReviveOffer = false;
    });
    if (earned) {
      _game.reviveFromRewardedAd();
    } else {
      _game.endRun();
    }
  }

  Future<void> _watchPowerAd() async {
    if (_powerAdUsed || _showingRewardedAd) return;
    setState(() => _showingRewardedAd = true);
    final earned = await RewardedAdService.instance.showRewardedAd();
    if (!mounted) return;
    setState(() {
      _showingRewardedAd = false;
      if (earned) _powerAdUsed = true;
    });
    if (earned) _game.grantRewardedAdPowerBoost();
  }

  void _chooseBossBuff(BossBuffReward reward) {
    // A double tap can arrive before Flutter removes the choice panel.
    // Accept only the first selection and resume the game once.
    if (_bossBuffChoices == null) return;
    setState(() => _bossBuffChoices = null);
    final runUpgradeIsNext = _game.chooseBossBuff(reward);
    if (!runUpgradeIsNext && !_isPaused) _game.resume();
  }

  void _chooseRunUpgrade(RunUpgradeReward reward) {
    if (_runUpgradeChoices == null) return;
    setState(() {
      _runUpgradeChoices = null;
      _runUpgradeLevel = null;
    });
    final anotherChoiceIsNext = _game.chooseRunUpgrade(reward);
    if (!anotherChoiceIsNext && !_isPaused) _game.resume();
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        body: Stack(
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
        ValueListenableBuilder<int>(
          valueListenable: _game.riftChargeNotifier,
          builder: (context, charge, _) {
            final ready = charge >= 100;
            return Positioned(
              right: 14,
              bottom: 22,
              child: SafeArea(
                top: false,
                left: false,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: ready && !_showReviveOffer && _bossBuffChoices == null
                      ? _game.activateRiftBurst
                      : null,
                  child: Container(
                    width: 126,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xE6101730),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: ready ? const Color(0xFFB56CFF) : Colors.white24,
                        width: ready ? 1.6 : 1,
                      ),
                      boxShadow: ready
                          ? [
                              BoxShadow(
                                color: const Color(0xFF9B5CFF).withAlpha(110),
                                blurRadius: 16,
                                spreadRadius: 1,
                              ),
                            ]
                          : const [],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome,
                                color: ready
                                    ? const Color(0xFFD8A2FF)
                                    : Colors.white54,
                                size: 15),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!.riftBurst,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ready ? Colors.white : Colors.white70,
                                  fontFamily: 'Orbitron',
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: charge / 100,
                            minHeight: 4,
                            backgroundColor: Colors.white12,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ready
                                  ? const Color(0xFFD18BFF)
                                  : const Color(0xFF6B56C8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          ready
                              ? AppLocalizations.of(context)!.riftBurstReady
                              : '$charge%',
                          style: TextStyle(
                            color: ready
                                ? const Color(0xFFD8A2FF)
                                : Colors.white60,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        ValueListenableBuilder<int>(
          valueListenable: _game.phaseShiftCooldown,
          builder: (context, cooldown, _) {
            final ready = cooldown == 0;
            const accent = Color(0xFF55E8FF);
            return Positioned(
              right: 14,
              bottom: 82,
              child: SafeArea(
                top: false,
                left: false,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: ready && !_showReviveOffer && _bossBuffChoices == null
                      ? _game.activatePhaseShift
                      : null,
                  child: Container(
                    width: 126,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xE6101730),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: ready ? accent : Colors.white24,
                        width: ready ? 1.5 : 1,
                      ),
                      boxShadow: ready
                          ? [
                              BoxShadow(
                                color: accent.withAlpha(90),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ]
                          : const [],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bolt,
                                color: ready ? accent : Colors.white54,
                                size: 16),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!.phaseShift,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ready ? Colors.white : Colors.white70,
                                  fontFamily: 'Orbitron',
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ready
                              ? AppLocalizations.of(context)!.phaseShiftReady
                              : '${cooldown}s',
                          style: TextStyle(
                            color: ready ? accent : Colors.white60,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        if (_isPaused)
          Container(
            color: Colors.black.withAlpha(180),
            child: Center(
              child: Container(
                width: 260,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                decoration: BoxDecoration(
                  color: const Color(0xFF0d0d2b),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Colors.cyanAccent.withAlpha(100), width: 1.5),
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
                    Text(
                      l10n.pauseTitle,
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
                      label: l10n.resume,
                      icon: Icons.play_arrow,
                      color: Colors.cyanAccent,
                      onTap: _togglePause,
                    ),
                    const SizedBox(height: 14),

                    if (!_powerAdUsed) ...[
                      _PauseMenuButton(
                        label:
                            _showingRewardedAd ? l10n.loading : l10n.powerBoost,
                        icon: Icons.play_circle_outline,
                        color: Colors.amberAccent,
                        onTap: _watchPowerAd,
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Quit button
                    _PauseMenuButton(
                      label: l10n.quit,
                      icon: Icons.exit_to_app,
                      color: Colors.redAccent,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            backgroundColor: const Color(0xFF0d0d2b),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: Text(l10n.quitTitle,
                                style: TextStyle(
                                    fontFamily: 'Orbitron',
                                    color: Colors.white,
                                    fontSize: 16)),
                            content: Text(
                              l10n.quitWarning,
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 13),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text(l10n.resume,
                                    style: const TextStyle(
                                        fontFamily: 'Orbitron',
                                        color: Colors.cyanAccent)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext); // close dialog
                                  _quitGame();
                                },
                                child: Text(l10n.quit,
                                    style: const TextStyle(
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
        if (_bossBuffChoices != null)
          Positioned.fill(
            child: _BossBuffPanel(
              choices: _bossBuffChoices!,
              onSelected: _chooseBossBuff,
            ),
          ),
        if (_runUpgradeChoices != null)
          Positioned.fill(
            child: _RunUpgradePanel(
              level: _runUpgradeLevel ?? 1,
              choices: _runUpgradeChoices!,
              onSelected: _chooseRunUpgrade,
            ),
          ),
        if (_showReviveOffer)
          Positioned.fill(
            child: _RewardedRevivePanel(
              isLoading: _showingRewardedAd,
              onWatch: _watchReviveAd,
              onEndRun: () {
                setState(() => _showReviveOffer = false);
                _game.endRun();
              },
            ),
          ),
      ],
    ));
  }
}

class _RewardedRevivePanel extends StatelessWidget {
  const _RewardedRevivePanel({
    required this.isLoading,
    required this.onWatch,
    required this.onEndRun,
  });

  final bool isLoading;
  final VoidCallback onWatch;
  final VoidCallback onEndRun;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.black.withAlpha(210),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D2B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.cyanAccent),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(l10n.revive,
              style: TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 8),
          Text(l10n.reviveDescription,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: isLoading ? null : onWatch,
            child: Text(isLoading ? l10n.loading : l10n.watchAd),
          ),
          TextButton(
            onPressed: isLoading ? null : onEndRun,
            child: Text(l10n.home),
          ),
        ]),
      ),
    );
  }
}

class _BossBuffPanel extends StatelessWidget {
  const _BossBuffPanel({required this.choices, required this.onSelected});

  final List<BossBuffReward> choices;
  final ValueChanged<BossBuffReward> onSelected;

  Color _colorFor(BossBuffReward reward) => switch (reward.type) {
        BossBuffType.green => const Color(0xFF55E88B),
        BossBuffType.purple => const Color(0xFFC77DFF),
        BossBuffType.gold => const Color(0xFFFFD54F),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.black.withAlpha(185),
      alignment: Alignment.center,
      child: Container(
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 28),
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
        decoration: BoxDecoration(
          color: const Color(0xEE0D0D2B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.cyanAccent, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.cyanAccent.withAlpha(90), blurRadius: 28)
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.bossDefeated,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Orbitron',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1)),
            const SizedBox(height: 10),
            Text(l10n.chooseBuff,
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 16),
            ...choices.map((reward) {
              final color = _colorFor(reward);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onSelected(reward),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.withAlpha(35),
                      foregroundColor: color,
                      side: BorderSide(color: color),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Column(children: [
                      Text(_labelFor(reward, l10n),
                          style: const TextStyle(
                              fontFamily: 'Orbitron',
                              fontWeight: FontWeight.bold)),
                      Text(_descriptionFor(reward, l10n),
                          style: const TextStyle(color: Colors.white)),
                    ]),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _labelFor(BossBuffReward reward, AppLocalizations l10n) =>
      switch (reward.type) {
        BossBuffType.green => l10n.damageBuffTitle,
        BossBuffType.purple => l10n.fireRateBuffTitle,
        BossBuffType.gold => l10n.rareDamageBuffTitle,
      };

  String _descriptionFor(BossBuffReward reward, AppLocalizations l10n) =>
      switch (reward.type) {
        BossBuffType.green => l10n.damageBuff(reward.percent),
        BossBuffType.purple => l10n.fireRateBuff(reward.percent),
        BossBuffType.gold => l10n.damageBuff(reward.percent),
      };
}

class _RunUpgradePanel extends StatelessWidget {
  const _RunUpgradePanel({
    required this.level,
    required this.choices,
    required this.onSelected,
  });

  final int level;
  final List<RunUpgradeReward> choices;
  final ValueChanged<RunUpgradeReward> onSelected;

  IconData _iconFor(RunUpgradeType type) => switch (type) {
        RunUpgradeType.weaponDamage => Icons.flash_on,
        RunUpgradeType.fireRate => Icons.speed,
        RunUpgradeType.multishot => Icons.blur_on,
        RunUpgradeType.critical => Icons.gps_fixed,
        RunUpgradeType.thrusters => Icons.rocket_launch,
        RunUpgradeType.hull => Icons.shield,
        RunUpgradeType.repair => Icons.healing,
        RunUpgradeType.riftCharge => Icons.auto_awesome,
        RunUpgradeType.shield => Icons.security,
      };

  Color _colorFor(RunUpgradeType type) => switch (type) {
        RunUpgradeType.weaponDamage ||
        RunUpgradeType.fireRate =>
          const Color(0xFFFFB84D),
        RunUpgradeType.multishot ||
        RunUpgradeType.critical =>
          const Color(0xFF69E5FF),
        RunUpgradeType.thrusters ||
        RunUpgradeType.riftCharge =>
          const Color(0xFFBE8CFF),
        RunUpgradeType.hull ||
        RunUpgradeType.repair ||
        RunUpgradeType.shield =>
          const Color(0xFF71F0B5),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final panelWidth = (MediaQuery.sizeOf(context).width - 40.0).clamp(
      280.0,
      380.0,
    );
    return Container(
      color: Colors.black.withAlpha(205),
      alignment: Alignment.center,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Container(
            width: panelWidth,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
            decoration: BoxDecoration(
              color: const Color(0xF00A1428),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF55E8FF), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF55E8FF).withAlpha(65),
                  blurRadius: 28,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.upgrade, color: Color(0xFF55E8FF), size: 30),
                const SizedBox(height: 8),
                Text(
                  l10n.runUpgradeTitle(level),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Orbitron',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  l10n.runUpgradeSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 14),
                ...choices.map((reward) {
                  final color = _colorFor(reward.type);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: color.withAlpha(22),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => onSelected(reward),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 11),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: color.withAlpha(170)),
                          ),
                          child: Row(
                            children: [
                              Icon(_iconFor(reward.type),
                                  color: color, size: 23),
                              const SizedBox(width: 11),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.runUpgradeName(reward.type),
                                      style: TextStyle(
                                        color: color,
                                        fontFamily: 'Orbitron',
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      l10n.runUpgradeDescription(reward.type),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: Colors.white54),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
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
