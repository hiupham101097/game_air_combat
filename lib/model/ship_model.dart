import 'package:mini__game2/model/weapon.dart';

enum ShipModel {
  standard,
  sleekRacer,
  phoenix,
  stealth,
  guardian,
  superFighter,
  riftDancer,
  bastion,
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
    Ship(
      model: ShipModel.superFighter,
      name: "Chiến Cơ Siêu Hạng",
      description: "Nguyên mẫu tối mật dùng lõi khe nứt và Pháo Xuyên Không.",
      cost: 150000,
      customAsset: 'assets/ships/ship_superfighter.png',
      speedMultiplier: 1.3,
      fireRateMultiplier: 1.65,
      sizeMultiplier: 0.95,
      weapon: WeaponType.phase,
    ),
    Ship(
      model: ShipModel.riftDancer,
      name: 'Rift Dancer',
      description: 'A nimble interceptor armed with curving arc bolts.',
      cost: 95000,
      customAsset: 'assets/ships/ship_rift_dancer.png',
      speedMultiplier: 1.25,
      fireRateMultiplier: 1.2,
      sizeMultiplier: 0.9,
      weapon: WeaponType.arc,
    ),
    Ship(
      model: ShipModel.bastion,
      name: 'Bastion',
      description: 'A heavy gunship that blankets lanes with flak.',
      cost: 110000,
      customAsset: 'assets/ships/ship_bastion.png',
      speedMultiplier: 0.82,
      fireRateMultiplier: 1.1,
      sizeMultiplier: 1.12,
      weapon: WeaponType.flak,
    ),
  ];
}
