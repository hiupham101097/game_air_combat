import 'package:flutter/material.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
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
    return _buildCenterArea();
  }

  Widget _buildCenterArea() {
    return _buildUpgradePanel();
  }

  Widget _buildUpgradePanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: const Key("upgradePanel"),
      children: <Widget>[
        const Text("Nâng cấp laze", style: TextStyle(fontSize: 14),),
        _buildLaserUpgradeButton(),
        const Text("Nâng cấp sức mạnh", style: TextStyle(fontSize: 14),),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          _buildPowerUpButton(PowerUpType.shield),
          _buildPowerUpButton(PowerUpType.sideLaser),
          _buildPowerUpButton(PowerUpType.speedBoost),
          _buildPowerUpButton(PowerUpType.speedLaser),
        ])
      ],
    );
  }

  Widget _buildPowerUpButton(PowerUpType type) {
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
              child: Text("Lvl ${gameState.powerupLevel(type) + 10}",
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