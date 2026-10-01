import 'package:mini__game2/model/equipment.dart';
import 'package:mini__game2/model/ship_model.dart';
import 'package:mini__game2/model/weapon.dart';

class EquipmentStatEntry {
  const EquipmentStatEntry(this.item, this.level);

  final EquipmentItem item;
  final int level;
}

/// One normalized view of persistent and run-time combat attributes.
class CombatStatBlock {
  const CombatStatBlock({
    required this.currentHp,
    required this.maxHp,
    required this.armorReduction,
    required this.damageMultiplier,
    required this.fireRateMultiplier,
    required this.projectileCount,
    required this.projectileSpeedMultiplier,
    required this.criticalChance,
    required this.criticalDamageMultiplier,
    required this.pierceCount,
    required this.explosionRadius,
    required this.droneRole,
    required this.droneFireRate,
    required this.droneDamage,
    required this.skillChargeMultiplier,
    required this.skillCooldownMultiplier,
    required this.movementMultiplier,
    required this.armorPassive,
    required this.shieldActive,
    required this.shieldFrames,
  });

  factory CombatStatBlock.fromLoadout({
    required Ship ship,
    required Iterable<EquipmentStatEntry> equipment,
    int? currentHp,
    double runDamageBonus = 0.0,
    double runFireRateBonus = 0.0,
    int extraProjectileCount = 0,
    bool shieldActive = false,
    int shieldFrames = 0,
  }) {
    var hpBonus = 0;
    var damageBonus = 0.0;
    var speedBonus = 0.0;
    var armorReduction = 0.0;
    var criticalChance = 0.03;
    var skillChargeMultiplier = 1.0;
    var armorMovementMultiplier = 1.0;
    var armorPassive = ArmorPassive.none;
    EquipmentItem? drone;
    var droneLevel = 1;
    final rarityCounts = <Rarity, int>{};

    for (final entry in equipment) {
      final item = entry.item;
      final level = entry.level;
      rarityCounts.update(item.rarity, (count) => count + 1, ifAbsent: () => 1);
      hpBonus += item.getHpBonus(level);
      damageBonus += item.getDamageMultiplier(level);
      speedBonus += item.getSpeedMultiplier(level);
      armorReduction += item.getDamageReduction(level);
      criticalChance += item.criticalChance;
      skillChargeMultiplier *= item.skillChargeMultiplier;

      if (item.slot == EquipmentSlot.armor) {
        armorPassive = item.armorPassive;
        armorMovementMultiplier = item.armorMovementMultiplier;
      } else if (item.slot == EquipmentSlot.drone) {
        drone = item;
        droneLevel = level;
      }
    }

    final strongestSetCount = rarityCounts.values.fold<int>(
      0,
      (strongest, count) => count > strongest ? count : strongest,
    );
    if (strongestSetCount >= 3) damageBonus += 0.08;
    if (strongestSetCount >= 4) {
      hpBonus += 1;
      speedBonus += 0.05;
    }

    final maxHp = 3 + hpBonus;
    final weapon = WeaponConfig.weapons[ship.weapon];
    return CombatStatBlock(
      currentHp: (currentHp ?? maxHp).clamp(0, maxHp).toInt(),
      maxHp: maxHp,
      armorReduction: armorReduction.clamp(0.0, 0.40).toDouble(),
      damageMultiplier: 1.0 + damageBonus + runDamageBonus,
      fireRateMultiplier: ship.fireRateMultiplier *
          (strongestSetCount >= 2 ? 1.05 : 1.0) *
          (1.0 + runFireRateBonus),
      projectileCount: (weapon?.projectileCount ?? 1) + extraProjectileCount,
      projectileSpeedMultiplier: weapon?.projectileSpeedMultiplier ?? 1.0,
      criticalChance: criticalChance.clamp(0.0, 0.50).toDouble(),
      criticalDamageMultiplier: weapon?.criticalDamageMultiplier ?? 1.75,
      pierceCount: weapon?.pierceCount ?? 0,
      explosionRadius: weapon?.explosionRadius ?? 0.0,
      droneRole: drone?.droneRole,
      droneFireRate: drone?.getDroneFireRate(droneLevel) ?? 0.0,
      droneDamage: drone?.getDroneDamage(droneLevel) ?? 0.0,
      skillChargeMultiplier: skillChargeMultiplier,
      skillCooldownMultiplier: 1.0 / skillChargeMultiplier,
      movementMultiplier:
          ship.speedMultiplier * (1.0 + speedBonus) * armorMovementMultiplier,
      armorPassive: armorPassive,
      shieldActive: shieldActive,
      shieldFrames: shieldFrames,
    );
  }

  final int currentHp;
  final int maxHp;
  final double armorReduction;
  final double damageMultiplier;
  final double fireRateMultiplier;
  final int projectileCount;
  final double projectileSpeedMultiplier;
  final double criticalChance;
  final double criticalDamageMultiplier;

  /// `-1` means the weapon pierces every target until the projectile expires.
  final int pierceCount;
  final double explosionRadius;
  final DroneRole? droneRole;
  final double droneFireRate;
  final double droneDamage;
  final double skillChargeMultiplier;
  final double skillCooldownMultiplier;
  final double movementMultiplier;
  final ArmorPassive armorPassive;
  final bool shieldActive;
  final int shieldFrames;

  CombatStatBlock withRuntime({
    int? maxHp,
    int? currentHp,
    double? damageMultiplier,
    double? fireRateMultiplier,
    double? criticalChance,
    int? projectileCount,
    double? movementMultiplier,
    bool? shieldActive,
    int? shieldFrames,
  }) =>
      CombatStatBlock(
        currentHp: currentHp ?? this.currentHp,
        maxHp: maxHp ?? this.maxHp,
        armorReduction: armorReduction,
        damageMultiplier: damageMultiplier ?? this.damageMultiplier,
        fireRateMultiplier: fireRateMultiplier ?? this.fireRateMultiplier,
        criticalChance: criticalChance ?? this.criticalChance,
        projectileCount: projectileCount ?? this.projectileCount,
        projectileSpeedMultiplier: projectileSpeedMultiplier,
        droneRole: droneRole,
        droneFireRate: droneFireRate,
        droneDamage: droneDamage,
        criticalDamageMultiplier: criticalDamageMultiplier,
        pierceCount: pierceCount,
        explosionRadius: explosionRadius,
        skillChargeMultiplier: skillChargeMultiplier,
        skillCooldownMultiplier: skillCooldownMultiplier,
        movementMultiplier: movementMultiplier ?? this.movementMultiplier,
        armorPassive: armorPassive,
        shieldActive: shieldActive ?? this.shieldActive,
        shieldFrames: shieldFrames ?? this.shieldFrames,
      );
}
