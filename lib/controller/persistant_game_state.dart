

import 'dart:convert';

import 'package:mini__game2/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

//cấu hình trạng thái cho game
class PersistantGameState {
  Future load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('game_prefs'); //Lấy data từ bộ nhớ thư mục máy
    if (json == null) return;

    JsonDecoder decoder = const JsonDecoder();
    Map data = decoder.convert(json); //convert json

    coins = data['coins']; //Điểm
    _powerupLevels = data['powerUpLevels'].cast<int>(); //cấp độ sức mạnh
    _currentStartingLevel = data['currentStartingLevel']; //cấp độ hiện tại
    maxStartingLevel = data['maxStartingLevel']; //mức khởi đầu tối đa
    laserLevel = data['laserLevel']; // cấp độ vũ khí
    _lastScore = data['lastScore']; // điểm cuối cùng được lưu
    weeklyBestScore = data['bestScore']; // điểm cao nhất trong tuần
  }

  Future store() async {
    final prefs = await SharedPreferences.getInstance();

    Map data = {
      'coins': coins,
      'powerUpLevels': _powerupLevels,
      'currentStartingLevel': _currentStartingLevel,
      'maxStartingLevel': maxStartingLevel,
      'laserLevel': laserLevel,
      'lastScore': _lastScore,
      'bestScore': weeklyBestScore
    };
    JsonEncoder encoder = const JsonEncoder();
    String json = encoder.convert(data);
    prefs.setString('game_prefs', json);
  }

  int coins = 0;

  List<int> _powerupLevels = <int>[0, 0, 0, 0];

  int powerupLevel(PowerUpType type) {
    return _powerupLevels[type.index];
  }

  int maxPowerUpLevel = 8;

  int _currentStartingLevel = 0;

  int get currentStartingLevel => _currentStartingLevel;

  set currentStartingLevel(int currentStartingLevel) {
    if (currentStartingLevel >= 0 && currentStartingLevel <= maxStartingLevel) {
      _currentStartingLevel = currentStartingLevel;
    }
  }

  int maxStartingLevel = 3;

  int laserLevel = 3;

  int maxLaserLevel = 11;

  int _lastScore = 0;

  int get lastScore => _lastScore;

  set lastScore(int lastScore) {
    _lastScore = lastScore;
    if (lastScore > weeklyBestScore) weeklyBestScore = lastScore;
  }

  int weeklyBestScore = 0;

  int powerUpUpgradePrice(PowerUpType type) {
    //mức gia tắng sức mạnh
    int level = powerupLevel(type) + 1; 
    return level * 50 + 50;
  }

  int powerUpFrames(PowerUpType type) {
    //Khung sức mạnh được tăng
    int level = powerupLevel(type);

    if (type == PowerUpType.speedBoost) { //tốc độ
      return 150 + 25 * level;
    } else {
      return 300 + 50 * level;
    }
  }

  bool upgradePowerUp(PowerUpType type) {
    // Tăng thêm sức mạnh 
    int price = powerUpUpgradePrice(type);

    if (coins >= price && _powerupLevels[type.index] < maxPowerUpLevel) {
      coins -= price;
      _powerupLevels[type.index] += 1;
      store();
      return true;
    } else {
      return false;
    }
  }

  int laserUpgradePrice() {
    //nâng cấp súc mạnh lase
    return laserLevel * 6600 + 20000;
  }

  bool upgradeLaser() {
    if (coins >= laserUpgradePrice() && laserLevel < maxLaserLevel) {
      coins -= laserUpgradePrice();
      laserLevel++;
      store();
      return true;
    } else {
      return false;
    }
  }

  void reachedLevel(int level) {
    if (level > maxStartingLevel && level < 9) {
      maxStartingLevel = level;
      _currentStartingLevel = level;
    }
    store();
  }
}
