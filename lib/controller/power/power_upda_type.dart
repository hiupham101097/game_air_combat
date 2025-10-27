

import 'package:mini__game2/main.dart';

List<PowerUpType> _powerUpTypes = List<PowerUpType>.from(PowerUpType.values);
int _lastPowerUp = _powerUpTypes.length;

PowerUpType nextPowerUpType() {
  if (_lastPowerUp >= _powerUpTypes.length) {
    _powerUpTypes.shuffle();
    _lastPowerUp = 0;
  }

  PowerUpType type = _powerUpTypes[_lastPowerUp];
  _lastPowerUp++;

  return type;
}
