import 'dart:math' as math;

import 'package:flutter/material.dart';

enum EquipmentSlot { core, armor, engine, drone }

enum Rarity { common, rare, epic, legendary }

enum ArmorPassive { none, heavy, energyShield, reactive, berserker }

enum DroneRole { attack, shield, repair, missile, laser }

enum GachaResultType { equipment, energyStones, energyCores }

class GachaResult {
  final GachaResultType type;
  final EquipmentItem? equipment;
  final int amount;

  GachaResult({required this.type, this.equipment, this.amount = 0});
}

class EquipmentItem {
  static final math.Random _random = math.Random();
  final String id;
  final String name;
  final EquipmentSlot slot;
  final Rarity rarity;
  final String description;
  final Color color;
  final int price; // 0 = gacha only, >0 = can buy directly

  // Stat bonuses (base values at level 1)
  final double damageMultiplier;
  final int hpBonus;
  final double damageReduction;
  final double speedMultiplier;

  // For drones (base values at level 1)
  final double droneFireRate; // attacks per second
  final double droneDamage;
  final DroneRole droneRole;
  final ArmorPassive armorPassive;
  final double armorMovementMultiplier;
  final double criticalChance;
  final double skillChargeMultiplier;

  // Stat calculations based on level
  double getDamageMultiplier(int level) =>
      damageMultiplier + (damageMultiplier * 0.2 * (level - 1));

  /// Armour adds a little hull integrity. Its main benefit is damage
  /// reduction, so upgrades no longer create hundreds of HP.
  int getHpBonus(int level) =>
      hpBonus + (hpBonus > 0 ? ((level - 1) ~/ 25) : 0);
  double getDamageReduction(int level) =>
      (damageReduction + (level - 1) * 0.0015).clamp(0.0, 0.40).toDouble();
  double getSpeedMultiplier(int level) =>
      speedMultiplier + (speedMultiplier * 0.1 * (level - 1));

  double getDroneFireRate(int level) =>
      droneFireRate; // Keep fire rate constant, scale damage instead
  double getDroneDamage(int level) =>
      droneDamage + (droneDamage * 0.3 * (level - 1));

  // Upgrade cost calculation
  int getUpgradeStoneCost(int currentLevel) => currentLevel * 10;
  int getUpgradeCoreCost(int currentLevel) =>
      (currentLevel / 5).floor() + (currentLevel >= 5 ? 1 : 0);

  const EquipmentItem({
    required this.id,
    required this.name,
    required this.slot,
    required this.rarity,
    required this.description,
    required this.color,
    this.price = 0,
    this.damageMultiplier = 0.0,
    this.hpBonus = 0,
    this.damageReduction = 0.0,
    this.speedMultiplier = 0.0,
    this.droneFireRate = 0.0,
    this.droneDamage = 0.0,
    this.droneRole = DroneRole.attack,
    this.armorPassive = ArmorPassive.none,
    this.armorMovementMultiplier = 1.0,
    this.criticalChance = 0.0,
    this.skillChargeMultiplier = 1.0,
  });

  static Color getColorForRarity(Rarity r) {
    switch (r) {
      case Rarity.common:
        return Colors.white;
      case Rarity.rare:
        return Colors.greenAccent;
      case Rarity.epic:
        return Colors.purpleAccent;
      case Rarity.legendary:
        return Colors.orangeAccent;
    }
  }

  // Pre-defined database of items
  static const List<EquipmentItem> database = [
    // Cores
    EquipmentItem(
      id: 'core_1',
      name: 'Lõi Phản Ứng Thường',
      slot: EquipmentSlot.core,
      rarity: Rarity.common,
      description: 'Tăng 10% sát thương',
      color: Colors.white,
      price: 500,
      damageMultiplier: 0.1,
    ),
    EquipmentItem(
      id: 'core_2',
      name: 'Lõi Plasma Xanh',
      slot: EquipmentSlot.core,
      rarity: Rarity.rare,
      description: 'Tăng 25% sát thương',
      color: Colors.greenAccent,
      damageMultiplier: 0.25,
      criticalChance: 0.05,
    ),
    EquipmentItem(
      id: 'core_3',
      name: 'Lõi Năng Lượng Tối',
      slot: EquipmentSlot.core,
      rarity: Rarity.epic,
      description: 'Tăng 50% sát thương',
      color: Colors.purpleAccent,
      damageMultiplier: 0.5,
    ),
    EquipmentItem(
      id: 'core_4',
      name: 'Lõi Lượng Tử Hủy Diệt',
      slot: EquipmentSlot.core,
      rarity: Rarity.legendary,
      description: 'Tăng 100% sát thương',
      color: Colors.orangeAccent,
      damageMultiplier: 1.0,
    ),

    // Armors
    EquipmentItem(
      id: 'armor_1',
      name: 'Giáp Sắt Cơ Bản',
      slot: EquipmentSlot.armor,
      rarity: Rarity.common,
      description: 'Tăng 1 Máu (HP)',
      color: Colors.white,
      price: 500,
      hpBonus: 1,
      damageReduction: 0.08,
      armorPassive: ArmorPassive.reactive,
    ),
    EquipmentItem(
      id: 'armor_2',
      name: 'Giáp Titan',
      slot: EquipmentSlot.armor,
      rarity: Rarity.rare,
      description: 'Tăng 2 Máu (HP)',
      color: Colors.greenAccent,
      hpBonus: 2,
      damageReduction: 0.14,
      armorPassive: ArmorPassive.heavy,
      armorMovementMultiplier: 0.9,
    ),
    EquipmentItem(
      id: 'armor_3',
      name: 'Giáp Năng Lượng Động',
      slot: EquipmentSlot.armor,
      rarity: Rarity.epic,
      description: 'Tăng 3 Máu (HP)',
      color: Colors.purpleAccent,
      hpBonus: 3,
      damageReduction: 0.20,
      armorPassive: ArmorPassive.energyShield,
    ),
    EquipmentItem(
      id: 'armor_4',
      name: 'Giáp Bất Tử',
      slot: EquipmentSlot.armor,
      rarity: Rarity.legendary,
      description: 'Tăng 5 Máu (HP)',
      color: Colors.orangeAccent,
      hpBonus: 5,
      damageReduction: 0.26,
      armorPassive: ArmorPassive.berserker,
    ),

    // Engines
    EquipmentItem(
      id: 'engine_1',
      name: 'Động Cơ Ion Phụ',
      slot: EquipmentSlot.engine,
      rarity: Rarity.common,
      description: 'Tăng 10% Tốc độ bay',
      color: Colors.white,
      price: 500,
      speedMultiplier: 0.1,
    ),
    EquipmentItem(
      id: 'engine_2',
      name: 'Động Cơ Siêu Tốc',
      slot: EquipmentSlot.engine,
      rarity: Rarity.rare,
      description: 'Tăng 20% Tốc độ bay',
      color: Colors.greenAccent,
      speedMultiplier: 0.2,
    ),
    EquipmentItem(
      id: 'engine_3',
      name: 'Bước Nhảy Không Gian',
      slot: EquipmentSlot.engine,
      rarity: Rarity.epic,
      description: 'Tăng 40% Tốc độ bay',
      color: Colors.purpleAccent,
      speedMultiplier: 0.4,
      skillChargeMultiplier: 1.1,
    ),

    // Drones
    EquipmentItem(
      id: 'drone_1',
      name: 'Drone Bắn Tỉa Nhỏ',
      slot: EquipmentSlot.drone,
      rarity: Rarity.rare,
      description: 'Trợ thủ bắn 1 phát / giây',
      color: Colors.greenAccent,
      droneFireRate: 1.0,
      droneDamage: 5.0,
    ),
    EquipmentItem(
      id: 'drone_2',
      name: 'Drone Hủy Diệt',
      slot: EquipmentSlot.drone,
      rarity: Rarity.epic,
      description: 'Trợ thủ bắn 3 phát / giây',
      color: Colors.purpleAccent,
      droneFireRate: 3.0,
      droneDamage: 8.0,
      droneRole: DroneRole.laser,
    ),
    EquipmentItem(
      id: 'drone_3',
      name: 'Mắt Thần Theo Dõi',
      slot: EquipmentSlot.drone,
      rarity: Rarity.legendary,
      description: 'Bắn đạn đuổi (Homing) 5 phát / giây',
      color: Colors.orangeAccent,
      droneFireRate: 5.0,
      droneDamage: 12.0,
      droneRole: DroneRole.missile,
    ),
    EquipmentItem(
      id: 'drone_4',
      name: 'Shield Drone',
      slot: EquipmentSlot.drone,
      rarity: Rarity.epic,
      description: 'Briefly shields the ship every 15 seconds.',
      color: Colors.cyanAccent,
      droneRole: DroneRole.shield,
    ),
    EquipmentItem(
      id: 'drone_5',
      name: 'Repair Drone',
      slot: EquipmentSlot.drone,
      rarity: Rarity.legendary,
      description: 'Restores one hull point every 30 seconds.',
      color: Colors.lightGreenAccent,
      droneRole: DroneRole.repair,
    ),
  ];

  static EquipmentItem? getById(String id) {
    try {
      return database.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Gacha: returns Equipment, Energy Stones, or Energy Cores
  /// 40% Equipment, 45% Energy Stones, 15% Energy Cores
  static GachaResult rollGacha({bool forceLegendary = false}) {
    if (forceLegendary) {
      return _rollEquipment(Rarity.legendary);
    }

    final randType = _random.nextInt(100);

    if (randType < 45) {
      // 45% Stones
      // Random 10 to 50 stones
      int amount = 10 + _random.nextInt(41);
      return GachaResult(type: GachaResultType.energyStones, amount: amount);
    } else if (randType < 60) {
      // 15% Cores
      // Random 1 to 3 cores
      int amount = 1 + _random.nextInt(3);
      return GachaResult(type: GachaResultType.energyCores, amount: amount);
    } else {
      // 40% Equipment
      final rand = _random.nextInt(100);
      Rarity targetRarity;
      if (rand < 2) {
        targetRarity = Rarity.legendary; // 2% of the 40%
      } else if (rand < 15) {
        targetRarity = Rarity.epic; // 13% of the 40%
      } else if (rand < 50) {
        targetRarity = Rarity.rare; // 35% of the 40%
      } else {
        targetRarity = Rarity.common; // 50% of the 40%
      }

      return _rollEquipment(targetRarity);
    }
  }

  static GachaResult _rollEquipment(Rarity rarity) {
    final pool = database.where((item) => item.rarity == rarity).toList();
    if (pool.isEmpty) {
      return GachaResult(
          type: GachaResultType.equipment, equipment: database.first);
    }
    return GachaResult(
      type: GachaResultType.equipment,
      equipment: pool[_random.nextInt(pool.length)],
    );
  }
}
