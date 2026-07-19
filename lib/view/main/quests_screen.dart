import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/quest.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({Key? key}) : super(key: key);

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  Timer? _dailyResetTimer;

  @override
  void initState() {
    super.initState();
    if (gameState.resetDailyQuestsIfNeeded()) gameState.store();
    _scheduleDailyReset();
  }

  void _scheduleDailyReset() {
    final vietnamNow = DateTime.now().toUtc().add(const Duration(hours: 7));
    final nextMidnightUtc = DateTime.utc(
      vietnamNow.year,
      vietnamNow.month,
      vietnamNow.day + 1,
    ).subtract(const Duration(hours: 7));
    final waitTime = nextMidnightUtc.difference(DateTime.now().toUtc());

    _dailyResetTimer = Timer(waitTime, () {
      if (!mounted) return;
      if (gameState.resetDailyQuestsIfNeeded()) gameState.store();
      setState(() {});
      _scheduleDailyReset();
    });
  }

  @override
  void dispose() {
    _dailyResetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('NHIỆM VỤ HẰNG NGÀY & HẰNG TUẦN',
            style: TextStyle(fontFamily: 'Orbitron')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Coins: ${gameState.coins}',
                style: const TextStyle(
                  fontFamily: 'Orbitron',
                  color: Colors.amber,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: gameState.dailyQuests.length,
        itemBuilder: (context, index) {
          final quest = gameState.dailyQuests[index];
          final progressPercent =
              (quest.progress / quest.target).clamp(0.0, 1.0);
          final isCompleted = quest.progress >= quest.target;

          return Card(
            color: Colors.white10,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.period == QuestPeriod.daily ? 'DAILY' : 'WEEKLY',
                    style: TextStyle(
                      color: quest.period == QuestPeriod.daily
                          ? Colors.lightBlueAccent
                          : Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(quest.description,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Orbitron',
                          fontSize: 16)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressPercent,
                    backgroundColor: Colors.white24,
                    color: isCompleted ? Colors.green : Colors.amber,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${quest.progress} / ${quest.target}',
                          style: const TextStyle(color: Colors.white70)),
                      if (quest.isClaimed)
                        const Text('ĐÃ NHẬN',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold))
                      else if (isCompleted)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            setState(() {
                              quest.isClaimed = true;
                              gameState.coins += quest.coinReward;
                              gameState.store();
                            });
                          },
                          child: Text('NHẬN ${quest.coinReward} XU',
                              style: const TextStyle(color: Colors.white)),
                        )
                      else
                        Text('THƯỞNG: ${quest.coinReward} XU',
                            style: const TextStyle(color: Colors.amber)),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
