
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SoundAssets {
  final Map<String, AudioPlayer> _effectPlayers = {};
  SoundAssets(this.bundle);

  final AssetBundle bundle;

  Future<void> loadEffect(String name) async {
    final player = AudioPlayer();
    player.setAsset(_effectPathForName(name));
    await player.load();
    _effectPlayers[name] = player;
  }

  final Map<String, AudioPlayer> _musicPlayers = {};

  Future<void> loadMusic(String name) async {
    final player = AudioPlayer();
    await player.setAsset(_musicPathForName(name));
    player.setLoopMode(LoopMode.all);
    _musicPlayers[name] = player;
  }

  void playEffect(String name) {
    final player = _effectPlayers[name];
    if (player != null) {
      player.seek(Duration.zero);
      player.play();
    }
  }

  void playMusic(String name) {
    _musicPlayers.forEach((key, player) {
      if (key != name) {
        player.stop();
      }
    });
    
    final player = _musicPlayers[name];
    if (player != null) {
      player.seek(Duration.zero);
      player.play();
    }
  }

  String _effectPathForName(String name) => 'assets/$name.wav';

  String _musicPathForName(String name) => 'assets/$name.mp3';
}
