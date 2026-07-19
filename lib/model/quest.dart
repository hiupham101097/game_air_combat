enum QuestType {
  playGames,
  killEnemies,
  collectCoins,
}

enum QuestPeriod { daily, weekly }

class DailyQuest {
  final String id;
  final QuestType type;
  final String description;
  final int target;
  int progress;
  final int coinReward;
  bool isClaimed;
  final QuestPeriod period;

  DailyQuest({
    required this.id,
    required this.type,
    required this.description,
    required this.target,
    this.progress = 0,
    required this.coinReward,
    this.isClaimed = false,
    this.period = QuestPeriod.daily,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'description': description,
      'target': target,
      'progress': progress,
      'coinReward': coinReward,
      'isClaimed': isClaimed,
      'period': period.index,
    };
  }

  factory DailyQuest.fromJson(Map<String, dynamic> json) {
    return DailyQuest(
      id: json['id'],
      type: QuestType.values[json['type']],
      description: json['description'],
      target: json['target'],
      progress: json['progress'],
      coinReward: json['coinReward'],
      isClaimed: json['isClaimed'],
      period: json['period'] == QuestPeriod.weekly.index
          ? QuestPeriod.weekly
          : QuestPeriod.daily,
    );
  }
}
