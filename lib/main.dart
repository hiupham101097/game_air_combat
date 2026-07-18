import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/controller/setting/sound_assets.dart';
import 'package:mini__game2/view/game/game_demo.dart';
import 'package:mini__game2/view/main/splash_screen.dart';
import 'package:spritewidget/spritewidget.dart';

///khai báo 1 lân đề dùng chung
late PersistantGameState gameState;

const Color darkTextColor = Color(0xff3c3f4a);

typedef SelectTabCallback = void Function(int index);
typedef UpgradePowerUpCallback = void Function(PowerUpType type);

late ImageMap imageMap;
late SpriteSheet spriteSheet;
late SpriteSheet spriteSheetUI;

late SoundAssets sounds;

enum CoordinateSystemType {
  fixedWidth,
  fixedHeight,
  stretch,
}

enum PowerUpType {
  shield,
  speedLaser,
  sideLaser,
  speedBoost,
  heal,
  magnet,
  nuke,
}

var gameSizeHeight = 320.0;

const chunkSpacing = 640.0;
const int chunksPerLevel = 9;

const bool drawDebug = false;

const int maxLevel = 9;

////

main() async {
  // Chúng ta cần gọi EnsureInitialized nếu chúng ta đang tải hình ảnh trước runApp
  // được gọi là.
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();

  // Ẩn tất cả các thanh menu
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  // tải trạng thái của game
  gameState = PersistantGameState();
  await gameState.load();

  // Tải hình ảnh lên
  imageMap = ImageMap();

  await imageMap.load(<String>[
    'assets/nebula.png',
    'assets/sprites.png',
    'assets/starfield.png',
    'assets/game_ui.png',
    'assets/ui_bg_top.png',
    'assets/ui_bg_bottom.png',
    'assets/ui_popup.png',
    'assets/ship_2.png',
    'assets/ship_phoenix.png',
    'assets/ship_stealth.png',
    'assets/ship_guardian.png',
    'assets/boss_nova.png',
    'assets/boss_phantom.png',
    'assets/boss_titan.png',
    'assets/event_bg.png',
  ]);
  // Tải âm anh
  await settingSound();

  // Tải trang sprite
  String json = await rootBundle.loadString('assets/sprites.json');
  spriteSheet = SpriteSheet(
    image: imageMap['assets/sprites.png']!,
    jsonDefinition: json,
  );

  json = await rootBundle.loadString('assets/game_ui.json');
  spriteSheetUI = SpriteSheet(
    image: imageMap['assets/game_ui.png']!,
    jsonDefinition: json,
  );

  // chạy ứng  dụng và gọi tới view đâu tiên là game demo
  runApp(const SplashWrapper());
}

settingSound() async {
  sounds = SoundAssets(rootBundle);
  final loads = <Future>[];
  loads.addAll([
    sounds.loadEffect('explosion_0'),
    sounds.loadEffect('explosion_1'),
    sounds.loadEffect('explosion_2'),
    sounds.loadEffect('explosion_boss'),
    sounds.loadEffect('explosion_player'),
    sounds.loadEffect('laser'),
    sounds.loadEffect('hit'),
    sounds.loadEffect('levelup'),
    sounds.loadEffect('pickup_0'),
    sounds.loadEffect('pickup_1'),
    sounds.loadEffect('pickup_2'),
    sounds.loadEffect('pickup_powerup'),
    sounds.loadEffect('click'),
    sounds.loadEffect('buy_upgrade'),
    sounds.loadMusic('music_intro'),
    sounds.loadMusic('music_game'),
  ]);

  return await Future.wait(loads);
}

/// SplashWrapper shows the animated splash screen,
/// then transitions to the main game.
class SplashWrapper extends StatefulWidget {
  const SplashWrapper({Key? key}) : super(key: key);

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showGame = false;

  @override
  Widget build(BuildContext context) {
    if (_showGame) {
      return const GameDemo();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        onComplete: () {
          setState(() => _showGame = true);
        },
      ),
    );
  }
}
