import 'package:flutter/material.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/l10n/generated/app_localizations.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/view/widgets.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    required this.gameState,
    required this.onLocaleChanged,
    Key? key,
  }) : super(key: key);

  final PersistantGameState gameState;
  final ValueChanged<String> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
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
          child: Text(l10n.lastScore, style: scoreLabelStyle),
        ),
        Positioned(
          left: 18.0,
          top: 39.0,
          child: Text(l10n.bestScore, style: scoreLabelStyle),
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
          child: ValueListenableBuilder<int>(
            valueListenable: gameState.coinsNotifier,
            builder: (context, coins, _) => Text(
              '$coins',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: darkTextColor,
              ),
            ),
          ),
        ),
        Positioned(
          right: 12.0,
          top: 66.0,
          child: Material(
            color: Colors.transparent,
            child: PopupMenuButton<String>(
              tooltip: l10n.language,
              onSelected: onLocaleChanged,
              itemBuilder: (context) => [
                PopupMenuItem(value: 'en', child: Text(l10n.english)),
                PopupMenuItem(value: 'vi', child: Text(l10n.vietnamese)),
                PopupMenuItem(
                  value: 'system',
                  child: Text(l10n.useDeviceLanguage),
                ),
              ],
              child: Container(
                width: 68,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.72),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: darkTextColor.withOpacity(0.35)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.language, size: 14, color: darkTextColor),
                    const SizedBox(width: 3),
                    Text(
                      languageCode.toUpperCase(),
                      style: const TextStyle(
                        color: darkTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
