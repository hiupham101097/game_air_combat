import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
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

    final dailyQuestsReset = resetDailyQuestsIfNeeded();
    if (resetProgression || dailyQuestsReset) await store();
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
    lastWeeklyQuestWeek = data['lastWeeklyQuestWeek'] ?? '';
    unlockedShips = data['unlockedShips']?.cast<int>() ?? [0];
    equippedShip = data['equippedShip'] ?? 0;

    if (data['dailyQuests'] != null) {
      dailyQuests = (data['dailyQuests'] as List)
          .map((q) => DailyQuest.fromJson(q))
          .toList();
    } else {
      _generateAllQuests();
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
    lastWeeklyQuestWeek = '';
    _generateAllQuests();
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
      'lastWeeklyQuestWeek': lastWeeklyQuestWeek,
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
      resetDailyQuestsIfNeeded();
      await store();
    }
  }

  // A single observable source of truth keeps every screen's coin display in
  // sync immediately after rewards and purchases.
  final ValueNotifier<int> coinsNotifier = ValueNotifier<int>(0);

  int get coins => coinsNotifier.value;

  set coins(int value) => coinsNotifier.value = value;

  List<int> unlockedWeapons = <int>[0];
  int equippedWeapon = 0;

  List<int> unlockedShips = <int>[0];
  int equippedShip = 0;

  String lastLoginDate = "";
  String lastWeeklyQuestWeek = '';

  List<String> ownedEquipment = <String>[];
  Map<String, String> equippedLoadout = <String, String>{};
  Map<String, int> equipmentLevels = <String, int>{}; // ID -> Level
  static const int maxEquipmentLevel = 100;

  int equipmentLevel(String itemId) =>
      (equipmentLevels[itemId] ?? 1).clamp(1, maxEquipmentLevel);

  bool isEquipmentUpgradeUnlocked(String itemId) {
    // Equipment upgrades are independent. Previously the level 9 -> 10
    // upgrade was blocked until every equipped slot reached level 9.
    return equipmentLevel(itemId) < maxEquipmentLevel;
  }

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

  // Internal level starts at 0 while the UI displays level + 1. Keeping this
  // at 99 allows the four permanent power upgrades to reach displayed level
  // 100 instead of silently stopping at level 9.
  int maxPowerUpLevel = 99;

  int _currentStartingLevel = 0;

  int get currentStartingLevel => _currentStartingLevel;

  set currentStartingLevel(int currentStartingLevel) {
    if (currentStartingLevel >= 0 && currentStartingLevel <= maxStartingLevel) {
      _currentStartingLevel = currentStartingLevel;
    }
  }

  int maxStartingLevel = 0;

  int laserLevel = 0;

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
    // Giá theo từng bậc, sau bậc 4 giữ cố định để nâng cấp cuối game
    // vẫn có thể đạt được.
    return (750 * pow(1.45, laserLevel)).round();
  }

  bool upgradeLaser() {
    if (coins >= laserUpgradePrice()) {
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

  /// Resets daily quests at 00:00 and weekly quests each Monday at 00:00,
  /// using Vietnam time (UTC+7) regardless of the device timezone.
  bool resetDailyQuestsIfNeeded() {
    final vietnamNow = DateTime.now().toUtc().add(const Duration(hours: 7));
    final today = _dateKey(vietnamNow);
    final monday = vietnamNow.subtract(Duration(days: vietnamNow.weekday - 1));
    final currentWeek = _dateKey(monday);
    var wasReset = false;

    // Migrate the former three daily quests into the new 7 daily + 3 weekly set.
    if (dailyQuests.length != 10 ||
        dailyQuests
                .where((quest) => quest.period == QuestPeriod.weekly)
                .length !=
            3) {
      _generateAllQuests();
      lastLoginDate = today;
      lastWeeklyQuestWeek = currentWeek;
      return true;
    }

    if (lastLoginDate != today) {
      lastLoginDate = today;
      _generateDailyQuests();
      wasReset = true;
    }
    if (lastWeeklyQuestWeek != currentWeek) {
      lastWeeklyQuestWeek = currentWeek;
      _generateWeeklyQuests();
      wasReset = true;
    }
    return wasReset;
  }

  String _dateKey(DateTime date) => '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  void _generateAllQuests() {
    dailyQuests = [];
    _generateDailyQuests();
    _generateWeeklyQuests();
  }

  void _generateDailyQuests() {
    final random = Random();
    final quests = List<DailyQuest>.generate(7, (index) {
      final type = QuestType.values[index % QuestType.values.length];
      late int target;
      late String description;
      switch (type) {
        case QuestType.playGames:
          target = 1 + random.nextInt(5);
          description = 'Play $target Games';
        case QuestType.killEnemies:
          target = (1 + random.nextInt(8)) * 10;
          description = 'Destroy $target Enemies';
        case QuestType.collectCoins:
          target = (1 + random.nextInt(10)) * 20;
          description = 'Collect $target Coins';
      }
      return DailyQuest(
        id: 'daily_${index + 1}',
        type: type,
        description: description,
        target: target,
        coinReward: 1 + random.nextInt(200),
      );
    });
    dailyQuests = [
      ...quests,
      ...dailyQuests.where((quest) => quest.period == QuestPeriod.weekly),
    ];
  }

  void _generateWeeklyQuests() {
    const reward = 1500;
    final quests = [
      DailyQuest(
          id: 'weekly_1',
          type: QuestType.playGames,
          description: 'Play 20 Games',
          target: 20,
          coinReward: reward,
          period: QuestPeriod.weekly),
      DailyQuest(
          id: 'weekly_2',
          type: QuestType.killEnemies,
          description: 'Destroy 1,000 Enemies',
          target: 1000,
          coinReward: reward,
          period: QuestPeriod.weekly),
      DailyQuest(
          id: 'weekly_3',
          type: QuestType.collectCoins,
          description: 'Collect 1,000 Coins',
          target: 1000,
          coinReward: reward,
          period: QuestPeriod.weekly),
    ];
    dailyQuests = [
      ...dailyQuests.where((quest) => quest.period == QuestPeriod.daily),
      ...quests,
    ];
  }

  void updateQuestProgress(QuestType type, int amount) {
    bool updated = resetDailyQuestsIfNeeded();
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
