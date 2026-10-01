import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @useDeviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get useDeviceLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @splashInitializing.
  ///
  /// In en, this message translates to:
  /// **'INITIALIZING...'**
  String get splashInitializing;

  /// No description provided for @splashLoadingAssets.
  ///
  /// In en, this message translates to:
  /// **'LOADING ASSETS...'**
  String get splashLoadingAssets;

  /// No description provided for @splashReady.
  ///
  /// In en, this message translates to:
  /// **'READY TO LAUNCH'**
  String get splashReady;

  /// No description provided for @lastScore.
  ///
  /// In en, this message translates to:
  /// **'LAST SCORE'**
  String get lastScore;

  /// No description provided for @bestScore.
  ///
  /// In en, this message translates to:
  /// **'BEST SCORE'**
  String get bestScore;

  /// No description provided for @upgradeLaser.
  ///
  /// In en, this message translates to:
  /// **'LASER UPGRADE'**
  String get upgradeLaser;

  /// No description provided for @upgradePowerups.
  ///
  /// In en, this message translates to:
  /// **'POWER-UP UPGRADES'**
  String get upgradePowerups;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'INVENTORY'**
  String get inventory;

  /// No description provided for @quests.
  ///
  /// In en, this message translates to:
  /// **'MISSIONS'**
  String get quests;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'LEADERBOARD'**
  String get leaderboard;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @eventMode.
  ///
  /// In en, this message translates to:
  /// **'⚡ EVENT MODE'**
  String get eventMode;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'LEVEL {level}'**
  String level(int level);

  /// No description provided for @powerUpLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String powerUpLevel(int level);

  /// No description provided for @languageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get languageDialogTitle;

  /// No description provided for @story.
  ///
  /// In en, this message translates to:
  /// **'STORY'**
  String get story;

  /// No description provided for @storyTitle.
  ///
  /// In en, this message translates to:
  /// **'THE RIFT WAR'**
  String get storyTitle;

  /// No description provided for @storySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Three transmissions from a world under siege'**
  String get storySubtitle;

  /// No description provided for @sectorFrontier.
  ///
  /// In en, this message translates to:
  /// **'ORBITAL FRONTIER'**
  String get sectorFrontier;

  /// No description provided for @sectorRift.
  ///
  /// In en, this message translates to:
  /// **'RIFT FRONT'**
  String get sectorRift;

  /// No description provided for @sectorSiege.
  ///
  /// In en, this message translates to:
  /// **'INVASION SIEGE'**
  String get sectorSiege;

  /// No description provided for @sectorCore.
  ///
  /// In en, this message translates to:
  /// **'INVASION CORE'**
  String get sectorCore;

  /// No description provided for @storyChapterOneTitle.
  ///
  /// In en, this message translates to:
  /// **'01 · THE FIRST BREACH'**
  String get storyChapterOneTitle;

  /// No description provided for @storyChapterOneBody.
  ///
  /// In en, this message translates to:
  /// **'An impossible rift tears open beyond the outer planets. Hostile forces pour in from another dimension and strike the colonies before Earth\'s defenses can respond. The first distress signals reach the home world.'**
  String get storyChapterOneBody;

  /// No description provided for @storyChapterTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'02 · THE INVASION FLEET'**
  String get storyChapterTwoTitle;

  /// No description provided for @storyChapterTwoBody.
  ///
  /// In en, this message translates to:
  /// **'The enemy returns with new weapons and faster warships. Phase Stalkers vanish between volleys, Rift Bombers rake the defense lines, Void Leeches hunt escort craft, and Shard Broods split under fire. Earth\'s shield network begins to fail.'**
  String get storyChapterTwoBody;

  /// No description provided for @storyChapterThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'03 · PROJECT SUPER FIGHTER'**
  String get storyChapterThreeTitle;

  /// No description provided for @storyChapterThreeBody.
  ///
  /// In en, this message translates to:
  /// **'Humanity\'s last shipyards fuse captured rift technology into a new fighter. The Super Fighter carries a Phase Lance that turns the invaders\' own dimensional energy against them. Reach Level 10 to earn the prototype, or save 150,000 credits to buy it early.'**
  String get storyChapterThreeBody;

  /// No description provided for @storyObjectiveTitle.
  ///
  /// In en, this message translates to:
  /// **'YOUR MISSION'**
  String get storyObjectiveTitle;

  /// No description provided for @storyObjectiveBody.
  ///
  /// In en, this message translates to:
  /// **'Break through the invasion fleet, destroy its warships, and push into the rift before the next wave reaches Earth.'**
  String get storyObjectiveBody;

  /// No description provided for @storyBackToHangar.
  ///
  /// In en, this message translates to:
  /// **'RETURN TO HANGAR'**
  String get storyBackToHangar;

  /// No description provided for @inventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'HANGAR & EQUIPMENT'**
  String get inventoryTitle;

  /// No description provided for @chestOpening.
  ///
  /// In en, this message translates to:
  /// **'OPENING CHEST...'**
  String get chestOpening;

  /// No description provided for @equipped.
  ///
  /// In en, this message translates to:
  /// **'EQUIPPED'**
  String get equipped;

  /// No description provided for @equip.
  ///
  /// In en, this message translates to:
  /// **'EQUIP'**
  String get equip;

  /// No description provided for @coins.
  ///
  /// In en, this message translates to:
  /// **'COINS'**
  String get coins;

  /// No description provided for @notEnoughCoins.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins.'**
  String get notEnoughCoins;

  /// No description provided for @tabShips.
  ///
  /// In en, this message translates to:
  /// **'SHIPS'**
  String get tabShips;

  /// No description provided for @tabWeapons.
  ///
  /// In en, this message translates to:
  /// **'WEAPONS'**
  String get tabWeapons;

  /// No description provided for @tabEquipment.
  ///
  /// In en, this message translates to:
  /// **'EQUIPMENT'**
  String get tabEquipment;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'HANGAR'**
  String get warehouse;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'UPGRADE'**
  String get upgrade;

  /// No description provided for @openOne.
  ///
  /// In en, this message translates to:
  /// **'OPEN x1 · 1,000'**
  String get openOne;

  /// No description provided for @openTen.
  ///
  /// In en, this message translates to:
  /// **'OPEN x10 · 10,000'**
  String get openTen;

  /// No description provided for @legendaryGuarantee.
  ///
  /// In en, this message translates to:
  /// **'LEGENDARY GUARANTEE: {count}/80'**
  String legendaryGuarantee(int count);

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'SLOT: {slot}'**
  String location(Object slot);

  /// No description provided for @unequip.
  ///
  /// In en, this message translates to:
  /// **'UNEQUIP'**
  String get unequip;

  /// No description provided for @openChest.
  ///
  /// In en, this message translates to:
  /// **'OPEN CHEST'**
  String get openChest;

  /// No description provided for @gachaNeedCoins.
  ///
  /// In en, this message translates to:
  /// **'You need {amount} coins to open this chest.'**
  String gachaNeedCoins(int amount);

  /// No description provided for @gachaResult.
  ///
  /// In en, this message translates to:
  /// **'✨ CHEST RESULTS ✨'**
  String get gachaResult;

  /// No description provided for @equipmentReceived.
  ///
  /// In en, this message translates to:
  /// **'NEW EQUIPMENT RECEIVED'**
  String get equipmentReceived;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'AWESOME!'**
  String get great;

  /// No description provided for @energyStones.
  ///
  /// In en, this message translates to:
  /// **'Energy stones'**
  String get energyStones;

  /// No description provided for @energyCores.
  ///
  /// In en, this message translates to:
  /// **'Energy cores'**
  String get energyCores;

  /// No description provided for @duplicatesConverted.
  ///
  /// In en, this message translates to:
  /// **'{count} duplicate(s) converted'**
  String duplicatesConverted(int count);

  /// No description provided for @noEquipment.
  ///
  /// In en, this message translates to:
  /// **'You don\'t own any equipment yet.'**
  String get noEquipment;

  /// No description provided for @upgradeUnlockRequirement.
  ///
  /// In en, this message translates to:
  /// **'Equip 4 items at level 9 to unlock this upgrade.'**
  String get upgradeUnlockRequirement;

  /// No description provided for @maxLevelReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum level reached: 100'**
  String get maxLevelReached;

  /// No description provided for @levelChange.
  ///
  /// In en, this message translates to:
  /// **'Level {current} ➜ {next}'**
  String levelChange(int current, int next);

  /// No description provided for @upgradeSuccess.
  ///
  /// In en, this message translates to:
  /// **'{item} upgraded to level {level}!'**
  String upgradeSuccess(Object item, int level);

  /// No description provided for @purchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'{item} purchased!'**
  String purchaseSuccess(Object item);

  /// No description provided for @energyStonesGained.
  ///
  /// In en, this message translates to:
  /// **'+{amount} energy stones'**
  String energyStonesGained(int amount);

  /// No description provided for @energyCoresGained.
  ///
  /// In en, this message translates to:
  /// **'+{amount} energy cores'**
  String energyCoresGained(int amount);

  /// No description provided for @rarityCommon.
  ///
  /// In en, this message translates to:
  /// **'COMMON'**
  String get rarityCommon;

  /// No description provided for @rarityRare.
  ///
  /// In en, this message translates to:
  /// **'RARE'**
  String get rarityRare;

  /// No description provided for @rarityEpic.
  ///
  /// In en, this message translates to:
  /// **'EPIC'**
  String get rarityEpic;

  /// No description provided for @rarityLegendary.
  ///
  /// In en, this message translates to:
  /// **'LEGENDARY'**
  String get rarityLegendary;

  /// No description provided for @slotCore.
  ///
  /// In en, this message translates to:
  /// **'CORE'**
  String get slotCore;

  /// No description provided for @slotArmor.
  ///
  /// In en, this message translates to:
  /// **'ARMOR'**
  String get slotArmor;

  /// No description provided for @slotEngine.
  ///
  /// In en, this message translates to:
  /// **'ENGINE'**
  String get slotEngine;

  /// No description provided for @slotDrone.
  ///
  /// In en, this message translates to:
  /// **'DRONE'**
  String get slotDrone;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'DAILY'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY'**
  String get weekly;

  /// No description provided for @questsTitle.
  ///
  /// In en, this message translates to:
  /// **'DAILY & WEEKLY MISSIONS'**
  String get questsTitle;

  /// No description provided for @coinsCount.
  ///
  /// In en, this message translates to:
  /// **'Coins: {count}'**
  String coinsCount(int count);

  /// No description provided for @claimed.
  ///
  /// In en, this message translates to:
  /// **'CLAIMED'**
  String get claimed;

  /// No description provided for @claimReward.
  ///
  /// In en, this message translates to:
  /// **'CLAIM {count} COINS'**
  String claimReward(int count);

  /// No description provided for @rewardCoins.
  ///
  /// In en, this message translates to:
  /// **'REWARD: {count} COINS'**
  String rewardCoins(int count);

  /// No description provided for @questPlayGames.
  ///
  /// In en, this message translates to:
  /// **'Play {count} games'**
  String questPlayGames(int count);

  /// No description provided for @questKillEnemies.
  ///
  /// In en, this message translates to:
  /// **'Destroy {count} enemies'**
  String questKillEnemies(int count);

  /// No description provided for @questCollectCoins.
  ///
  /// In en, this message translates to:
  /// **'Collect {count} coins'**
  String questCollectCoins(int count);

  /// No description provided for @leaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'LEADERBOARD'**
  String get leaderboardTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'CLOUD SAVE ACCOUNT'**
  String get loginTitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signIn;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get register;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Check your details and try again.'**
  String get loginFailed;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Account creation failed. Check your details and try again.'**
  String get registerFailed;

  /// No description provided for @pauseTitle.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get pauseTitle;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get resume;

  /// No description provided for @powerBoost.
  ///
  /// In en, this message translates to:
  /// **'POWER BOOST'**
  String get powerBoost;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'LOADING...'**
  String get loading;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'QUIT'**
  String get quit;

  /// No description provided for @quitTitle.
  ///
  /// In en, this message translates to:
  /// **'Quit the game?'**
  String get quitTitle;

  /// No description provided for @quitWarning.
  ///
  /// In en, this message translates to:
  /// **'This run will end and its score will not be saved.'**
  String get quitWarning;

  /// No description provided for @revive.
  ///
  /// In en, this message translates to:
  /// **'REVIVE'**
  String get revive;

  /// No description provided for @reviveDescription.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to revive and continue your run.'**
  String get reviveDescription;

  /// No description provided for @watchAd.
  ///
  /// In en, this message translates to:
  /// **'WATCH AD'**
  String get watchAd;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get home;

  /// No description provided for @bossDefeated.
  ///
  /// In en, this message translates to:
  /// **'BOSS DEFEATED!'**
  String get bossDefeated;

  /// No description provided for @chooseBuff.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE A BOOST'**
  String get chooseBuff;

  /// No description provided for @runLevelShort.
  ///
  /// In en, this message translates to:
  /// **'LV {level}'**
  String runLevelShort(int level);

  /// No description provided for @runUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'COMBAT LEVEL {level}'**
  String runUpgradeTitle(int level);

  /// No description provided for @runUpgradeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE ONE COMBAT PROTOCOL'**
  String get runUpgradeSubtitle;

  /// No description provided for @runUpgradeDamageName.
  ///
  /// In en, this message translates to:
  /// **'OVERCHARGED CORE'**
  String get runUpgradeDamageName;

  /// No description provided for @runUpgradeDamageDescription.
  ///
  /// In en, this message translates to:
  /// **'+10% weapon damage for this run'**
  String get runUpgradeDamageDescription;

  /// No description provided for @runUpgradeFireName.
  ///
  /// In en, this message translates to:
  /// **'RAPID CYCLE'**
  String get runUpgradeFireName;

  /// No description provided for @runUpgradeFireDescription.
  ///
  /// In en, this message translates to:
  /// **'+8% firing speed for this run'**
  String get runUpgradeFireDescription;

  /// No description provided for @runUpgradeMultiName.
  ///
  /// In en, this message translates to:
  /// **'SPLIT BARREL'**
  String get runUpgradeMultiName;

  /// No description provided for @runUpgradeMultiDescription.
  ///
  /// In en, this message translates to:
  /// **'+1 extra projectile'**
  String get runUpgradeMultiDescription;

  /// No description provided for @runUpgradeCriticalName.
  ///
  /// In en, this message translates to:
  /// **'TARGETING MATRIX'**
  String get runUpgradeCriticalName;

  /// No description provided for @runUpgradeCriticalDescription.
  ///
  /// In en, this message translates to:
  /// **'+5% critical chance'**
  String get runUpgradeCriticalDescription;

  /// No description provided for @runUpgradeThrusterName.
  ///
  /// In en, this message translates to:
  /// **'VECTOR THRUSTERS'**
  String get runUpgradeThrusterName;

  /// No description provided for @runUpgradeThrusterDescription.
  ///
  /// In en, this message translates to:
  /// **'+10% fighter movement speed'**
  String get runUpgradeThrusterDescription;

  /// No description provided for @runUpgradeHullName.
  ///
  /// In en, this message translates to:
  /// **'REINFORCED HULL'**
  String get runUpgradeHullName;

  /// No description provided for @runUpgradeHullDescription.
  ///
  /// In en, this message translates to:
  /// **'+1 maximum hull and repair 1 hull'**
  String get runUpgradeHullDescription;

  /// No description provided for @runUpgradeRepairName.
  ///
  /// In en, this message translates to:
  /// **'NANITE REPAIR'**
  String get runUpgradeRepairName;

  /// No description provided for @runUpgradeRepairDescription.
  ///
  /// In en, this message translates to:
  /// **'Restore 1 hull'**
  String get runUpgradeRepairDescription;

  /// No description provided for @runUpgradeRiftName.
  ///
  /// In en, this message translates to:
  /// **'RIFT CAPACITOR'**
  String get runUpgradeRiftName;

  /// No description provided for @runUpgradeRiftDescription.
  ///
  /// In en, this message translates to:
  /// **'Gain 25 Rift Burst charge'**
  String get runUpgradeRiftDescription;

  /// No description provided for @runUpgradeShieldName.
  ///
  /// In en, this message translates to:
  /// **'PHASE SHIELD'**
  String get runUpgradeShieldName;

  /// No description provided for @runUpgradeShieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Activate a 1.5-second energy shield'**
  String get runUpgradeShieldDescription;

  /// No description provided for @damageBuffTitle.
  ///
  /// In en, this message translates to:
  /// **'DAMAGE BOOST'**
  String get damageBuffTitle;

  /// No description provided for @fireRateBuffTitle.
  ///
  /// In en, this message translates to:
  /// **'FIRE RATE BOOST'**
  String get fireRateBuffTitle;

  /// No description provided for @rareDamageBuffTitle.
  ///
  /// In en, this message translates to:
  /// **'RARE DAMAGE BOOST'**
  String get rareDamageBuffTitle;

  /// No description provided for @damageBuff.
  ///
  /// In en, this message translates to:
  /// **'+{percent}% weapon damage'**
  String damageBuff(int percent);

  /// No description provided for @fireRateBuff.
  ///
  /// In en, this message translates to:
  /// **'+{percent}% fire rate'**
  String fireRateBuff(int percent);

  /// No description provided for @comboLabel.
  ///
  /// In en, this message translates to:
  /// **'COMBO x{count}'**
  String comboLabel(int count);

  /// No description provided for @scoreMultiplier.
  ///
  /// In en, this message translates to:
  /// **'{multiplier}x SCORE'**
  String scoreMultiplier(Object multiplier);

  /// No description provided for @nearMissBonus.
  ///
  /// In en, this message translates to:
  /// **'NEAR MISS  +{score}'**
  String nearMissBonus(int score);

  /// No description provided for @riftBurst.
  ///
  /// In en, this message translates to:
  /// **'RIFT BURST'**
  String get riftBurst;

  /// No description provided for @riftBurstReady.
  ///
  /// In en, this message translates to:
  /// **'BURST READY'**
  String get riftBurstReady;

  /// No description provided for @phaseShift.
  ///
  /// In en, this message translates to:
  /// **'PHASE SHIFT'**
  String get phaseShift;

  /// No description provided for @phaseShiftReady.
  ///
  /// In en, this message translates to:
  /// **'SHIFT READY'**
  String get phaseShiftReady;

  /// No description provided for @equipmentResonance.
  ///
  /// In en, this message translates to:
  /// **'{rarity} RESONANCE: {count}/4'**
  String equipmentResonance(Object rarity, int count);

  /// No description provided for @equipmentResonanceBonuses.
  ///
  /// In en, this message translates to:
  /// **'2 pieces: +5% fire rate · 3: +8% damage · 4: +1 hull, +5% speed'**
  String get equipmentResonanceBonuses;

  /// No description provided for @equipmentResonanceNone.
  ///
  /// In en, this message translates to:
  /// **'Equip matching rarity gear to unlock set bonuses.'**
  String get equipmentResonanceNone;

  /// No description provided for @shipStandard.
  ///
  /// In en, this message translates to:
  /// **'Interceptor'**
  String get shipStandard;

  /// No description provided for @shipStandardDescription.
  ///
  /// In en, this message translates to:
  /// **'A balanced, dependable all-round fighter.'**
  String get shipStandardDescription;

  /// No description provided for @shipRacer.
  ///
  /// In en, this message translates to:
  /// **'Velocity'**
  String get shipRacer;

  /// No description provided for @shipRacerDescription.
  ///
  /// In en, this message translates to:
  /// **'A nimble fighter with 20% more movement speed.'**
  String get shipRacerDescription;

  /// No description provided for @shipPhoenix.
  ///
  /// In en, this message translates to:
  /// **'Phoenix'**
  String get shipPhoenix;

  /// No description provided for @shipPhoenixDescription.
  ///
  /// In en, this message translates to:
  /// **'A fiery attacker with 30% faster fire rate.'**
  String get shipPhoenixDescription;

  /// No description provided for @shipStealth.
  ///
  /// In en, this message translates to:
  /// **'Wraith'**
  String get shipStealth;

  /// No description provided for @shipStealthDescription.
  ///
  /// In en, this message translates to:
  /// **'A fast stealth fighter with a smaller hit area.'**
  String get shipStealthDescription;

  /// No description provided for @shipGuardian.
  ///
  /// In en, this message translates to:
  /// **'Guardian'**
  String get shipGuardian;

  /// No description provided for @shipGuardianDescription.
  ///
  /// In en, this message translates to:
  /// **'A heavy gunship with 50% faster fire rate and a stronger shield.'**
  String get shipGuardianDescription;

  /// No description provided for @shipSuperFighter.
  ///
  /// In en, this message translates to:
  /// **'Super Fighter'**
  String get shipSuperFighter;

  /// No description provided for @shipSuperFighterDescription.
  ///
  /// In en, this message translates to:
  /// **'Humanity\'s advanced prototype, powered by captured rift energy and armed with a Phase Lance.'**
  String get shipSuperFighterDescription;

  /// No description provided for @shipRiftDancer.
  ///
  /// In en, this message translates to:
  /// **'Rift Dancer'**
  String get shipRiftDancer;

  /// No description provided for @shipRiftDancerDescription.
  ///
  /// In en, this message translates to:
  /// **'A nimble interceptor whose arc emitters sweep shots back across enemy lanes.'**
  String get shipRiftDancerDescription;

  /// No description provided for @shipBastion.
  ///
  /// In en, this message translates to:
  /// **'Bastion'**
  String get shipBastion;

  /// No description provided for @shipBastionDescription.
  ///
  /// In en, this message translates to:
  /// **'A heavy gunship that blankets a wide lane with flak rounds.'**
  String get shipBastionDescription;

  /// No description provided for @weaponBasic.
  ///
  /// In en, this message translates to:
  /// **'Standard Laser'**
  String get weaponBasic;

  /// No description provided for @weaponBasicDescription.
  ///
  /// In en, this message translates to:
  /// **'A reliable rapid-fire laser.'**
  String get weaponBasicDescription;

  /// No description provided for @weaponSpread.
  ///
  /// In en, this message translates to:
  /// **'Spread Cannon'**
  String get weaponSpread;

  /// No description provided for @weaponSpreadDescription.
  ///
  /// In en, this message translates to:
  /// **'Fires three shots in a wide arc.'**
  String get weaponSpreadDescription;

  /// No description provided for @weaponPiercing.
  ///
  /// In en, this message translates to:
  /// **'Piercing Beam'**
  String get weaponPiercing;

  /// No description provided for @weaponPiercingDescription.
  ///
  /// In en, this message translates to:
  /// **'A powerful energy beam that pierces enemies.'**
  String get weaponPiercingDescription;

  /// No description provided for @weaponHoming.
  ///
  /// In en, this message translates to:
  /// **'Homing Missiles'**
  String get weaponHoming;

  /// No description provided for @weaponHomingDescription.
  ///
  /// In en, this message translates to:
  /// **'Missiles seek out the nearest target.'**
  String get weaponHomingDescription;

  /// No description provided for @weaponRapid.
  ///
  /// In en, this message translates to:
  /// **'Pulse Cannon'**
  String get weaponRapid;

  /// No description provided for @weaponRapidDescription.
  ///
  /// In en, this message translates to:
  /// **'Fires rapid bursts of light plasma.'**
  String get weaponRapidDescription;

  /// No description provided for @weaponPlasma.
  ///
  /// In en, this message translates to:
  /// **'Plasma Cannon'**
  String get weaponPlasma;

  /// No description provided for @weaponPlasmaDescription.
  ///
  /// In en, this message translates to:
  /// **'Launches heavy plasma shots for high damage.'**
  String get weaponPlasmaDescription;

  /// No description provided for @weaponNova.
  ///
  /// In en, this message translates to:
  /// **'Nova Wave'**
  String get weaponNova;

  /// No description provided for @weaponNovaDescription.
  ///
  /// In en, this message translates to:
  /// **'Unleashes a broad energy wave to clear a path.'**
  String get weaponNovaDescription;

  /// No description provided for @weaponPhase.
  ///
  /// In en, this message translates to:
  /// **'Riftbreaker Lance'**
  String get weaponPhase;

  /// No description provided for @weaponPhaseDescription.
  ///
  /// In en, this message translates to:
  /// **'A concentrated phase beam that tears through enemy armor.'**
  String get weaponPhaseDescription;

  /// No description provided for @weaponArc.
  ///
  /// In en, this message translates to:
  /// **'Rift Arc Emitters'**
  String get weaponArc;

  /// No description provided for @weaponArcDescription.
  ///
  /// In en, this message translates to:
  /// **'Fires three curving energy bolts across enemy lanes.'**
  String get weaponArcDescription;

  /// No description provided for @weaponFlak.
  ///
  /// In en, this message translates to:
  /// **'Siege Flak Cannons'**
  String get weaponFlak;

  /// No description provided for @weaponFlakDescription.
  ///
  /// In en, this message translates to:
  /// **'Fills a wide fan with heavy explosive rounds.'**
  String get weaponFlakDescription;

  /// No description provided for @eqCore1Name.
  ///
  /// In en, this message translates to:
  /// **'Standard Reactor Core'**
  String get eqCore1Name;

  /// No description provided for @eqCore1Description.
  ///
  /// In en, this message translates to:
  /// **'+10% weapon damage'**
  String get eqCore1Description;

  /// No description provided for @eqCore2Name.
  ///
  /// In en, this message translates to:
  /// **'Azure Plasma Core'**
  String get eqCore2Name;

  /// No description provided for @eqCore2Description.
  ///
  /// In en, this message translates to:
  /// **'+25% weapon damage and +5% critical chance'**
  String get eqCore2Description;

  /// No description provided for @eqCore3Name.
  ///
  /// In en, this message translates to:
  /// **'Dark Energy Core'**
  String get eqCore3Name;

  /// No description provided for @eqCore3Description.
  ///
  /// In en, this message translates to:
  /// **'+50% weapon damage'**
  String get eqCore3Description;

  /// No description provided for @eqCore4Name.
  ///
  /// In en, this message translates to:
  /// **'Quantum Annihilator Core'**
  String get eqCore4Name;

  /// No description provided for @eqCore4Description.
  ///
  /// In en, this message translates to:
  /// **'+100% weapon damage'**
  String get eqCore4Description;

  /// No description provided for @eqArmor1Name.
  ///
  /// In en, this message translates to:
  /// **'Basic Iron Armor'**
  String get eqArmor1Name;

  /// No description provided for @eqArmor1Description.
  ///
  /// In en, this message translates to:
  /// **'+1 hull; blocks one hit every 20 seconds'**
  String get eqArmor1Description;

  /// No description provided for @eqArmor2Name.
  ///
  /// In en, this message translates to:
  /// **'Titan Armor'**
  String get eqArmor2Name;

  /// No description provided for @eqArmor2Description.
  ///
  /// In en, this message translates to:
  /// **'+2 hull, 14% damage reduction, -10% movement speed'**
  String get eqArmor2Description;

  /// No description provided for @eqArmor3Name.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Energy Armor'**
  String get eqArmor3Name;

  /// No description provided for @eqArmor3Description.
  ///
  /// In en, this message translates to:
  /// **'+3 hull, 20% damage reduction; gains a 1.5-second shield after 5 seconds without damage'**
  String get eqArmor3Description;

  /// No description provided for @eqArmor4Name.
  ///
  /// In en, this message translates to:
  /// **'Immortal Armor'**
  String get eqArmor4Name;

  /// No description provided for @eqArmor4Description.
  ///
  /// In en, this message translates to:
  /// **'+5 hull, 26% damage reduction; +35% damage below 30% hull'**
  String get eqArmor4Description;

  /// No description provided for @eqEngine1Name.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary Ion Engine'**
  String get eqEngine1Name;

  /// No description provided for @eqEngine1Description.
  ///
  /// In en, this message translates to:
  /// **'+10% flight speed'**
  String get eqEngine1Description;

  /// No description provided for @eqEngine2Name.
  ///
  /// In en, this message translates to:
  /// **'Warp Engine'**
  String get eqEngine2Name;

  /// No description provided for @eqEngine2Description.
  ///
  /// In en, this message translates to:
  /// **'+20% flight speed'**
  String get eqEngine2Description;

  /// No description provided for @eqEngine3Name.
  ///
  /// In en, this message translates to:
  /// **'Spacefold Drive'**
  String get eqEngine3Name;

  /// No description provided for @eqEngine3Description.
  ///
  /// In en, this message translates to:
  /// **'+40% flight speed and +10% Rift charge gain'**
  String get eqEngine3Description;

  /// No description provided for @eqDrone1Name.
  ///
  /// In en, this message translates to:
  /// **'Sharpshooter Drone'**
  String get eqDrone1Name;

  /// No description provided for @eqDrone1Description.
  ///
  /// In en, this message translates to:
  /// **'Fires 1 support shot per second.'**
  String get eqDrone1Description;

  /// No description provided for @eqDrone2Name.
  ///
  /// In en, this message translates to:
  /// **'Destroyer Drone'**
  String get eqDrone2Name;

  /// No description provided for @eqDrone2Description.
  ///
  /// In en, this message translates to:
  /// **'Fires 3 support shots per second.'**
  String get eqDrone2Description;

  /// No description provided for @eqDrone3Name.
  ///
  /// In en, this message translates to:
  /// **'Hunter Drone'**
  String get eqDrone3Name;

  /// No description provided for @eqDrone3Description.
  ///
  /// In en, this message translates to:
  /// **'Fires 5 homing shots per second.'**
  String get eqDrone3Description;

  /// No description provided for @powerShield.
  ///
  /// In en, this message translates to:
  /// **'Shield'**
  String get powerShield;

  /// No description provided for @powerSideLaser.
  ///
  /// In en, this message translates to:
  /// **'Side lasers'**
  String get powerSideLaser;

  /// No description provided for @powerSpeedBoost.
  ///
  /// In en, this message translates to:
  /// **'Speed boost'**
  String get powerSpeedBoost;

  /// No description provided for @powerRapidFire.
  ///
  /// In en, this message translates to:
  /// **'Rapid fire'**
  String get powerRapidFire;

  /// No description provided for @firingStyle.
  ///
  /// In en, this message translates to:
  /// **'WEAPON: {weapon}'**
  String firingStyle(Object weapon);

  /// No description provided for @speedMultiplier.
  ///
  /// In en, this message translates to:
  /// **'SPEED ×{multiplier}'**
  String speedMultiplier(Object multiplier);

  /// No description provided for @damageMultiplier.
  ///
  /// In en, this message translates to:
  /// **'DAMAGE ×{multiplier}'**
  String damageMultiplier(Object multiplier);

  /// No description provided for @eqDrone4Name.
  ///
  /// In en, this message translates to:
  /// **'Aegis Drone'**
  String get eqDrone4Name;

  /// No description provided for @eqDrone4Description.
  ///
  /// In en, this message translates to:
  /// **'Shields the ship for 1.5 seconds every 15 seconds'**
  String get eqDrone4Description;

  /// No description provided for @eqDrone5Name.
  ///
  /// In en, this message translates to:
  /// **'Mender Drone'**
  String get eqDrone5Name;

  /// No description provided for @eqDrone5Description.
  ///
  /// In en, this message translates to:
  /// **'Restores one hull point every 30 seconds'**
  String get eqDrone5Description;

  /// No description provided for @combatStats.
  ///
  /// In en, this message translates to:
  /// **'COMBAT STATS'**
  String get combatStats;

  /// No description provided for @statHp.
  ///
  /// In en, this message translates to:
  /// **'HULL'**
  String get statHp;

  /// No description provided for @statArmor.
  ///
  /// In en, this message translates to:
  /// **'ARMOR'**
  String get statArmor;

  /// No description provided for @statDamage.
  ///
  /// In en, this message translates to:
  /// **'DAMAGE'**
  String get statDamage;

  /// No description provided for @statFireRate.
  ///
  /// In en, this message translates to:
  /// **'FIRE RATE'**
  String get statFireRate;

  /// No description provided for @statCrit.
  ///
  /// In en, this message translates to:
  /// **'CRIT'**
  String get statCrit;

  /// No description provided for @statProjectile.
  ///
  /// In en, this message translates to:
  /// **'VOLLEY'**
  String get statProjectile;

  /// No description provided for @statDrone.
  ///
  /// In en, this message translates to:
  /// **'DRONE'**
  String get statDrone;

  /// No description provided for @statSkillCharge.
  ///
  /// In en, this message translates to:
  /// **'SKILL CHARGE'**
  String get statSkillCharge;

  /// No description provided for @statMovement.
  ///
  /// In en, this message translates to:
  /// **'MOVEMENT'**
  String get statMovement;

  /// No description provided for @droneRoleNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get droneRoleNone;

  /// No description provided for @droneRoleAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get droneRoleAttack;

  /// No description provided for @droneRoleShield.
  ///
  /// In en, this message translates to:
  /// **'Shield'**
  String get droneRoleShield;

  /// No description provided for @droneRoleRepair.
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get droneRoleRepair;

  /// No description provided for @droneRoleMissile.
  ///
  /// In en, this message translates to:
  /// **'Missile'**
  String get droneRoleMissile;

  /// No description provided for @droneRoleLaser.
  ///
  /// In en, this message translates to:
  /// **'Laser'**
  String get droneRoleLaser;

  /// No description provided for @criticalHit.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL!'**
  String get criticalHit;

  /// No description provided for @statCritDamage.
  ///
  /// In en, this message translates to:
  /// **'CRIT DMG'**
  String get statCritDamage;

  /// No description provided for @statProjectileSpeed.
  ///
  /// In en, this message translates to:
  /// **'PROJ SPEED'**
  String get statProjectileSpeed;

  /// No description provided for @statPierce.
  ///
  /// In en, this message translates to:
  /// **'PIERCE'**
  String get statPierce;

  /// No description provided for @statPierceAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get statPierceAll;

  /// No description provided for @statBlast.
  ///
  /// In en, this message translates to:
  /// **'BLAST'**
  String get statBlast;

  /// No description provided for @statSkillCooldown.
  ///
  /// In en, this message translates to:
  /// **'SKILL CD'**
  String get statSkillCooldown;

  /// No description provided for @statShield.
  ///
  /// In en, this message translates to:
  /// **'SHIELD'**
  String get statShield;

  /// No description provided for @statReady.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get statReady;

  /// No description provided for @statOff.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get statOff;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
