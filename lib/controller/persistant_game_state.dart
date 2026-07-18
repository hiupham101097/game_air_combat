import 'dart:convert';

import 'package:mini__game2/controller/cloud_sync_service.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/quest.dart';
import 'package:shared_preferences/shared_preferences.dart';

//cấu hình trạng thái cho game
class PersistantGameState {
  static const int _progressionVersion = 2;

  Future load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr =
        prefs.getString('game_prefs'); //Lấy data từ bộ nhớ thư mục máy
    var resetProgression = false;
    if (jsonStr != null) {
      JsonDecoder decoder = const JsonDecoder();
      Map data = decoder.convert(jsonStr); //convert json
      if (data['progressionVersion'] == _progressionVersion) {
        _fromJson(data);
      } else {
        _resetProgression();
        resetProgression = true;
      }
    }

    _checkDailyReset();
    if (resetProgression) await store();
  }

  void _fromJson(Map data) {
    coins = data['coins'] ?? 0;
    energyStones = data['energyStones'] ?? 0;
    energyCores = data['energyCores'] ?? 0;
    gachaPity = data['gachaPity'] ?? 0;
    _powerupLevels =
        data['powerUpLevels']?.cast<int>() ?? <int>[0, 0, 0, 0, 0, 0, 0];
    // Pad old saves that only had 4 entries to the new length of 7
    while (_powerupLevels.length < 7) {
      _powerupLevels.add(0);
    }
    _currentStartingLevel = data['currentStartingLevel'] ?? 0;
    maxStartingLevel = data['maxStartingLevel'] ?? 0;
    laserLevel = data['laserLevel'] ?? 0;
    _lastScore = data['lastScore'] ?? 0;
    weeklyBestScore = data['bestScore'] ?? 0;

    unlockedWeapons = data['unlockedWeapons']?.cast<int>() ?? [0];
    equippedWeapon = data['equippedWeapon'] ?? 0;
    lastLoginDate = data['lastLoginDate'] ?? "";
    unlockedShips = data['unlockedShips']?.cast<int>() ?? [0];
    equippedShip = data['equippedShip'] ?? 0;

    if (data['dailyQuests'] != null) {
      dailyQuests = (data['dailyQuests'] as List)
          .map((q) => DailyQuest.fromJson(q))
          .toList();
    } else {
      _generateDailyQuests();
    }

    ownedEquipment = data['ownedEquipment']?.cast<String>() ?? <String>[];
    if (data['equippedLoadout'] != null) {
      equippedLoadout = Map<String, String>.from(data['equippedLoadout']);
    } else {
      equippedLoadout = <String, String>{};
    }
    if (data['equipmentLevels'] != null) {
      equipmentLevels = Map<String, int>.from(data['equipmentLevels']);
    } else {
      equipmentLevels = <String, int>{};
    }

  }

  void _resetProgression() {
    coins = 0;
    energyStones = 0;
    energyCores = 0;
    gachaPity = 0;
    _powerupLevels = <int>[0, 0, 0, 0, 0, 0, 0];
    _currentStartingLevel = 0;
    maxStartingLevel = 0;
    laserLevel = 0;
    _lastScore = 0;
    weeklyBestScore = 0;
    unlockedWeapons = <int>[0];
    equippedWeapon = 0;
    unlockedShips = <int>[0];
    equippedShip = 0;
    ownedEquipment = <String>[];
    equippedLoadout = <String, String>{};
    equipmentLevels = <String, int>{};
    lastLoginDate = '';
    _generateDailyQuests();
  }

  Map<String, dynamic> toJson() {
    return {
      'progressionVersion': _progressionVersion,
      'coins': coins,
      'energyStones': energyStones,
      'energyCores': energyCores,
      'gachaPity': gachaPity,
      'powerUpLevels': _powerupLevels,
      'currentStartingLevel': _currentStartingLevel,
      'maxStartingLevel': maxStartingLevel,
      'laserLevel': laserLevel,
      'lastScore': _lastScore,
      'bestScore': weeklyBestScore,
      'unlockedWeapons': unlockedWeapons,
      'equippedWeapon': equippedWeapon,
      'lastLoginDate': lastLoginDate,
      'unlockedShips': unlockedShips,
      'equippedShip': equippedShip,
      'dailyQuests': dailyQuests.map((q) => q.toJson()).toList(),
      'ownedEquipment': ownedEquipment,
      'equippedLoadout': equippedLoadout,
      'equipmentLevels': equipmentLevels,
    };
  }

  Future store() async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> data = toJson();
    JsonEncoder encoder = const JsonEncoder();
    String jsonStr = encoder.convert(data);
    prefs.setString('game_prefs', jsonStr);

    // Sync to cloud in the background
    CloudSyncService().pushData(data);
  }

  Future syncFromCloud() async {
    final cloudData = await CloudSyncService().pullData();
    if (cloudData != null &&
        cloudData['progressionVersion'] == _progressionVersion) {
      _fromJson(cloudData);
      // Save downloaded data to local storage
      await store();
    }
  }

  int coins = 0;

  List<int> unlockedWeapons = <int>[0];
  int equippedWeapon = 0;

  List<int> unlockedShips = <int>[0];
  int equippedShip = 0;

  String lastLoginDate = "";

  List<String> ownedEquipment = <String>[];
  Map<String, String> equippedLoadout = <String, String>{};
  Map<String, int> equipmentLevels = <String, int>{}; // ID -> Level

  int energyStones = 0;
  int energyCores = 0;
  int gachaPity = 0;

  List<DailyQuest> dailyQuests = [];

  // 7 entries matching PowerUpType.values (shield, speedLaser, sideLaser, speedBoost, heal, magnet, nuke)
  List<int> _powerupLevels = <int>[0, 0, 0, 0, 0, 0, 0];

  int powerupLevel(PowerUpType type) {
    int idx = type.index.clamp(0, _powerupLevels.length - 1);
    return _powerupLevels[idx];
  }

  int maxPowerUpLevel = 8;

  int _currentStartingLevel = 0;

  int get currentStartingLevel => _currentStartingLevel;

  set currentStartingLevel(int currentStartingLevel) {
    if (currentStartingLevel >= 0 && currentStartingLevel <= maxStartingLevel) {
      _currentStartingLevel = currentStartingLevel;
    }
  }

  int maxStartingLevel = 0;

  int laserLevel = 0;

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

    if (type == PowerUpType.speedBoost) {
      //tốc độ
      return 150 + 25 * level;
    } else {
      return 300 + 50 * level;
    }
  }

  bool upgradePowerUp(PowerUpType type) {
    // Chỉ cho upgrade 4 loại gốc (không upgrade heal/magnet/nuke vì drop trong game)
    if (type.index >= 4) return false;
    int price = powerUpUpgradePrice(type);
    int idx = type.index.clamp(0, _powerupLevels.length - 1);
    if (coins >= price && _powerupLevels[idx] < maxPowerUpLevel) {
      coins -= price;
      _powerupLevels[idx] += 1;
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

  void _checkDailyReset() {
    String today = DateTime.now().toIso8601String().split('T')[0];
    if (lastLoginDate != today) {
      lastLoginDate = today;
      _generateDailyQuests();
      store();
    }
  }

  void _generateDailyQuests() {
    dailyQuests = [
      DailyQuest(
          id: "q1",
          type: QuestType.playGames,
          description: "Play 3 Games",
          target: 3,
          coinReward: 500),
      DailyQuest(
          id: "q2",
          type: QuestType.killEnemies,
          description: "Destroy 100 Enemies",
          target: 100,
          coinReward: 1000),
      DailyQuest(
          id: "q3",
          type: QuestType.collectCoins,
          description: "Collect 500 Coins",
          target: 500,
          coinReward: 1500),
    ];
  }

  void updateQuestProgress(QuestType type, int amount) {
    bool updated = false;
    for (var quest in dailyQuests) {
      if (quest.type == type &&
          !quest.isClaimed &&
          quest.progress < quest.target) {
        quest.progress += amount;
        if (quest.progress > quest.target) quest.progress = quest.target;
        updated = true;
      }
    }
    if (updated) store();
  }
}
