enum WeaponType {
  basic,
  spread,
  piercing,
  homing,
  rapid,
  plasma,
  nova,
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
      name: "Laser cơ bản",
      description: "Laser bắn nhanh tiêu chuẩn.",
      cost: 0,
      damageMultiplier: 1.0,
    ),
    WeaponType.spread: Weapon(
      type: WeaponType.spread,
      name: "Súng chùm",
      description: "Bắn 3 viên đạn theo hình quạt.",
      cost: 5000,
      damageMultiplier: 0.8,
    ),
    WeaponType.piercing: Weapon(
      type: WeaponType.piercing,
      name: "Tia xuyên phá",
      description: "Tia năng lượng mạnh xuyên qua kẻ địch.",
      cost: 15000,
      damageMultiplier: 2.0,
    ),
    WeaponType.homing: Weapon(
      type: WeaponType.homing,
      name: "Tên lửa tự dẫn",
      description: "Tên lửa tự tìm mục tiêu gần nhất.",
      cost: 30000,
      damageMultiplier: 1.5,
    ),
    WeaponType.rapid: Weapon(
      type: WeaponType.rapid,
      name: "Súng xung kích",
      description: "Bắn liên tiếp các đạn plasma nhẹ.",
      cost: 45000,
      damageMultiplier: 0.75,
    ),
    WeaponType.plasma: Weapon(
      type: WeaponType.plasma,
      name: "Pháo plasma",
      description: "Phóng đạn plasma lớn, sát thương cao.",
      cost: 65000,
      damageMultiplier: 2.8,
    ),
    WeaponType.nova: Weapon(
      type: WeaponType.nova,
      name: "Sóng Nova",
      description: "Phóng sóng năng lượng rộng để mở đường.",
      cost: 90000,
      damageMultiplier: 3.5,
    ),
  };
}
