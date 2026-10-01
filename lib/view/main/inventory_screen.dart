import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/ship_model.dart' as ship_models;
import 'package:mini__game2/model/weapon.dart';
import 'package:mini__game2/model/equipment.dart';
import 'package:mini__game2/model/combat_stats.dart';
import 'package:mini__game2/controller/persistant_game_state.dart';
import 'package:mini__game2/l10n/generated/app_localizations.dart';
import 'package:mini__game2/l10n/game_localizations.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _GachaReveal extends StatefulWidget {
  const _GachaReveal({required this.child});

  final Widget child;

  @override
  State<_GachaReveal> createState() => _GachaRevealState();
}

class _GachaRevealState extends State<_GachaReveal> {
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 950), () {
      if (mounted) {
        setState(() => _showResult = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(animation),
          child: child,
        ),
      ),
      child: _showResult
          ? KeyedSubtree(key: const ValueKey('result'), child: widget.child)
          : Dialog(
              key: const ValueKey('opening'),
              backgroundColor: const Color(0xFF0d0d2b),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.cyanAccent, width: 1.5),
              ),
              child: SizedBox(
                width: 250,
                height: 250,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 900),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeInOut,
                  builder: (context, progress, child) {
                    final pulse =
                        0.88 + math.sin(progress * math.pi * 5) * 0.12;
                    final rotation = math.sin(progress * math.pi * 7) * 0.08;
                    return Transform.rotate(
                      angle: rotation,
                      child: Transform.scale(scale: pulse, child: child),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.all_inbox_rounded,
                          color: Colors.amberAccent, size: 96),
                      const SizedBox(height: 18),
                      Text(l10n.chestOpening,
                          style: const TextStyle(
                            fontFamily: 'Orbitron',
                            color: Colors.cyanAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _equipmentSubTab = 0; // 0 = Inventory, 1 = Upgrade

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a1a),
      appBar: AppBar(
        title: Text(l10n.inventoryTitle,
            style: TextStyle(
                fontFamily: 'Orbitron',
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 2)),
        backgroundColor: const Color(0xFF0d0d2b),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on,
                      color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  ValueListenableBuilder<int>(
                    valueListenable: gameState.coinsNotifier,
                    builder: (context, coins, _) => Text(
                      '$coins',
                      style: const TextStyle(
                          fontFamily: 'Orbitron',
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.cyanAccent,
          labelColor: Colors.cyanAccent,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontFamily: 'Orbitron', fontSize: 13),
          tabs: [
            Tab(text: l10n.tabShips),
            Tab(text: l10n.tabEquipment),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHangarTab(),
          _buildEquipmentTab(context),
        ],
      ),
    );
  }

  Widget _buildHangarTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: ship_models.ShipConfig.ships.length,
      itemBuilder: (context, index) {
        final l10n = AppLocalizations.of(context)!;
        final gameText = l10n;
        final ship = ship_models.ShipConfig.ships[index];
        final isUnlocked = gameState.unlockedShips.contains(index);
        final isEquipped = gameState.equippedShip == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isEquipped
                  ? [const Color(0xFF003366), const Color(0xFF006699)]
                  : [const Color(0xFF1a1a2e), const Color(0xFF16213e)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isEquipped ? Colors.cyanAccent : Colors.white12,
              width: isEquipped ? 2 : 1,
            ),
            boxShadow: isEquipped
                ? [
                    const BoxShadow(
                        color: Colors.cyanAccent,
                        blurRadius: 10,
                        spreadRadius: 1)
                  ]
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ship preview
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ship.customAsset != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(ship.customAsset!,
                              fit: BoxFit.contain),
                        )
                      : const Icon(Icons.rocket,
                          color: Colors.white70, size: 48),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(gameText.shipName(ship.model),
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Orbitron',
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(gameText.shipDescription(ship.model),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(
                        l10n.firingStyle(l10n.weaponName(ship.weapon)),
                        style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontFamily: 'Orbitron',
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(l10n.weaponDescription(ship.weapon),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.speed,
                              color: Colors.orangeAccent, size: 14),
                          const SizedBox(width: 4),
                          Text(
                              l10n.speedMultiplier(
                                  ship.speedMultiplier.toStringAsFixed(1)),
                              style: const TextStyle(
                                  color: Colors.orangeAccent, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action button
                Column(
                  children: [
                    if (isEquipped)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(l10n.equipped,
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Orbitron',
                                fontWeight: FontWeight.bold,
                                fontSize: 11)),
                      )
                    else if (isUnlocked)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          setState(() {
                            gameState.equippedShip = index;
                            gameState.store();
                          });
                        },
                        child: Text(l10n.equip,
                            style: const TextStyle(
                                fontFamily: 'Orbitron',
                                color: Colors.white,
                                fontSize: 11)),
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          if (gameState.coins >= ship.cost) {
                            setState(() {
                              gameState.coins -= ship.cost;
                              gameState.unlockedShips.add(index);
                              gameState.store();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(l10n.notEnoughCoins),
                                  backgroundColor: Colors.red),
                            );
                          }
                        },
                        child: Text('${ship.cost}\n${l10n.coins}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Orbitron',
                                color: Colors.white,
                                fontSize: 10)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Kept temporarily for compatibility with existing saved weapon data. The
  // tab is intentionally no longer exposed: firing patterns are ship-bound.
  // ignore: unused_element
  Widget _buildWeaponsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: WeaponConfig.weapons.length,
      itemBuilder: (context, index) {
        final l10n = AppLocalizations.of(context)!;
        final weapon = WeaponConfig.weapons.values.elementAt(index);
        final isUnlocked =
            gameState.unlockedWeapons.contains(weapon.type.index);
        final isEquipped = gameState.equippedWeapon == weapon.type.index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isEquipped
                  ? [const Color(0xFF1a0030), const Color(0xFF330066)]
                  : [const Color(0xFF1a1a2e), const Color(0xFF16213e)],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isEquipped ? Colors.purpleAccent : Colors.white12,
              width: isEquipped ? 2 : 1,
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: const Icon(Icons.flash_on,
                color: Colors.purpleAccent, size: 32),
            title: Text(l10n.weaponName(weapon.type),
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Orbitron',
                    fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.weaponDescription(weapon.type),
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.shield, color: Colors.redAccent, size: 12),
                    const SizedBox(width: 4),
                    Text(
                        l10n.damageMultiplier(
                            weapon.damageMultiplier.toStringAsFixed(1)),
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 11)),
                  ],
                )
              ],
            ),
            trailing: isEquipped
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(l10n.equipped,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Orbitron',
                            fontWeight: FontWeight.bold,
                            fontSize: 10)))
                : isUnlocked
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700),
                        onPressed: () {
                          setState(() {
                            gameState.equippedWeapon = weapon.type.index;
                            gameState.store();
                          });
                        },
                        child: Text(l10n.equip,
                            style: const TextStyle(
                                fontFamily: 'Orbitron', fontSize: 10)),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700),
                        onPressed: () {
                          if (gameState.coins >= weapon.cost) {
                            setState(() {
                              gameState.coins -= weapon.cost;
                              gameState.unlockedWeapons.add(weapon.type.index);
                              gameState.store();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(l10n.notEnoughCoins),
                                  backgroundColor: Colors.red),
                            );
                          }
                        },
                        child: Text('${weapon.cost}\n${l10n.coins}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Orbitron',
                                fontSize: 10)),
                      ),
          ),
        );
      },
    );
  }

  Widget _buildEquipmentTab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rarityCounts = <Rarity, int>{};
    for (final id in gameState.equippedLoadout.values) {
      final item = EquipmentItem.getById(id);
      if (item != null) {
        rarityCounts.update(item.rarity, (count) => count + 1,
            ifAbsent: () => 1);
      }
    }
    final strongestSet = rarityCounts.entries.fold<MapEntry<Rarity, int>?>(
      null,
      (best, entry) => best == null || entry.value > best.value ? entry : best,
    );
    return Column(
      children: [
        // ── Top: Resources & Sub-tabs ──────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFF0d0d2b),
          child: Column(
            children: [
              // Show Energy Stones and Cores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(children: [
                    const Icon(Icons.diamond,
                        color: Colors.cyanAccent, size: 16),
                    const SizedBox(width: 4),
                    Text('${gameState.energyStones}',
                        style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontFamily: 'Orbitron',
                            fontWeight: FontWeight.bold)),
                  ]),
                  Row(children: [
                    const Icon(Icons.bolt, color: Colors.amberAccent, size: 16),
                    const SizedBox(width: 4),
                    Text('${gameState.energyCores}',
                        style: const TextStyle(
                            color: Colors.amberAccent,
                            fontFamily: 'Orbitron',
                            fontWeight: FontWeight.bold)),
                  ]),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF141832),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: strongestSet == null
                        ? Colors.white12
                        : EquipmentItem.getColorForRarity(strongestSet.key)
                            .withAlpha(100),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strongestSet == null
                          ? l10n.equipmentResonanceNone
                          : l10n.equipmentResonance(
                              l10n.equipmentRarity(strongestSet.key),
                              strongestSet.value),
                      style: TextStyle(
                        color: strongestSet == null
                            ? Colors.white54
                            : EquipmentItem.getColorForRarity(strongestSet.key),
                        fontFamily: 'Orbitron',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(l10n.equipmentResonanceBonuses,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 9)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Segmented Control for Sub-tabs
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _equipmentSubTab == 0
                            ? Colors.cyanAccent
                            : Colors.white10,
                        foregroundColor:
                            _equipmentSubTab == 0 ? Colors.black : Colors.white,
                      ),
                      onPressed: () => setState(() => _equipmentSubTab = 0),
                      child: Text(l10n.warehouse,
                          style: const TextStyle(
                              fontFamily: 'Orbitron',
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _equipmentSubTab == 1
                            ? Colors.orangeAccent
                            : Colors.white10,
                        foregroundColor:
                            _equipmentSubTab == 1 ? Colors.black : Colors.white,
                      ),
                      onPressed: () => setState(() => _equipmentSubTab = 1),
                      child: Text(l10n.upgrade,
                          style: const TextStyle(
                              fontFamily: 'Orbitron',
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Content ──────────────────────────────────────────────
        Expanded(
          child: _equipmentSubTab == 0
              ? _buildEquipmentInventory(context)
              : _buildEquipmentUpgrade(context),
        ),
      ],
    );
  }

  Widget _buildEquipmentInventory(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final equippedStats = CombatStatBlock.fromLoadout(
      ship: ship_models.ShipConfig.ships[gameState.equippedShip
          .clamp(0, ship_models.ShipConfig.ships.length - 1)
          .toInt()],
      equipment: gameState.equippedLoadout.values.map((id) {
        final item = EquipmentItem.getById(id);
        return item == null
            ? null
            : EquipmentStatEntry(item, gameState.equipmentLevel(id));
      }).whereType<EquipmentStatEntry>(),
    );
    return Column(
      children: [
        // ── Top: Equipped Loadout ────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          color: const Color(0xFF0d0d2b),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSlot(context, EquipmentSlot.core, Icons.bolt),
                  _buildSlot(context, EquipmentSlot.armor, Icons.shield),
                  _buildSlot(context, EquipmentSlot.engine, Icons.speed),
                  _buildSlot(context, EquipmentSlot.drone, Icons.support_agent),
                ],
              ),
              const SizedBox(height: 9),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.combatStats,
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontFamily: 'Orbitron',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  _statChip(l10n.statHp, '${equippedStats.maxHp}'),
                  _statChip(l10n.statArmor,
                      '${(equippedStats.armorReduction * 100).round()}%'),
                  _statChip(l10n.statDamage,
                      '×${equippedStats.damageMultiplier.toStringAsFixed(2)}'),
                  _statChip(l10n.statFireRate,
                      '×${equippedStats.fireRateMultiplier.toStringAsFixed(2)}'),
                  _statChip(l10n.statCrit,
                      '${(equippedStats.criticalChance * 100).round()}%'),
                  _statChip(l10n.statCritDamage,
                      '×${equippedStats.criticalDamageMultiplier.toStringAsFixed(2)}'),
                  _statChip(
                      l10n.statProjectile, '${equippedStats.projectileCount}'),
                  _statChip(l10n.statProjectileSpeed,
                      '×${equippedStats.projectileSpeedMultiplier.toStringAsFixed(2)}'),
                  _statChip(
                      l10n.statPierce,
                      equippedStats.pierceCount < 0
                          ? l10n.statPierceAll
                          : '${equippedStats.pierceCount}'),
                  _statChip(l10n.statBlast,
                      '${equippedStats.explosionRadius.round()} px'),
                  _statChip(l10n.statDrone,
                      l10n.droneRoleName(equippedStats.droneRole)),
                  _statChip(l10n.statSkillCooldown,
                      '×${equippedStats.skillCooldownMultiplier.toStringAsFixed(2)}'),
                  _statChip(
                    l10n.statShield,
                    equippedStats.armorPassive == ArmorPassive.reactive ||
                            equippedStats.armorPassive ==
                                ArmorPassive.energyShield ||
                            equippedStats.droneRole == DroneRole.shield
                        ? l10n.statReady
                        : l10n.statOff,
                  ),
                  _statChip(l10n.statMovement,
                      '×${equippedStats.movementMultiplier.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 12),
              // ── Gacha Buttons ────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6a0dad),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _rollGacha(context, amount: 1),
                      icon: const Icon(Icons.shopping_basket,
                          color: Colors.white, size: 18),
                      label: Text(l10n.openOne,
                          style: TextStyle(
                              fontFamily: 'Orbitron',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _rollGacha(context, amount: 10),
                      icon: const Icon(Icons.shopping_cart_checkout,
                          color: Colors.white, size: 18),
                      label: Text(l10n.openTen,
                          style: TextStyle(
                              fontFamily: 'Orbitron',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.legendaryGuarantee(gameState.gachaPity),
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontFamily: 'Orbitron',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.cyanAccent),
        // ── Bottom: All Items (show owned + buyable) ─────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: EquipmentItem.database.length,
            itemBuilder: (context, index) {
              final l10n = AppLocalizations.of(context)!;
              final item = EquipmentItem.database[index];
              final isOwned = gameState.ownedEquipment.contains(item.id);
              final slotName = item.slot.toString().split('.').last;
              final isEquipped = gameState.equippedLoadout[slotName] == item.id;
              final canBuy = item.rarity == Rarity.common && item.price > 0;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isOwned
                      ? const Color(0xFF1a1a2e)
                      : const Color(0xFF0f0f1a),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isEquipped
                        ? item.color
                        : (isOwned ? Colors.white24 : Colors.white10),
                    width: isEquipped ? 2 : 1,
                  ),
                ),
                child: Opacity(
                  opacity: isOwned ? 1.0 : 0.55,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Stack(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF12122a),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: item.color.withAlpha(180), width: 1.5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _equipmentIconImage(item.slot,
                                size: 44, tint: isOwned ? item.color : null),
                          ),
                        ),
                        if (!isOwned)
                          const Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(Icons.lock,
                                color: Colors.white70, size: 14),
                          ),
                      ],
                    ),
                    title: Text(l10n.equipmentName(item),
                        style: TextStyle(
                            color: item.color,
                            fontFamily: 'Orbitron',
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.equipmentDescription(item),
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(children: [
                          _rarityBadge(context, item.rarity),
                          const SizedBox(width: 6),
                          Text(l10n.location(l10n.equipmentSlot(item.slot)),
                              style: const TextStyle(
                                  color: Colors.cyanAccent, fontSize: 10)),
                        ]),
                      ],
                    ),
                    trailing: _buildItemAction(
                        context, item, isOwned, isEquipped, canBuy, slotName),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _statChip(String label, String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF151b35),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.cyanAccent.withAlpha(65)),
        ),
        child: Text('$label $value',
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: 'Orbitron',
              fontSize: 8,
              fontWeight: FontWeight.w600,
            )),
      );

  Widget _buildItemAction(BuildContext context, EquipmentItem item,
      bool isOwned, bool isEquipped, bool canBuy, String slotName) {
    final l10n = AppLocalizations.of(context)!;
    if (isOwned && isEquipped) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade800,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
        onPressed: () {
          setState(() {
            gameState.equippedLoadout.remove(slotName);
            gameState.store();
          });
        },
        child: Text(l10n.unequip,
            style: const TextStyle(fontFamily: 'Orbitron', fontSize: 10)),
      );
    }
    if (isOwned) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
        onPressed: () {
          setState(() {
            gameState.equippedLoadout[slotName] = item.id;
            gameState.store();
          });
        },
        child: Text(l10n.equip,
            style: const TextStyle(fontFamily: 'Orbitron', fontSize: 10)),
      );
    }
    if (canBuy) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
        onPressed: () {
          if (gameState.coins >= item.price) {
            setState(() {
              gameState.coins -= item.price;
              if (!gameState.ownedEquipment.contains(item.id)) {
                gameState.ownedEquipment.add(item.id);
              }
              gameState.store();
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.purchaseSuccess(l10n.equipmentName(item))),
              backgroundColor: Colors.green.shade800,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.notEnoughCoins),
              backgroundColor: Colors.red,
            ));
          }
        },
        icon: const Icon(Icons.monetization_on, size: 14, color: Colors.white),
        label: Text('${item.price}',
            style: const TextStyle(
                fontFamily: 'Orbitron', fontSize: 10, color: Colors.white)),
      );
    }
    // Gacha-only
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: item.color.withAlpha(150)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(l10n.openChest,
          style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 10,
              color: item.color.withAlpha(180))),
    );
  }

  void _rollGacha(BuildContext context, {int amount = 1}) {
    final l10n = AppLocalizations.of(context)!;
    final int gachaCost = 1000 * amount;
    if (gameState.coins < gachaCost) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.gachaNeedCoins(gachaCost)),
        backgroundColor: Colors.red,
      ));
      return;
    }
    setState(() {
      gameState.coins -= gachaCost;
    });

    List<GachaResult> results = [];
    for (int i = 0; i < amount; i++) {
      final forceLegendary = gameState.gachaPity >= 79;
      final result = EquipmentItem.rollGacha(forceLegendary: forceLegendary);
      results.add(result);

      if (result.type == GachaResultType.equipment &&
          result.equipment!.rarity == Rarity.legendary) {
        gameState.gachaPity = 0;
      } else {
        gameState.gachaPity++;
      }
    }

    int totalStonesGained = 0;
    int totalCoresGained = 0;
    List<EquipmentItem> equipmentGained = [];
    int duplicatesConverted = 0;

    // Process results
    setState(() {
      for (var result in results) {
        if (result.type == GachaResultType.energyStones) {
          gameState.energyStones += result.amount;
          totalStonesGained += result.amount;
        } else if (result.type == GachaResultType.energyCores) {
          gameState.energyCores += result.amount;
          totalCoresGained += result.amount;
        } else if (result.type == GachaResultType.equipment) {
          // Equipment logic: convert duplicates to 10 stones + 1 core
          final eqId = result.equipment!.id;
          if (gameState.ownedEquipment.contains(eqId)) {
            gameState.energyStones += 10;
            gameState.energyCores += 1;
            totalStonesGained += 10;
            totalCoresGained += 1;
            duplicatesConverted++;
          } else {
            gameState.ownedEquipment.add(eqId);
            equipmentGained.add(result.equipment!);
            if (!gameState.equipmentLevels.containsKey(eqId)) {
              gameState.equipmentLevels[eqId] = 1;
            }
          }
        }
      }
      gameState.store();
    });

    // Show result dialog
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (dialogContext) => _GachaReveal(
        child: Dialog(
          backgroundColor: const Color(0xFF0d0d2b),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.gachaResult,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Orbitron',
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                const SizedBox(height: 20),
                if (amount == 1 &&
                    results.first.type == GachaResultType.equipment &&
                    equipmentGained.isNotEmpty) ...[
                  // Show Single Equipment (only if it wasn't a duplicate)
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF12122a),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: results.first.equipment!.color, width: 3),
                      boxShadow: [
                        BoxShadow(
                            color:
                                results.first.equipment!.color.withAlpha(200),
                            blurRadius: 24,
                            spreadRadius: 6)
                      ],
                    ),
                    child: ClipOval(
                        child: _equipmentIconImage(
                            results.first.equipment!.slot,
                            size: 90,
                            tint: results.first.equipment!.color)),
                  ),
                  const SizedBox(height: 16),
                  _rarityBadge(context, results.first.equipment!.rarity),
                  const SizedBox(height: 8),
                  Text(l10n.equipmentName(results.first.equipment!),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Orbitron',
                          color: results.first.equipment!.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(l10n.equipmentDescription(results.first.equipment!),
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 13)),
                ] else ...[
                  // Show Summary for x10 (or x1 that was stones/cores/duplicate)
                  if (totalStonesGained > 0)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Image.asset(
                        'assets/energy_stones.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Text(l10n.energyStonesGained(totalStonesGained),
                          style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ]),
                  const SizedBox(height: 8),
                  if (totalCoresGained > 0)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Image.asset(
                        'assets/energy_cores.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Text(l10n.energyCoresGained(totalCoresGained),
                          style: const TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ]),
                  if (duplicatesConverted > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(l10n.duplicatesConverted(duplicatesConverted),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ),
                  const SizedBox(height: 16),

                  if (equipmentGained.isNotEmpty) ...[
                    Text(l10n.equipmentReceived,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height:
                          100, // Fixed height for scrollable list of new equipments
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: equipmentGained.length,
                          itemBuilder: (context, idx) {
                            final eq = equipmentGained[idx];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF12122a),
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: eq.color, width: 2),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: _equipmentIconImage(eq.slot,
                                            size: 50, tint: eq.color)),
                                  ),
                                  const SizedBox(height: 4),
                                  _rarityBadge(context, eq.rarity),
                                ],
                              ),
                            );
                          }),
                    ),
                  ]
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      minimumSize: const Size(double.infinity, 44)),
                  onPressed: () =>
                      Navigator.of(dialogContext, rootNavigator: false).pop(),
                  child: Text(l10n.great,
                      style: const TextStyle(
                          fontFamily: 'Orbitron',
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rarityBadge(BuildContext context, Rarity rarity) {
    final l10n = AppLocalizations.of(context)!;
    final Map<Rarity, Map<String, dynamic>> info = {
      Rarity.common: {'label': l10n.rarityCommon, 'color': Colors.white70},
      Rarity.rare: {'label': l10n.rarityRare, 'color': Colors.greenAccent},
      Rarity.epic: {'label': l10n.rarityEpic, 'color': Colors.purpleAccent},
      Rarity.legendary: {
        'label': l10n.rarityLegendary,
        'color': Colors.orangeAccent
      },
    };
    final data = info[rarity]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: data['color'] as Color),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(data['label'] as String,
          style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: data['color'] as Color)),
    );
  }

  /// Returns a widget showing the correct equipment icon image
  Widget _equipmentIconImage(EquipmentSlot slot,
      {double size = 36, Color? tint}) {
    String assetPath;
    switch (slot) {
      case EquipmentSlot.core:
        assetPath = 'assets/equip_core.png';
        break;
      case EquipmentSlot.armor:
        assetPath = 'assets/equip_armor.png';
        break;
      case EquipmentSlot.engine:
        assetPath = 'assets/equip_engine.png';
        break;
      case EquipmentSlot.drone:
        assetPath = 'assets/equip_drone.png';
        break;
    }
    return SizedBox(
      width: size,
      height: size,
      child: ColorFiltered(
        colorFilter: tint != null
            ? ColorFilter.mode(tint.withAlpha(120), BlendMode.srcATop)
            : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildSlot(
      BuildContext context, EquipmentSlot slot, IconData fallbackIcon) {
    final l10n = AppLocalizations.of(context)!;
    String slotName = slot.toString().split('.').last;
    String? equippedId = gameState.equippedLoadout[slotName];
    EquipmentItem? item =
        equippedId != null ? EquipmentItem.getById(equippedId) : null;
    Color slotColor = item?.color ?? Colors.white38;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: const Color(0xFF12122a),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: slotColor, width: 2),
            boxShadow: item != null
                ? [BoxShadow(color: slotColor.withAlpha(140), blurRadius: 12)]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _equipmentIconImage(slot, size: 62, tint: item?.color),
          ),
        ),
        const SizedBox(height: 5),
        Text(l10n.equipmentSlot(slot),
            style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Orbitron',
                fontSize: 9,
                fontWeight: FontWeight.bold)),
        if (item != null)
          SizedBox(
              width: 68,
              child: Text(l10n.equipmentName(item),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: item.color, fontSize: 7),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildEquipmentUpgrade(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ownedItems = gameState.ownedEquipment
        .map((id) => EquipmentItem.getById(id))
        .where((e) => e != null)
        .cast<EquipmentItem>()
        .toList();

    if (ownedItems.isEmpty) {
      return Center(
          child: Text(l10n.noEquipment,
              style: const TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ownedItems.length,
      itemBuilder: (context, index) {
        final item = ownedItems[index];
        final level = gameState.equipmentLevel(item.id);
        final stoneCost = item.getUpgradeStoneCost(level);
        final coreCost = item.getUpgradeCoreCost(level);
        final isMaxLevel = level >= PersistantGameState.maxEquipmentLevel;
        final unlocksAtTen =
            level == 9 && !gameState.isEquipmentUpgradeUnlocked(item.id);
        final canUpgrade = !isMaxLevel &&
            !unlocksAtTen &&
            gameState.energyStones >= stoneCost &&
            gameState.energyCores >= coreCost;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a2e),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: item.color.withAlpha(80)),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF12122a),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: item.color.withAlpha(150)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _equipmentIconImage(item.slot,
                      size: 50, tint: item.color),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.equipmentName(item),
                        style: TextStyle(
                            color: item.color,
                            fontFamily: 'Orbitron',
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    if (unlocksAtTen)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(l10n.upgradeUnlockRequirement,
                            style: const TextStyle(
                                color: Colors.amberAccent, fontSize: 10)),
                      ),
                    if (isMaxLevel)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(l10n.maxLevelReached,
                            style: const TextStyle(
                                color: Colors.amberAccent, fontSize: 10)),
                      ),
                    const SizedBox(height: 4),
                    Text(l10n.levelChange(level, level + 1),
                        style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.diamond,
                            size: 12, color: Colors.cyanAccent),
                        Text(' $stoneCost   ',
                            style: TextStyle(
                                color: gameState.energyStones >= stoneCost
                                    ? Colors.white
                                    : Colors.red,
                                fontSize: 11)),
                        const Icon(Icons.bolt,
                            size: 12, color: Colors.amberAccent),
                        Text(' $coreCost',
                            style: TextStyle(
                                color: gameState.energyCores >= coreCost
                                    ? Colors.white
                                    : Colors.red,
                                fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),

              // Upgrade Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canUpgrade ? Colors.green.shade700 : Colors.white10,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(60, 36),
                ),
                onPressed: canUpgrade
                    ? () {
                        setState(() {
                          gameState.energyStones -= stoneCost;
                          gameState.energyCores -= coreCost;
                          gameState.equipmentLevels[item.id] = (level + 1)
                              .clamp(1, PersistantGameState.maxEquipmentLevel);
                          gameState.store();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(l10n.upgradeSuccess(
                              l10n.equipmentName(item), level + 1)),
                          backgroundColor: Colors.green.shade800,
                        ));
                      }
                    : null,
                child: Text(l10n.upgrade,
                    style: const TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
