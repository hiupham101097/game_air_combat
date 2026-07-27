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

  static int bossScore(int level, {bool miniBoss = false}) {
    final safeLevel = level.clamp(1, 50);
    return (miniBoss ? 180 : 600) + safeLevel * (miniBoss ? 35 : 100);
  }

  /// Laser upgrades are multiplicative: every level is 22% stronger than the
  /// one before it, instead of adding a fixed amount forever.
  static double laserDamageMultiplier(int level) =>
      math.pow(1.22, level.clamp(0, 50)).toDouble();
}
