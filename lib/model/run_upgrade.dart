enum RunUpgradeType {
  weaponDamage,
  fireRate,
  multishot,
  critical,
  thrusters,
  hull,
  repair,
  riftCharge,
  shield,
}

class RunUpgradeReward {
  const RunUpgradeReward(this.type);

  final RunUpgradeType type;
}
