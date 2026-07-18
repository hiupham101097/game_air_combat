enum QuestType {
  playGames,
  killEnemies,
  collectCoins,
}

class DailyQuest {
  final String id;
  final QuestType type;
  final String description;
  final int target;
  int progress;
  final int coinReward;
  bool isClaimed;

  DailyQuest({
    required this.id,
    required this.type,
    required this.description,
    required this.target,
    this.progress = 0,
    required this.coinReward,
    this.isClaimed = false,
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
    );
  }
}
