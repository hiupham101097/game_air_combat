import 'package:flutter_test/flutter_test.dart';
import 'package:mini__game2/controller/game/game_balance.dart';

void main() {
  group('boss difficulty scaling', () {
    test('unlocks attack pressure gradually and caps projectile growth', () {
      expect(GameBalance.bossAttackTier(10), 0);
      expect(GameBalance.bossAttackTier(20), 1);
      expect(GameBalance.bossAttackTier(30), 2);
      expect(GameBalance.bossAttackTier(60), 5);

      expect(GameBalance.bossExtraProjectiles(20), 0);
      expect(GameBalance.bossExtraProjectiles(30), 1);
      expect(GameBalance.bossExtraProjectiles(50), 2);
      expect(GameBalance.bossExtraProjectiles(100), 2);

      expect(GameBalance.bossProjectileSpeed(4.0, 10), 4.0);
      expect(GameBalance.bossProjectileSpeed(4.0, 60), closeTo(4.7, 0.001));
    });

    test('shortens later cooldowns but preserves a dodge window', () {
      expect(GameBalance.bossAttackCooldown(90, level: 10), 126);
      expect(GameBalance.bossAttackCooldown(90, level: 60), 96);
      expect(GameBalance.bossAttackCooldown(30, level: 60), 42);
    });
  });
}
