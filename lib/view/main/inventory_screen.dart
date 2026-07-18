import 'package:flutter/material.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/ship_model.dart' as ship_models;
import 'package:mini__game2/model/weapon.dart';
import 'package:mini__game2/model/equipment.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _equipmentSubTab = 0; // 0 = Inventory, 1 = Upgrade

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a1a),
      appBar: AppBar(
        title: const Text('HANGAR & GEAR',
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
                  const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${gameState.coins}',
                    style: const TextStyle(
                        fontFamily: 'Orbitron',
                        color: Colors.amber,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
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
          tabs: const [
            Tab(text: 'HANGAR'),
            Tab(text: 'WEAPONS'),
            Tab(text: 'EQUIPMENT'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHangarTab(),
          _buildWeaponsTab(),
          _buildEquipmentTab(),
        ],
      ),
    );
  }

  Widget _buildHangarTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: ship_models.ShipConfig.ships.length,
      itemBuilder: (context, index) {
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
                ? [const BoxShadow(color: Colors.cyanAccent, blurRadius: 10, spreadRadius: 1)]
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
                          child: Image.asset(ship.customAsset!, fit: BoxFit.contain),
                        )
                      : const Icon(Icons.rocket, color: Colors.white70, size: 48),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ship.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Orbitron',
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(ship.description,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.speed, color: Colors.orangeAccent, size: 14),
                          const SizedBox(width: 4),
                          Text('Speed ×${ship.speedMultiplier.toStringAsFixed(1)}',
                              style: const TextStyle(color: Colors.orangeAccent, fontSize: 12)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('ACTIVE',
                            style: TextStyle(
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
                        child: const Text('EQUIP',
                            style: TextStyle(
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
                              const SnackBar(
                                  content: Text('Not enough coins!'),
                                  backgroundColor: Colors.red),
                            );
                          }
                        },
                        child: Text('${ship.cost}\nCOINS',
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

  Widget _buildWeaponsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: WeaponConfig.weapons.length,
      itemBuilder: (context, index) {
        final weapon = WeaponConfig.weapons.values.elementAt(index);
        final isUnlocked = gameState.unlockedWeapons.contains(weapon.type.index);
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: const Icon(Icons.flash_on, color: Colors.purpleAccent, size: 32),
            title: Text(weapon.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Orbitron',
                    fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(weapon.description,
                    style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.shield, color: Colors.redAccent, size: 12),
                    const SizedBox(width: 4),
                    Text('Damage ×${weapon.damageMultiplier.toStringAsFixed(1)}',
                        style: const TextStyle(color: Colors.redAccent, fontSize: 11)),
                  ],
                )
              ],
            ),
            trailing: isEquipped
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('ACTIVE',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Orbitron',
                            fontWeight: FontWeight.bold,
                            fontSize: 10)))
                : isUnlocked
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                        onPressed: () {
                          setState(() {
                            gameState.equippedWeapon = weapon.type.index;
                            gameState.store();
                          });
                        },
                        child: const Text('EQUIP',
                            style: TextStyle(fontFamily: 'Orbitron', fontSize: 10)),
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
                              const SnackBar(
                                  content: Text('Not enough coins!'),
                                  backgroundColor: Colors.red),
                            );
                          }
                        },
                        child: Text('${weapon.cost}\nCOINS',
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

  Widget _buildEquipmentTab() {
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
                    const Icon(Icons.diamond, color: Colors.cyanAccent, size: 16),
                    const SizedBox(width: 4),
                    Text('${gameState.energyStones}', style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'Orbitron', fontWeight: FontWeight.bold)),
                  ]),
                  Row(children: [
                    const Icon(Icons.bolt, color: Colors.amberAccent, size: 16),
                    const SizedBox(width: 4),
                    Text('${gameState.energyCores}', style: const TextStyle(color: Colors.amberAccent, fontFamily: 'Orbitron', fontWeight: FontWeight.bold)),
                  ]),
                ],
              ),
              const SizedBox(height: 12),
              // Segmented Control for Sub-tabs
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _equipmentSubTab == 0 ? Colors.cyanAccent : Colors.white10,
                        foregroundColor: _equipmentSubTab == 0 ? Colors.black : Colors.white,
                      ),
                      onPressed: () => setState(() => _equipmentSubTab = 0),
                      child: const Text('KHO ĐỒ', style: TextStyle(fontFamily: 'Orbitron', fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _equipmentSubTab == 1 ? Colors.orangeAccent : Colors.white10,
                        foregroundColor: _equipmentSubTab == 1 ? Colors.black : Colors.white,
                      ),
                      onPressed: () => setState(() => _equipmentSubTab = 1),
                      child: const Text('NÂNG CẤP', style: TextStyle(fontFamily: 'Orbitron', fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // ── Content ──────────────────────────────────────────────
        Expanded(
          child: _equipmentSubTab == 0 ? _buildEquipmentInventory() : _buildEquipmentUpgrade(),
        ),
      ],
    );
  }

  Widget _buildEquipmentInventory() {
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
                  _buildSlot(EquipmentSlot.core, Icons.bolt),
                  _buildSlot(EquipmentSlot.armor, Icons.shield),
                  _buildSlot(EquipmentSlot.engine, Icons.speed),
                  _buildSlot(EquipmentSlot.drone, Icons.support_agent),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _rollGacha(context, amount: 1),
                      icon: const Icon(Icons.shopping_basket, color: Colors.white, size: 18),
                      label: const Text('x1 (1000)',
                          style: TextStyle(fontFamily: 'Orbitron', color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _rollGacha(context, amount: 10),
                      icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white, size: 18),
                      label: const Text('x10 (10000)',
                          style: TextStyle(fontFamily: 'Orbitron', color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
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
                            border: Border.all(color: item.color.withAlpha(180), width: 1.5),
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
                            child: Icon(Icons.lock, color: Colors.white70, size: 14),
                          ),
                      ],
                    ),
                    title: Text(item.name,
                        style: TextStyle(
                            color: item.color,
                            fontFamily: 'Orbitron',
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.description,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(children: [
                          _rarityBadge(item.rarity),
                          const SizedBox(width: 6),
                          Text('Slot: ${slotName.toUpperCase()}',
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

  Widget _buildItemAction(BuildContext context, EquipmentItem item,
      bool isOwned, bool isEquipped, bool canBuy, String slotName) {
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
        child: const Text('THÁO',
            style: TextStyle(fontFamily: 'Orbitron', fontSize: 10)),
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
        child: const Text('TRANG BỊ',
            style: TextStyle(fontFamily: 'Orbitron', fontSize: 10)),
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
              content: Text('✅ Đã mua ${item.name}!'),
              backgroundColor: Colors.green.shade800,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('❌ Không đủ Coin!'),
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
      child: Text('GACHA',
          style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 10,
              color: item.color.withAlpha(180))),
    );
  }

  void _rollGacha(BuildContext context, {int amount = 1}) {
    final int gachaCost = 1000 * amount;
    if (gameState.coins < gachaCost) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('❌ Cần $gachaCost Coin để mở Rương!'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    setState(() {
      gameState.coins -= gachaCost;
    });

    List<GachaResult> results = [];
    for (int i = 0; i < amount; i++) {
      results.add(EquipmentItem.rollGacha());
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
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFF0d0d2b),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('✨ KẾT QUẢ MỞ RƯƠNG ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Orbitron',
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const SizedBox(height: 20),
              
              if (amount == 1 && results.first.type == GachaResultType.equipment && equipmentGained.isNotEmpty) ...[
                // Show Single Equipment (only if it wasn't a duplicate)
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF12122a), shape: BoxShape.circle,
                    border: Border.all(color: results.first.equipment!.color, width: 3),
                    boxShadow: [BoxShadow(color: results.first.equipment!.color.withAlpha(200), blurRadius: 24, spreadRadius: 6)],
                  ),
                  child: ClipOval(child: _equipmentIconImage(results.first.equipment!.slot, size: 90, tint: results.first.equipment!.color)),
                ),
                const SizedBox(height: 16),
                _rarityBadge(results.first.equipment!.rarity),
                const SizedBox(height: 8),
                Text(results.first.equipment!.name, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Orbitron', color: results.first.equipment!.color, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text(results.first.equipment!.description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, fontSize: 13)),
              ] else ...[
                // Show Summary for x10 (or x1 that was stones/cores/duplicate)
                if (totalStonesGained > 0)
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.diamond, color: Colors.cyanAccent, size: 24),
                    const SizedBox(width: 8),
                    Text('+$totalStonesGained Đá Năng Lượng', style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                  ]),
                const SizedBox(height: 8),
                if (totalCoresGained > 0)
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.bolt, color: Colors.amberAccent, size: 24),
                    const SizedBox(width: 8),
                    Text('+$totalCoresGained Lõi Năng Lượng', style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                  ]),
                if (duplicatesConverted > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('($duplicatesConverted trùng lặp đã được quy đổi)', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  ),
                const SizedBox(height: 16),
                
                if (equipmentGained.isNotEmpty) ...[
                  const Text('TRANG BỊ MỚI NHẬN:', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100, // Fixed height for scrollable list of new equipments
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: equipmentGained.length,
                      itemBuilder: (context, idx) {
                        final eq = equipmentGained[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            children: [
                              Container(
                                width: 50, height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF12122a), borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: eq.color, width: 2),
                                ),
                                child: ClipRRect(borderRadius: BorderRadius.circular(6), child: _equipmentIconImage(eq.slot, size: 50, tint: eq.color)),
                              ),
                              const SizedBox(height: 4),
                              _rarityBadge(eq.rarity),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                ]
              ],
              
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    minimumSize: const Size(double.infinity, 44)),
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('TUYỆT VỜI!',
                    style: TextStyle(
                        fontFamily: 'Orbitron',
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rarityBadge(Rarity rarity) {
    final Map<Rarity, Map<String, dynamic>> info = {
      Rarity.common: {'label': 'COMMON', 'color': Colors.white70},
      Rarity.rare: {'label': 'RARE', 'color': Colors.greenAccent},
      Rarity.epic: {'label': 'EPIC', 'color': Colors.purpleAccent},
      Rarity.legendary: {'label': 'LEGENDARY', 'color': Colors.orangeAccent},
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
  Widget _equipmentIconImage(EquipmentSlot slot, {double size = 36, Color? tint}) {
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

  Widget _buildSlot(EquipmentSlot slot, IconData fallbackIcon) {
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
            child: _equipmentIconImage(slot,
                size: 62, tint: item?.color),
          ),
        ),
        const SizedBox(height: 5),
        Text(slotName.toUpperCase(),
            style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Orbitron',
                fontSize: 9,
                fontWeight: FontWeight.bold)),
        if (item != null)
          SizedBox(
            width: 68,
            child: Text(item.name,
                textAlign: TextAlign.center,
                style: TextStyle(color: item.color, fontSize: 7),
                maxLines: 2,
                overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildEquipmentUpgrade() {
    final ownedItems = gameState.ownedEquipment
        .map((id) => EquipmentItem.getById(id))
        .where((e) => e != null)
        .cast<EquipmentItem>()
        .toList();

    if (ownedItems.isEmpty) {
      return const Center(child: Text('Chưa sở hữu trang bị nào!', style: TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ownedItems.length,
      itemBuilder: (context, index) {
        final item = ownedItems[index];
        final level = gameState.equipmentLevels[item.id] ?? 1;
        final stoneCost = item.getUpgradeStoneCost(level);
        final coreCost = item.getUpgradeCoreCost(level);
        final canUpgrade = gameState.energyStones >= stoneCost && gameState.energyCores >= coreCost;

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
                  child: _equipmentIconImage(item.slot, size: 50, tint: item.color),
                ),
              ),
              const SizedBox(width: 12),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: TextStyle(color: item.color, fontFamily: 'Orbitron', fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('Level $level ➔ ${level + 1}', style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.diamond, size: 12, color: Colors.cyanAccent),
                        Text(' $stoneCost   ', style: TextStyle(color: gameState.energyStones >= stoneCost ? Colors.white : Colors.red, fontSize: 11)),
                        const Icon(Icons.bolt, size: 12, color: Colors.amberAccent),
                        Text(' $coreCost', style: TextStyle(color: gameState.energyCores >= coreCost ? Colors.white : Colors.red, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Upgrade Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canUpgrade ? Colors.green.shade700 : Colors.white10,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(60, 36),
                ),
                onPressed: canUpgrade ? () {
                  setState(() {
                    gameState.energyStones -= stoneCost;
                    gameState.energyCores -= coreCost;
                    gameState.equipmentLevels[item.id] = level + 1;
                    gameState.store();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('✨ Đã nâng cấp ${item.name} lên Level ${level + 1}!'),
                    backgroundColor: Colors.green.shade800,
                  ));
                } : null,
                child: const Text('NÂNG', style: TextStyle(fontFamily: 'Orbitron', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
