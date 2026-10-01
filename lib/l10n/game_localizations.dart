import 'generated/app_localizations.dart';
import 'package:mini__game2/model/equipment.dart';
import 'package:mini__game2/model/quest.dart';
import 'package:mini__game2/model/run_upgrade.dart';
import 'package:mini__game2/model/ship_model.dart';
import 'package:mini__game2/model/weapon.dart';

extension GameLocalizations on AppLocalizations {
  String runUpgradeName(RunUpgradeType type) => switch (type) {
        RunUpgradeType.weaponDamage => runUpgradeDamageName,
        RunUpgradeType.fireRate => runUpgradeFireName,
        RunUpgradeType.multishot => runUpgradeMultiName,
        RunUpgradeType.critical => runUpgradeCriticalName,
        RunUpgradeType.thrusters => runUpgradeThrusterName,
        RunUpgradeType.hull => runUpgradeHullName,
        RunUpgradeType.repair => runUpgradeRepairName,
        RunUpgradeType.riftCharge => runUpgradeRiftName,
        RunUpgradeType.shield => runUpgradeShieldName,
      };

  String runUpgradeDescription(RunUpgradeType type) => switch (type) {
        RunUpgradeType.weaponDamage => runUpgradeDamageDescription,
        RunUpgradeType.fireRate => runUpgradeFireDescription,
        RunUpgradeType.multishot => runUpgradeMultiDescription,
        RunUpgradeType.critical => runUpgradeCriticalDescription,
        RunUpgradeType.thrusters => runUpgradeThrusterDescription,
        RunUpgradeType.hull => runUpgradeHullDescription,
        RunUpgradeType.repair => runUpgradeRepairDescription,
        RunUpgradeType.riftCharge => runUpgradeRiftDescription,
        RunUpgradeType.shield => runUpgradeShieldDescription,
      };

  String campaignSector(int level) {
    final sector = ((level - 1) ~/ 3).clamp(0, 3).toInt();
    return switch (sector) {
      0 => sectorFrontier,
      1 => sectorRift,
      2 => sectorSiege,
      _ => sectorCore,
    };
  }

  String shipName(ShipModel model) => switch (model) {
        ShipModel.standard => shipStandard,
        ShipModel.sleekRacer => shipRacer,
        ShipModel.phoenix => shipPhoenix,
        ShipModel.stealth => shipStealth,
        ShipModel.guardian => shipGuardian,
        ShipModel.superFighter => shipSuperFighter,
        ShipModel.riftDancer => shipRiftDancer,
        ShipModel.bastion => shipBastion,
      };

  String shipDescription(ShipModel model) => switch (model) {
        ShipModel.standard => shipStandardDescription,
        ShipModel.sleekRacer => shipRacerDescription,
        ShipModel.phoenix => shipPhoenixDescription,
        ShipModel.stealth => shipStealthDescription,
        ShipModel.guardian => shipGuardianDescription,
        ShipModel.superFighter => shipSuperFighterDescription,
        ShipModel.riftDancer => shipRiftDancerDescription,
        ShipModel.bastion => shipBastionDescription,
      };

  String weaponName(WeaponType type) => switch (type) {
        WeaponType.basic => weaponBasic,
        WeaponType.spread => weaponSpread,
        WeaponType.piercing => weaponPiercing,
        WeaponType.homing => weaponHoming,
        WeaponType.rapid => weaponRapid,
        WeaponType.plasma => weaponPlasma,
        WeaponType.nova => weaponNova,
        WeaponType.phase => weaponPhase,
        WeaponType.arc => weaponArc,
        WeaponType.flak => weaponFlak,
      };

  String weaponDescription(WeaponType type) => switch (type) {
        WeaponType.basic => weaponBasicDescription,
        WeaponType.spread => weaponSpreadDescription,
        WeaponType.piercing => weaponPiercingDescription,
        WeaponType.homing => weaponHomingDescription,
        WeaponType.rapid => weaponRapidDescription,
        WeaponType.plasma => weaponPlasmaDescription,
        WeaponType.nova => weaponNovaDescription,
        WeaponType.phase => weaponPhaseDescription,
        WeaponType.arc => weaponArcDescription,
        WeaponType.flak => weaponFlakDescription,
      };

  String equipmentName(EquipmentItem item) => switch (item.id) {
        'core_1' => eqCore1Name,
        'core_2' => eqCore2Name,
        'core_3' => eqCore3Name,
        'core_4' => eqCore4Name,
        'armor_1' => eqArmor1Name,
        'armor_2' => eqArmor2Name,
        'armor_3' => eqArmor3Name,
        'armor_4' => eqArmor4Name,
        'engine_1' => eqEngine1Name,
        'engine_2' => eqEngine2Name,
        'engine_3' => eqEngine3Name,
        'drone_1' => eqDrone1Name,
        'drone_2' => eqDrone2Name,
        'drone_3' => eqDrone3Name,
        'drone_4' => eqDrone4Name,
        'drone_5' => eqDrone5Name,
        _ => item.name,
      };

  String equipmentDescription(EquipmentItem item) => switch (item.id) {
        'core_1' => eqCore1Description,
        'core_2' => eqCore2Description,
        'core_3' => eqCore3Description,
        'core_4' => eqCore4Description,
        'armor_1' => eqArmor1Description,
        'armor_2' => eqArmor2Description,
        'armor_3' => eqArmor3Description,
        'armor_4' => eqArmor4Description,
        'engine_1' => eqEngine1Description,
        'engine_2' => eqEngine2Description,
        'engine_3' => eqEngine3Description,
        'drone_1' => eqDrone1Description,
        'drone_2' => eqDrone2Description,
        'drone_3' => eqDrone3Description,
        'drone_4' => eqDrone4Description,
        'drone_5' => eqDrone5Description,
        _ => item.description,
      };

  String equipmentSlot(EquipmentSlot slot) => switch (slot) {
        EquipmentSlot.core => slotCore,
        EquipmentSlot.armor => slotArmor,
        EquipmentSlot.engine => slotEngine,
        EquipmentSlot.drone => slotDrone,
      };

  String equipmentRarity(Rarity rarity) => switch (rarity) {
        Rarity.common => rarityCommon,
        Rarity.rare => rarityRare,
        Rarity.epic => rarityEpic,
        Rarity.legendary => rarityLegendary,
      };

  String droneRoleName(DroneRole? role) => switch (role) {
        DroneRole.attack => droneRoleAttack,
        DroneRole.shield => droneRoleShield,
        DroneRole.repair => droneRoleRepair,
        DroneRole.missile => droneRoleMissile,
        DroneRole.laser => droneRoleLaser,
        null => droneRoleNone,
      };

  String questDescription(DailyQuest quest) => switch (quest.type) {
        QuestType.playGames => questPlayGames(quest.target),
        QuestType.killEnemies => questKillEnemies(quest.target),
        QuestType.collectCoins => questCollectCoins(quest.target),
      };
}
