// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get useDeviceLanguage => 'Use device language';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get splashInitializing => 'INITIALIZING...';

  @override
  String get splashLoadingAssets => 'LOADING ASSETS...';

  @override
  String get splashReady => 'READY TO LAUNCH';

  @override
  String get lastScore => 'LAST SCORE';

  @override
  String get bestScore => 'BEST SCORE';

  @override
  String get upgradeLaser => 'LASER UPGRADE';

  @override
  String get upgradePowerups => 'POWER-UP UPGRADES';

  @override
  String get inventory => 'INVENTORY';

  @override
  String get quests => 'MISSIONS';

  @override
  String get leaderboard => 'LEADERBOARD';

  @override
  String get account => 'ACCOUNT';

  @override
  String get start => 'START';

  @override
  String get eventMode => '⚡ EVENT MODE';

  @override
  String level(int level) {
    return 'LEVEL $level';
  }

  @override
  String powerUpLevel(int level) {
    return 'Level $level';
  }

  @override
  String get languageDialogTitle => 'Choose language';

  @override
  String get story => 'STORY';

  @override
  String get storyTitle => 'THE RIFT WAR';

  @override
  String get storySubtitle => 'Three transmissions from a world under siege';

  @override
  String get sectorFrontier => 'ORBITAL FRONTIER';

  @override
  String get sectorRift => 'RIFT FRONT';

  @override
  String get sectorSiege => 'INVASION SIEGE';

  @override
  String get sectorCore => 'INVASION CORE';

  @override
  String get storyChapterOneTitle => '01 · THE FIRST BREACH';

  @override
  String get storyChapterOneBody =>
      'An impossible rift tears open beyond the outer planets. Hostile forces pour in from another dimension and strike the colonies before Earth\'s defenses can respond. The first distress signals reach the home world.';

  @override
  String get storyChapterTwoTitle => '02 · THE INVASION FLEET';

  @override
  String get storyChapterTwoBody =>
      'The enemy returns with new weapons and faster warships. Phase Stalkers vanish between volleys, Rift Bombers rake the defense lines, Void Leeches hunt escort craft, and Shard Broods split under fire. Earth\'s shield network begins to fail.';

  @override
  String get storyChapterThreeTitle => '03 · PROJECT SUPER FIGHTER';

  @override
  String get storyChapterThreeBody =>
      'Humanity\'s last shipyards fuse captured rift technology into a new fighter. The Super Fighter carries a Phase Lance that turns the invaders\' own dimensional energy against them. Reach Level 10 to earn the prototype, or save 150,000 credits to buy it early.';

  @override
  String get storyObjectiveTitle => 'YOUR MISSION';

  @override
  String get storyObjectiveBody =>
      'Break through the invasion fleet, destroy its warships, and push into the rift before the next wave reaches Earth.';

  @override
  String get storyBackToHangar => 'RETURN TO HANGAR';

  @override
  String get inventoryTitle => 'HANGAR & EQUIPMENT';

  @override
  String get chestOpening => 'OPENING CHEST...';

  @override
  String get equipped => 'EQUIPPED';

  @override
  String get equip => 'EQUIP';

  @override
  String get coins => 'COINS';

  @override
  String get notEnoughCoins => 'Not enough coins.';

  @override
  String get tabShips => 'SHIPS';

  @override
  String get tabWeapons => 'WEAPONS';

  @override
  String get tabEquipment => 'EQUIPMENT';

  @override
  String get warehouse => 'HANGAR';

  @override
  String get upgrade => 'UPGRADE';

  @override
  String get openOne => 'OPEN x1 · 1,000';

  @override
  String get openTen => 'OPEN x10 · 10,000';

  @override
  String legendaryGuarantee(int count) {
    return 'LEGENDARY GUARANTEE: $count/80';
  }

  @override
  String location(Object slot) {
    return 'SLOT: $slot';
  }

  @override
  String get unequip => 'UNEQUIP';

  @override
  String get openChest => 'OPEN CHEST';

  @override
  String gachaNeedCoins(int amount) {
    return 'You need $amount coins to open this chest.';
  }

  @override
  String get gachaResult => '✨ CHEST RESULTS ✨';

  @override
  String get equipmentReceived => 'NEW EQUIPMENT RECEIVED';

  @override
  String get great => 'AWESOME!';

  @override
  String get energyStones => 'Energy stones';

  @override
  String get energyCores => 'Energy cores';

  @override
  String duplicatesConverted(int count) {
    return '$count duplicate(s) converted';
  }

  @override
  String get noEquipment => 'You don\'t own any equipment yet.';

  @override
  String get upgradeUnlockRequirement =>
      'Equip 4 items at level 9 to unlock this upgrade.';

  @override
  String get maxLevelReached => 'Maximum level reached: 100';

  @override
  String levelChange(int current, int next) {
    return 'Level $current ➜ $next';
  }

  @override
  String upgradeSuccess(Object item, int level) {
    return '$item upgraded to level $level!';
  }

  @override
  String purchaseSuccess(Object item) {
    return '$item purchased!';
  }

  @override
  String energyStonesGained(int amount) {
    return '+$amount energy stones';
  }

  @override
  String energyCoresGained(int amount) {
    return '+$amount energy cores';
  }

  @override
  String get rarityCommon => 'COMMON';

  @override
  String get rarityRare => 'RARE';

  @override
  String get rarityEpic => 'EPIC';

  @override
  String get rarityLegendary => 'LEGENDARY';

  @override
  String get slotCore => 'CORE';

  @override
  String get slotArmor => 'ARMOR';

  @override
  String get slotEngine => 'ENGINE';

  @override
  String get slotDrone => 'DRONE';

  @override
  String get daily => 'DAILY';

  @override
  String get weekly => 'WEEKLY';

  @override
  String get questsTitle => 'DAILY & WEEKLY MISSIONS';

  @override
  String coinsCount(int count) {
    return 'Coins: $count';
  }

  @override
  String get claimed => 'CLAIMED';

  @override
  String claimReward(int count) {
    return 'CLAIM $count COINS';
  }

  @override
  String rewardCoins(int count) {
    return 'REWARD: $count COINS';
  }

  @override
  String questPlayGames(int count) {
    return 'Play $count games';
  }

  @override
  String questKillEnemies(int count) {
    return 'Destroy $count enemies';
  }

  @override
  String questCollectCoins(int count) {
    return 'Collect $count coins';
  }

  @override
  String get leaderboardTitle => 'LEADERBOARD';

  @override
  String get loginTitle => 'CLOUD SAVE ACCOUNT';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'SIGN IN';

  @override
  String get register => 'CREATE ACCOUNT';

  @override
  String get cancel => 'CANCEL';

  @override
  String get loginFailed => 'Sign-in failed. Check your details and try again.';

  @override
  String get registerFailed =>
      'Account creation failed. Check your details and try again.';

  @override
  String get pauseTitle => 'PAUSED';

  @override
  String get resume => 'RESUME';

  @override
  String get powerBoost => 'POWER BOOST';

  @override
  String get loading => 'LOADING...';

  @override
  String get quit => 'QUIT';

  @override
  String get quitTitle => 'Quit the game?';

  @override
  String get quitWarning =>
      'This run will end and its score will not be saved.';

  @override
  String get revive => 'REVIVE';

  @override
  String get reviveDescription =>
      'Watch an ad to revive and continue your run.';

  @override
  String get watchAd => 'WATCH AD';

  @override
  String get home => 'HOME';

  @override
  String get bossDefeated => 'BOSS DEFEATED!';

  @override
  String get chooseBuff => 'CHOOSE A BOOST';

  @override
  String runLevelShort(int level) {
    return 'LV $level';
  }

  @override
  String runUpgradeTitle(int level) {
    return 'COMBAT LEVEL $level';
  }

  @override
  String get runUpgradeSubtitle => 'CHOOSE ONE COMBAT PROTOCOL';

  @override
  String get runUpgradeDamageName => 'OVERCHARGED CORE';

  @override
  String get runUpgradeDamageDescription => '+10% weapon damage for this run';

  @override
  String get runUpgradeFireName => 'RAPID CYCLE';

  @override
  String get runUpgradeFireDescription => '+8% firing speed for this run';

  @override
  String get runUpgradeMultiName => 'SPLIT BARREL';

  @override
  String get runUpgradeMultiDescription => '+1 extra projectile';

  @override
  String get runUpgradeCriticalName => 'TARGETING MATRIX';

  @override
  String get runUpgradeCriticalDescription => '+5% critical chance';

  @override
  String get runUpgradeThrusterName => 'VECTOR THRUSTERS';

  @override
  String get runUpgradeThrusterDescription => '+10% fighter movement speed';

  @override
  String get runUpgradeHullName => 'REINFORCED HULL';

  @override
  String get runUpgradeHullDescription => '+1 maximum hull and repair 1 hull';

  @override
  String get runUpgradeRepairName => 'NANITE REPAIR';

  @override
  String get runUpgradeRepairDescription => 'Restore 1 hull';

  @override
  String get runUpgradeRiftName => 'RIFT CAPACITOR';

  @override
  String get runUpgradeRiftDescription => 'Gain 25 Rift Burst charge';

  @override
  String get runUpgradeShieldName => 'PHASE SHIELD';

  @override
  String get runUpgradeShieldDescription =>
      'Activate a 1.5-second energy shield';

  @override
  String get damageBuffTitle => 'DAMAGE BOOST';

  @override
  String get fireRateBuffTitle => 'FIRE RATE BOOST';

  @override
  String get rareDamageBuffTitle => 'RARE DAMAGE BOOST';

  @override
  String damageBuff(int percent) {
    return '+$percent% weapon damage';
  }

  @override
  String fireRateBuff(int percent) {
    return '+$percent% fire rate';
  }

  @override
  String comboLabel(int count) {
    return 'COMBO x$count';
  }

  @override
  String scoreMultiplier(Object multiplier) {
    return '${multiplier}x SCORE';
  }

  @override
  String nearMissBonus(int score) {
    return 'NEAR MISS  +$score';
  }

  @override
  String get riftBurst => 'RIFT BURST';

  @override
  String get riftBurstReady => 'BURST READY';

  @override
  String get phaseShift => 'PHASE SHIFT';

  @override
  String get phaseShiftReady => 'SHIFT READY';

  @override
  String equipmentResonance(Object rarity, int count) {
    return '$rarity RESONANCE: $count/4';
  }

  @override
  String get equipmentResonanceBonuses =>
      '2 pieces: +5% fire rate · 3: +8% damage · 4: +1 hull, +5% speed';

  @override
  String get equipmentResonanceNone =>
      'Equip matching rarity gear to unlock set bonuses.';

  @override
  String get shipStandard => 'Interceptor';

  @override
  String get shipStandardDescription =>
      'A balanced, dependable all-round fighter.';

  @override
  String get shipRacer => 'Velocity';

  @override
  String get shipRacerDescription =>
      'A nimble fighter with 20% more movement speed.';

  @override
  String get shipPhoenix => 'Phoenix';

  @override
  String get shipPhoenixDescription =>
      'A fiery attacker with 30% faster fire rate.';

  @override
  String get shipStealth => 'Wraith';

  @override
  String get shipStealthDescription =>
      'A fast stealth fighter with a smaller hit area.';

  @override
  String get shipGuardian => 'Guardian';

  @override
  String get shipGuardianDescription =>
      'A heavy gunship with 50% faster fire rate and a stronger shield.';

  @override
  String get shipSuperFighter => 'Super Fighter';

  @override
  String get shipSuperFighterDescription =>
      'Humanity\'s advanced prototype, powered by captured rift energy and armed with a Phase Lance.';

  @override
  String get shipRiftDancer => 'Rift Dancer';

  @override
  String get shipRiftDancerDescription =>
      'A nimble interceptor whose arc emitters sweep shots back across enemy lanes.';

  @override
  String get shipBastion => 'Bastion';

  @override
  String get shipBastionDescription =>
      'A heavy gunship that blankets a wide lane with flak rounds.';

  @override
  String get weaponBasic => 'Standard Laser';

  @override
  String get weaponBasicDescription => 'A reliable rapid-fire laser.';

  @override
  String get weaponSpread => 'Spread Cannon';

  @override
  String get weaponSpreadDescription => 'Fires three shots in a wide arc.';

  @override
  String get weaponPiercing => 'Piercing Beam';

  @override
  String get weaponPiercingDescription =>
      'A powerful energy beam that pierces enemies.';

  @override
  String get weaponHoming => 'Homing Missiles';

  @override
  String get weaponHomingDescription => 'Missiles seek out the nearest target.';

  @override
  String get weaponRapid => 'Pulse Cannon';

  @override
  String get weaponRapidDescription => 'Fires rapid bursts of light plasma.';

  @override
  String get weaponPlasma => 'Plasma Cannon';

  @override
  String get weaponPlasmaDescription =>
      'Launches heavy plasma shots for high damage.';

  @override
  String get weaponNova => 'Nova Wave';

  @override
  String get weaponNovaDescription =>
      'Unleashes a broad energy wave to clear a path.';

  @override
  String get weaponPhase => 'Riftbreaker Lance';

  @override
  String get weaponPhaseDescription =>
      'A concentrated phase beam that tears through enemy armor.';

  @override
  String get weaponArc => 'Rift Arc Emitters';

  @override
  String get weaponArcDescription =>
      'Fires three curving energy bolts across enemy lanes.';

  @override
  String get weaponFlak => 'Siege Flak Cannons';

  @override
  String get weaponFlakDescription =>
      'Fills a wide fan with heavy explosive rounds.';

  @override
  String get eqCore1Name => 'Standard Reactor Core';

  @override
  String get eqCore1Description => '+10% weapon damage';

  @override
  String get eqCore2Name => 'Azure Plasma Core';

  @override
  String get eqCore2Description => '+25% weapon damage and +5% critical chance';

  @override
  String get eqCore3Name => 'Dark Energy Core';

  @override
  String get eqCore3Description => '+50% weapon damage';

  @override
  String get eqCore4Name => 'Quantum Annihilator Core';

  @override
  String get eqCore4Description => '+100% weapon damage';

  @override
  String get eqArmor1Name => 'Basic Iron Armor';

  @override
  String get eqArmor1Description => '+1 hull; blocks one hit every 20 seconds';

  @override
  String get eqArmor2Name => 'Titan Armor';

  @override
  String get eqArmor2Description =>
      '+2 hull, 14% damage reduction, -10% movement speed';

  @override
  String get eqArmor3Name => 'Dynamic Energy Armor';

  @override
  String get eqArmor3Description =>
      '+3 hull, 20% damage reduction; gains a 1.5-second shield after 5 seconds without damage';

  @override
  String get eqArmor4Name => 'Immortal Armor';

  @override
  String get eqArmor4Description =>
      '+5 hull, 26% damage reduction; +35% damage below 30% hull';

  @override
  String get eqEngine1Name => 'Auxiliary Ion Engine';

  @override
  String get eqEngine1Description => '+10% flight speed';

  @override
  String get eqEngine2Name => 'Warp Engine';

  @override
  String get eqEngine2Description => '+20% flight speed';

  @override
  String get eqEngine3Name => 'Spacefold Drive';

  @override
  String get eqEngine3Description =>
      '+40% flight speed and +10% Rift charge gain';

  @override
  String get eqDrone1Name => 'Sharpshooter Drone';

  @override
  String get eqDrone1Description => 'Fires 1 support shot per second.';

  @override
  String get eqDrone2Name => 'Destroyer Drone';

  @override
  String get eqDrone2Description => 'Fires 3 support shots per second.';

  @override
  String get eqDrone3Name => 'Hunter Drone';

  @override
  String get eqDrone3Description => 'Fires 5 homing shots per second.';

  @override
  String get powerShield => 'Shield';

  @override
  String get powerSideLaser => 'Side lasers';

  @override
  String get powerSpeedBoost => 'Speed boost';

  @override
  String get powerRapidFire => 'Rapid fire';

  @override
  String firingStyle(Object weapon) {
    return 'WEAPON: $weapon';
  }

  @override
  String speedMultiplier(Object multiplier) {
    return 'SPEED ×$multiplier';
  }

  @override
  String damageMultiplier(Object multiplier) {
    return 'DAMAGE ×$multiplier';
  }

  @override
  String get eqDrone4Name => 'Aegis Drone';

  @override
  String get eqDrone4Description =>
      'Shields the ship for 1.5 seconds every 15 seconds';

  @override
  String get eqDrone5Name => 'Mender Drone';

  @override
  String get eqDrone5Description => 'Restores one hull point every 30 seconds';

  @override
  String get combatStats => 'COMBAT STATS';

  @override
  String get statHp => 'HULL';

  @override
  String get statArmor => 'ARMOR';

  @override
  String get statDamage => 'DAMAGE';

  @override
  String get statFireRate => 'FIRE RATE';

  @override
  String get statCrit => 'CRIT';

  @override
  String get statProjectile => 'VOLLEY';

  @override
  String get statDrone => 'DRONE';

  @override
  String get statSkillCharge => 'SKILL CHARGE';

  @override
  String get statMovement => 'MOVEMENT';

  @override
  String get droneRoleNone => 'None';

  @override
  String get droneRoleAttack => 'Attack';

  @override
  String get droneRoleShield => 'Shield';

  @override
  String get droneRoleRepair => 'Repair';

  @override
  String get droneRoleMissile => 'Missile';

  @override
  String get droneRoleLaser => 'Laser';

  @override
  String get criticalHit => 'CRITICAL!';

  @override
  String get statCritDamage => 'CRIT DMG';

  @override
  String get statProjectileSpeed => 'PROJ SPEED';

  @override
  String get statPierce => 'PIERCE';

  @override
  String get statPierceAll => 'ALL';

  @override
  String get statBlast => 'BLAST';

  @override
  String get statSkillCooldown => 'SKILL CD';

  @override
  String get statShield => 'SHIELD';

  @override
  String get statReady => 'READY';

  @override
  String get statOff => 'OFF';
}
