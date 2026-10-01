import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/controller/rewarded_ad_service.dart';
import 'package:mini__game2/controller/setting/sound_assets.dart';
import 'package:mini__game2/l10n/generated/app_localizations.dart';
import 'package:mini__game2/view/game/game_demo.dart';
import 'package:mini__game2/view/main/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spritewidget/spritewidget.dart';

///khai báo 1 lân đề dùng chung
late PersistantGameState gameState;

const Color darkTextColor = Color(0xff3c3f4a);

typedef SelectTabCallback = void Function(int index);
typedef UpgradePowerUpCallback = void Function(PowerUpType type);

late ImageMap imageMap;
late SpriteSheet spriteSheet;
late SpriteSheet shipSpriteSheet;
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
  await RewardedAdService.instance.initialize();

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
    'assets/ships.png',
    'assets/starfield.png',
    'assets/space_warfield.png',
    'assets/game_ui.png',
    'assets/ui_bg_top.png',
    'assets/ui_bg_bottom.png',
    'assets/ui_popup.png',
    'assets/drone_sprite.png',
    'assets/boss_nova_clean.png',
    'assets/boss_phantom_clean.png',
    'assets/boss_titan_clean.png',
    'assets/boss_venom_clean.png',
    'assets/boss_colossus_clean.png',
    'assets/event_bg.png',
    'assets/enemy_drone_mite.png',
    'assets/enemies/enemy_rift_leech.png',
    'assets/enemies/enemy_shard_brood.png',
    'assets/enemies/enemy_rift_warden.png',
    'assets/ships/ship_superfighter.png',
    'assets/ships/ship_rift_dancer.png',
    'assets/ships/ship_bastion.png',
  ]);
  // Tải âm anh
  await settingSound();

  // Tải trang sprite
  String json = await rootBundle.loadString('assets/sprites.json');
  spriteSheet = SpriteSheet(
    image: imageMap['assets/sprites.png']!,
    jsonDefinition: json,
  );

  json = await rootBundle.loadString('assets/ships.json');
  shipSpriteSheet = SpriteSheet(
    image: imageMap['assets/ships.png']!,
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
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString('app_language') ?? 'system';
    if (!mounted) return;
    setState(() {
      _locale = languageCode == 'system' ? null : Locale(languageCode);
    });
  }

  void _setLocale(String languageCode) {
    setState(() {
      _locale = languageCode == 'system' ? null : Locale(languageCode);
    });
    SharedPreferences.getInstance().then(
      (preferences) => preferences.setString('app_language', languageCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: _showGame
          ? GameDemo(onLocaleChanged: _setLocale)
          : SplashScreen(
              onComplete: () => setState(() => _showGame = true),
            ),
    );
  }
}
