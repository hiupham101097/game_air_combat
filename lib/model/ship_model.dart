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

  const Ship({
    required this.model,
    required this.name,
    required this.description,
    required this.cost,
    this.customAsset,
    this.speedMultiplier = 1.0,
    this.fireRateMultiplier = 1.0,
    this.sizeMultiplier = 1.0,
  });
}

class ShipConfig {
  static const List<Ship> ships = [
    Ship(
      model: ShipModel.standard,
      name: "Interceptor",
      description: "Standard combat ship. Reliable and battle-tested.",
      cost: 0,
      customAsset: null,
      speedMultiplier: 1.0,
      fireRateMultiplier: 1.0,
    ),
    Ship(
      model: ShipModel.sleekRacer,
      name: "Sleek Racer",
      description: "High-speed aerodynamic fighter. +20% movement speed.",
      cost: 8000,
      customAsset: 'assets/ships/ship_2.png',
      speedMultiplier: 1.2,
      fireRateMultiplier: 1.0,
    ),
    Ship(
      model: ShipModel.phoenix,
      name: "Phoenix",
      description: "Fiery assault fighter. +30% fire rate, normal speed.",
      cost: 12000,
      customAsset: 'assets/ships/ship_phoenix.png',
      speedMultiplier: 1.0,
      fireRateMultiplier: 1.3,
    ),
    Ship(
      model: ShipModel.stealth,
      name: "Stealth",
      description: "Ghost ship. +40% speed, smaller hit radius.",
      cost: 18000,
      customAsset: 'assets/ships/ship_stealth.png',
      speedMultiplier: 1.4,
      fireRateMultiplier: 0.9,
      sizeMultiplier: 0.7,
    ),
    Ship(
      model: ShipModel.guardian,
      name: "Guardian",
      description:
          "Heavy battlecruiser. Slower but +50% fire rate & shields last longer.",
      cost: 25000,
      customAsset: 'assets/ships/ship_guardian.png',
      speedMultiplier: 0.8,
      fireRateMultiplier: 1.5,
      sizeMultiplier: 1.2,
    ),
  ];
}
