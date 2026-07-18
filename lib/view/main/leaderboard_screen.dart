import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data for leaderboard
    final List<Map<String, dynamic>> topPlayers = [
      {"name": "Player One", "score": 15000},
      {"name": "Sky King", "score": 12400},
      {"name": "Ace Pilot", "score": 9800},
      {"name": "Maverick", "score": 8500},
      {"name": "Goose", "score": 7200},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('LEADERBOARD', style: TextStyle(fontFamily: 'Orbitron')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: topPlayers.length,
        itemBuilder: (context, index) {
          final player = topPlayers[index];
          return ListTile(
            leading: Text('#${index + 1}', style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
            title: Text(player['name'], style: const TextStyle(color: Colors.white, fontFamily: 'Orbitron')),
            trailing: Text(player['score'].toString(), style: const TextStyle(color: Colors.white, fontSize: 18)),
          );
        },
      ),
    );
  }
}
