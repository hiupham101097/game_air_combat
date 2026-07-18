enum WeaponType {
  basic,
  spread,
  piercing,
  homing,
}

class Weapon {
  final WeaponType type;
  final String name;
  final String description;
  final int cost;
  final double damageMultiplier;

  Weapon({
    required this.type,
    required this.name,
    required this.description,
    required this.cost,
    required this.damageMultiplier,
  });
}

class WeaponConfig {
  static final Map<WeaponType, Weapon> weapons = {
    WeaponType.basic: Weapon(
      type: WeaponType.basic,
      name: "Basic Laser",
      description: "Standard rapid-fire laser.",
      cost: 0,
      damageMultiplier: 1.0,
    ),
    WeaponType.spread: Weapon(
      type: WeaponType.spread,
      name: "Spread Gun",
      description: "Fires 3 projectiles in an arc.",
      cost: 5000,
      damageMultiplier: 0.8,
    ),
    WeaponType.piercing: Weapon(
      type: WeaponType.piercing,
      name: "Piercing Beam",
      description: "A powerful beam that passes through enemies.",
      cost: 15000,
      damageMultiplier: 2.0,
    ),
    WeaponType.homing: Weapon(
      type: WeaponType.homing,
      name: "Homing Missiles",
      description: "Missiles that seek out nearby targets.",
      cost: 30000,
      damageMultiplier: 1.5,
    ),
  };
}
