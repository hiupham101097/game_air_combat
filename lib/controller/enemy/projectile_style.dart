/// Visual families make an enemy's projectile readable before it reaches the
/// player. Widths are in the game's 320-unit coordinate space.
enum EnemyProjectileStyle {
  energyBolt('assets/enemy_projectile_animation.png', 29.0),
  plasmaOrb('assets/enemy_projectile_plasma.png', 30.0),
  seekerMissile('assets/enemy_projectile_seeker.png', 34.0),
  venomGlob('assets/enemy_projectile_venom.png', 30.0),
  riftShard('assets/enemy_projectile_rift.png', 25.0),
  railSlug('assets/enemy_projectile_rail.png', 32.0);

  const EnemyProjectileStyle(this.assetPath, this.displayWidth);

  final String assetPath;
  final double displayWidth;
}
