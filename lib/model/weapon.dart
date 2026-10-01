enum WeaponType {
  basic,
  spread,
  piercing,
  homing,
  rapid,
  plasma,
  nova,
  phase,
  arc,
  flak,
}

class Weapon {
  final WeaponType type;
  final String name;
  final String description;
  final int cost;
  final double damageMultiplier;
  final int projectileCount;
  final double spreadDegrees;
  final double projectileSpeedMultiplier;
  final int pierceCount;
  final double explosionRadius;
  final double criticalDamageMultiplier;

  Weapon({
    required this.type,
    required this.name,
    required this.description,
    required this.cost,
    required this.damageMultiplier,
    this.projectileCount = 1,
    this.spreadDegrees = 0.0,
    this.projectileSpeedMultiplier = 1.0,
    this.pierceCount = 0,
    this.explosionRadius = 0.0,
    this.criticalDamageMultiplier = 1.75,
  });
}

class WeaponConfig {
  static final Map<WeaponType, Weapon> weapons = {
    WeaponType.basic: Weapon(
      type: WeaponType.basic,
      name: "Laser cơ bản",
      description: "Laser bắn nhanh tiêu chuẩn.",
      cost: 0,
      damageMultiplier: 1.0,
      projectileCount: 2,
    ),
    WeaponType.spread: Weapon(
      type: WeaponType.spread,
      name: "Súng chùm",
      description: "Bắn 3 viên đạn theo hình quạt.",
      cost: 5000,
      damageMultiplier: 0.8,
      projectileCount: 3,
      spreadDegrees: 40.0,
    ),
    WeaponType.piercing: Weapon(
      type: WeaponType.piercing,
      name: "Tia xuyên phá",
      description: "Tia năng lượng mạnh xuyên qua kẻ địch.",
      cost: 15000,
      damageMultiplier: 2.0,
      pierceCount: -1,
    ),
    WeaponType.homing: Weapon(
      type: WeaponType.homing,
      name: "Tên lửa tự dẫn",
      description: "Tên lửa tự tìm mục tiêu gần nhất.",
      cost: 30000,
      damageMultiplier: 1.5,
      projectileCount: 2,
      spreadDegrees: 20.0,
      projectileSpeedMultiplier: 0.9,
    ),
    WeaponType.rapid: Weapon(
      type: WeaponType.rapid,
      name: "Súng xung kích",
      description: "Bắn liên tiếp các đạn plasma nhẹ.",
      cost: 45000,
      damageMultiplier: 0.75,
      projectileCount: 2,
      projectileSpeedMultiplier: 1.15,
    ),
    WeaponType.plasma: Weapon(
      type: WeaponType.plasma,
      name: "Pháo plasma",
      description: "Phóng đạn plasma lớn, sát thương cao.",
      cost: 65000,
      damageMultiplier: 2.8,
      projectileCount: 2,
      spreadDegrees: 12.0,
      explosionRadius: 18.0,
    ),
    WeaponType.nova: Weapon(
      type: WeaponType.nova,
      name: "Sóng Nova",
      description: "Phóng sóng năng lượng rộng để mở đường.",
      cost: 90000,
      damageMultiplier: 3.5,
      projectileCount: 4,
      spreadDegrees: 44.0,
      explosionRadius: 30.0,
    ),
    WeaponType.phase: Weapon(
      type: WeaponType.phase,
      name: "Pháo Xuyên Không",
      description: "Tia năng lượng xuyên chiều, gây sát thương cực mạnh.",
      cost: 150000,
      damageMultiplier: 2.5,
      projectileSpeedMultiplier: 1.12,
      pierceCount: 1,
    ),
    WeaponType.arc: Weapon(
      type: WeaponType.arc,
      name: 'Rift Arc Emitters',
      description: 'Fires three curving energy bolts across enemy lanes.',
      cost: 95000,
      damageMultiplier: 1.25,
      projectileCount: 3,
      spreadDegrees: 36.0,
      projectileSpeedMultiplier: 1.05,
    ),
    WeaponType.flak: Weapon(
      type: WeaponType.flak,
      name: 'Siege Flak Cannons',
      description: 'Fills a wide fan with heavy explosive rounds.',
      cost: 110000,
      damageMultiplier: 0.95,
      projectileCount: 5,
      spreadDegrees: 68.0,
      projectileSpeedMultiplier: 0.88,
      explosionRadius: 8.0,
    ),
  };
}
