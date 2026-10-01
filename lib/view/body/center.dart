import 'package:flutter/material.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/l10n/generated/app_localizations.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/view/body/display.dart';
import 'package:mini__game2/view/widgets.dart';

class CenterArea extends StatelessWidget {
  const CenterArea({
    // required this.selection,
    required this.onUpgradeLaser,
    required this.gameState,
    required this.onUpgradePowerUp,
    Key? key,
  }) : super(key: key);

  // final int selection;
  final VoidCallback onUpgradeLaser;
  final UpgradePowerUpCallback onUpgradePowerUp;
  final PersistantGameState gameState;

  @override
  Widget build(BuildContext context) {
    return _buildCenterArea(context);
  }

  Widget _buildCenterArea(BuildContext context) {
    return _buildUpgradePanel(context);
  }

  Widget _buildUpgradePanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: const Key("upgradePanel"),
      children: <Widget>[
        Text(
          l10n.upgradeLaser,
          style: TextStyle(fontSize: 14),
        ),
        _buildLaserUpgradeButton(),
        Text(
          l10n.upgradePowerups,
          style: TextStyle(fontSize: 14),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          _buildPowerUpButton(context, PowerUpType.shield),
          _buildPowerUpButton(context, PowerUpType.sideLaser),
          _buildPowerUpButton(context, PowerUpType.speedBoost),
          _buildPowerUpButton(context, PowerUpType.speedLaser),
        ]),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMenuButton(
                context, l10n.inventory, '/inventory', Colors.blue),
            _buildMenuButton(context, l10n.quests, '/quests', Colors.orange),
            _buildMenuButton(
                context, l10n.leaderboard, '/leaderboard', Colors.purple),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(context, l10n.account, '/account', Colors.green),
            _buildMenuButton(context, l10n.story, '/story', Colors.cyan),
          ],
        )
      ],
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String title, String route, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 10,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPowerUpButton(BuildContext context, PowerUpType type) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextureButton(
            texture: spriteSheetUI['btn_powerup_${type.index}.png']!,
            width: 50.0,
            height: 50.0,
            label: "${gameState.powerUpUpgradePrice(type)}",
            labelOffset: const Offset(2.0, 20.5),
            textStyle: const TextStyle(
                fontFamily: "Orbitron", fontSize: 9.0, color: darkTextColor),
            textAlign: TextAlign.center,
            onPressed: () => onUpgradePowerUp(type),
          ),
          Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(l10n.powerUpLevel(gameState.powerupLevel(type) + 1),
                  style: const TextStyle(fontSize: 10.0)))
        ],
      ),
    );
  }

  Widget _buildLaserUpgradeButton() {
    return SizedBox(
      child: Stack(
        children: <Widget>[
          TextureButton(
            texture: spriteSheetUI['btn_laser_upgrade.png']!,
            width: 117.0,
            height: 53.0,
            label: "${gameState.laserUpgradePrice()}",
            labelOffset: const Offset(2.0, 20.0),
            textStyle: const TextStyle(
                fontFamily: "Orbitron", fontSize: 12.0, color: darkTextColor),
            textAlign: TextAlign.center,
            onPressed: onUpgradeLaser,
          ),
          Positioned(
            left: 15.5,
            top: 10.0,
            child: LaserDisplay(level: gameState.laserLevel),
          ),
          Positioned(
            right: 15.5,
            top: 10.0,
            child: LaserDisplay(level: gameState.laserLevel + 1),
          )
        ],
      ),
    );
  }
}
