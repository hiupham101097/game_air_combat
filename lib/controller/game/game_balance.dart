import 'dart:math' as math;

/// Central tuning values for the moment-to-moment combat loop.
class GameBalance {
  const GameBalance._();

  static const double maxRunDamageBonus = 1.0;
  static const double maxRunFireRateBonus = 0.60;

  /// Regular enemies need to keep pace with weapon, equipment and run buffs.
  /// The curve is deliberately steeper than player level growth, while the
  /// spawn caps keep the screen readable.
  static double enemyHealth(int baseHealth, int level,
      [double archetype = 1.0]) {
    final safeLevel = level.clamp(0, 50).toDouble();
    return baseHealth *
        (1.0 + safeLevel * 0.60 + safeLevel * safeLevel * 0.04) *
        archetype;
  }

  /// Smooth quadratic growth keeps later bosses meaningful without abrupt
  /// difficulty jumps between individual boss classes.
  static double bossHealth(int level, [double archetype = 1.0]) {
    final safeLevel = level.clamp(1, 50).toDouble();
    return (145.0 + safeLevel * 26.0 + safeLevel * safeLevel * 2.2) * archetype;
  }

  /// Bosses unlock extra pressure in tiers so every later encounter changes
  /// its rhythm without letting projectile counts or speeds grow forever.
  static int bossAttackTier(int level) =>
      (((level.clamp(1, 60) - 1) ~/ 10).clamp(0, 5)).toInt();

  static int bossExtraProjectiles(int level) =>
      (bossAttackTier(level) ~/ 2).clamp(0, 2).toInt();

  static double bossProjectileSpeed(double baseSpeed, int level) =>
      baseSpeed + bossAttackTier(level) * 0.14;

  /// Preserve a clear opening volley, then tighten later boss attack rhythms
  /// by up to half a second while keeping enough time to dodge.
  static int bossAttackCooldown(int baseFrames, {int level = 1}) {
    final base = baseFrames.toDouble();
    final adjusted = base * 1.4 - bossAttackTier(level) * 6.0;
    return adjusted.clamp(42.0, math.max(42.0, base * 1.4)).round();
  }

  static int bossScore(int level, {bool miniBoss = false}) {
    final safeLevel = level.clamp(1, 50);
    return (miniBoss ? 180 : 600) + safeLevel * (miniBoss ? 35 : 100);
  }

  /// Laser upgrades are multiplicative: every level is 22% stronger than the
  /// one before it, instead of adding a fixed amount forever.
  static double laserDamageMultiplier(int level) =>
      math.pow(1.22, level.clamp(0, 50)).toDouble();
}
