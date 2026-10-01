import 'dart:math' as math;

/// Result of one hit after each combat modifier has been applied.
class CombatDamageResult {
  const CombatDamageResult({
    required this.baseDamage,
    required this.afterWeapon,
    required this.afterBuff,
    required this.afterCritical,
    required this.finalDamage,
    required this.isCritical,
  });

  final double baseDamage;
  final double afterWeapon;
  final double afterBuff;
  final double afterCritical;
  final double finalDamage;
  final bool isCritical;
}

/// Shared damage order for player weapons, splash damage, and ship armour.
///
/// Base damage -> weapon modifier -> temporary buff -> critical -> resistance.
class CombatDamagePipeline {
  CombatDamagePipeline._();

  static final math.Random _random = math.Random();

  static CombatDamageResult resolve({
    required double baseDamage,
    double weaponModifier = 1.0,
    double buffModifier = 1.0,
    double criticalChance = 0.0,
    double criticalDamageMultiplier = 1.0,
    double targetResistance = 0.0,
    double? criticalRoll,
  }) {
    final safeBaseDamage = math.max(0.0, baseDamage);
    final afterWeapon = safeBaseDamage * math.max(0.0, weaponModifier);
    final afterBuff = afterWeapon * math.max(0.0, buffModifier);
    final critChance = criticalChance.clamp(0.0, 1.0).toDouble();
    final isCritical =
        critChance > 0.0 && (criticalRoll ?? _random.nextDouble()) < critChance;
    final afterCritical = afterBuff *
        (isCritical ? math.max(1.0, criticalDamageMultiplier) : 1.0);
    final resistance = targetResistance.clamp(0.0, 0.95).toDouble();

    return CombatDamageResult(
      baseDamage: safeBaseDamage,
      afterWeapon: afterWeapon,
      afterBuff: afterBuff,
      afterCritical: afterCritical,
      finalDamage: afterCritical * (1.0 - resistance),
      isCritical: isCritical,
    );
  }
}
