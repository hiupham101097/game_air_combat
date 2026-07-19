import 'package:mini__game2/model/weapon.dart';

enum ShipModel {
  standard,
  sleekRacer,
  phoenix,
  stealth,
  guardian,
}

class Ship {
  final ShipModel model;
  final String name;
  final String description;
  final int cost;
  final String? customAsset; // null = uses spritesheet, else image asset path
  final double speedMultiplier;
  final double fireRateMultiplier; // Affects shot frequency
  final double sizeMultiplier; // Affects hit radius
  final WeaponType weapon;

  const Ship({
    required this.model,
    required this.name,
    required this.description,
    required this.cost,
    this.customAsset,
    this.speedMultiplier = 1.0,
    this.fireRateMultiplier = 1.0,
    this.sizeMultiplier = 1.0,
    required this.weapon,
  });
}

class ShipConfig {
  static const List<Ship> ships = [
    Ship(
      model: ShipModel.standard,
      name: "Chiến cơ Đánh Chặn",
      description: "Chiến cơ tiêu chuẩn, cân bằng và bền bỉ.",
      cost: 0,
      customAsset: null,
      speedMultiplier: 1.0,
      fireRateMultiplier: 1.0,
      weapon: WeaponType.basic,
    ),
    Ship(
      model: ShipModel.sleekRacer,
      name: "Chiến cơ Tốc Độ",
      description: "Chiến cơ khí động học, tăng 20% tốc độ di chuyển.",
      cost: 8000,
      customAsset: 'assets/ships/ship_2.png',
      speedMultiplier: 1.2,
      fireRateMultiplier: 1.0,
      weapon: WeaponType.spread,
    ),
    Ship(
      model: ShipModel.phoenix,
      name: "Phượng Hoàng",
      description: "Chiến cơ tấn công rực lửa, tăng 30% tốc độ bắn.",
      cost: 12000,
      customAsset: 'assets/ships/ship_phoenix.png',
      speedMultiplier: 1.0,
      fireRateMultiplier: 1.3,
      weapon: WeaponType.plasma,
    ),
    Ship(
      model: ShipModel.stealth,
      name: "Tàng Hình",
      description: "Chiến cơ bóng ma, tăng 40% tốc độ và giảm vùng va chạm.",
      cost: 18000,
      customAsset: 'assets/ships/ship_stealth.png',
      speedMultiplier: 1.4,
      fireRateMultiplier: 0.9,
      sizeMultiplier: 0.7,
      weapon: WeaponType.homing,
    ),
    Ship(
      model: ShipModel.guardian,
      name: "Hộ Vệ",
      description:
          "Chiến hạm hạng nặng, chậm hơn nhưng tăng 50% tốc độ bắn và lá chắn bền hơn.",
      cost: 25000,
      customAsset: 'assets/ships/ship_guardian.png',
      speedMultiplier: 0.8,
      fireRateMultiplier: 1.5,
      sizeMultiplier: 1.2,
      weapon: WeaponType.nova,
    ),
  ];
}
