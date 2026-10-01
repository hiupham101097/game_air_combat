# Game Upgrade Audit

Audit scope: the Flutter/SpriteWidget project as it exists before the campaign roadmap is expanded. This repo is not a Unity project, so future data-driven content should use Dart data/config objects and JSON assets rather than Unity `ScriptableObject`s.

## KEEP

| System | Current implementation | Decision |
| --- | --- | --- |
| Player movement | Virtual joystick, direct touch, ship-specific move speed and hit radius | Keep the control model; tune it after combat changes. |
| Shooting and weapons | Ten weapon types, distinct projectile classes, ship-bound firing patterns | Keep the patterns; move their tunable profile values into weapon data. |
| Buff ammo | Timed damage and projectile tint pickup | Keep as a temporary combat buff; do not let pickups replace ship identity. |
| HP, armor, shield | Hull HP, equipment damage reduction, timed shields and armor passives | Keep; route damage through the shared pipeline. |
| Drone and equipment | Four equipment slots, five drone roles/items, rarity and upgrades | Keep existing save IDs and loadout format. Expand slots only in the planned equipment sprint. |
| Enemies and bosses | Scout/destroyer families, elite variants, hazards, seven full boss classes and mini-bosses | Keep the art and encounters; add roles/phase data incrementally. |
| Wave flow | Nine chunks per stage, recovery beats, elite and boss gates | Keep its pacing for the prototype; replace hard-coded scheduling with wave data in Sprint 5. |
| Save and economy | SharedPreferences plus cloud sync; coins, energy stones/cores, upgrades and equipment levels | Keep. Add versioned migrations before campaign progress is persisted. |
| UI and story | Hangar, upgrades, equipment, quests, story screen, English/Vietnamese localization | Keep and extend with mission/campaign screens later. |
| Game feel | Sprite motion, layered explosions, hit sounds, near-miss score feedback, Rift Burst | Keep and extend with hit feedback and a small camera shake. |

## FIX

| Issue found | Change in Sprint 1 |
| --- | --- |
| Weapon subclasses repeated damage multiplication, so modifiers were easy to apply twice or omit. | Added one ordered damage pipeline: base → weapon → temporary buff → critical → target resistance. |
| Critical damage, resistance, projectile speed, pierce and blast radius were absent from the shared combat stats. | Added these stats to `CombatStatBlock` and weapon profiles. |
| Weapon projectile count and spread were duplicated in the firing switch. | Added projectile count/spread to `Weapon` data and used those values to build fan angles. |
| Player armor mitigation was a separate multiplication from outgoing damage. | Routed incoming hull damage through the same resistance stage. |
| Hits had sound feedback but no consistent visible reaction or damage value. | Added enemy/boss hit flash, floating damage numbers and critical callouts. |
| Strong impacts lacked camera feedback. | Added a short, decaying gameplay-layer screen shake on hull hits and critical hits. |
| Armor descriptions and effects did not match the roadmap examples. | Reactive armor still blocks one hit every 20 seconds; Energy Armor now starts its shield after 5 damage-free seconds; Berserker Armor now grants +35% damage below 30% HP. |

## REWORK

| System | Current shape | Planned direction |
| --- | --- | --- |
| Wave spawning | `GameDemoNode.addLevelChunk` branches directly on chunk/level numbers. | `WaveData`, `FormationData` and `EnemyGroupData` in Sprint 5. |
| Boss framework | Boss behavior is spread across separate classes and type switches. | Shared phase/ability/reward data plus reusable boss parts, starting with three bosses in Sprint 6. |
| Progression | Endless stage number and starting-level unlocks are the main route. | One chapter with six missions, objectives and star unlocks before adding more chapters. |
| In-run growth | Boss defeats offer damage/fire-rate choices; XP now opens a three-choice run-upgrade draft. | Expand the nine current upgrade families toward the planned 20 buffs and tune their cadence after play sessions. Keep every draft buff run-only. |
| Boss rewards | Bosses award coins/score and temporary run buffs. | Add persistent boss technology unlocks after the first boss framework is stable. |
| Persistence | Progress is serialized as a flat save object and cloud sync requires an exact progression version. | Add explicit migrations for campaign nodes, research, codex and mastery before those systems ship. |
| Equipment | Four slots and flat stat/passive equipment. | Add weapon/chip slots and stronger effects in Sprint 4, preserving current item IDs. |

## REMOVE

- Remove the unused `isHomingDrone` boolean; drone behavior is selected by `DroneRole` now.
- Remove the current XP counter as a progression destination once Sprint 3 adds in-run level-up choices. Keep save compatibility until that migration lands.
- Do not add parallel per-weapon damage formulas or hard-coded wave schedules while replacing the current implementations.

## ADD

| Addition | Sprint |
| --- | --- |
| Complete normalized combat stats and a single damage pipeline | 1 |
| Six weapon families, projectile upgrade tree and run buffs | 2–3 |
| Weapon evolutions and Codex discovery records | 3 |
| Two drone slots, expanded equipment and armor effects | 4 |
| Enemy roles, formations and elite modifiers | 5 |
| Reusable boss phases/parts and three sample bosses | 6 |
| First chapter, six missions and short story delivery | 7 |
| Boss technology and expanded boss roster | 8 |
| Secret mission, Endless and Boss Rush | 9 |
| Mastery, Codex, daily challenge, balance and polish | 10 |

## Sprint 1 implementation status

- `CombatStatBlock` now covers hull, armor, damage, fire rate, projectile count/speed, critical chance/damage, pierce, explosion radius, movement, drone damage/fire rate, skill charge/cooldown and shield state.
- Weapon profiles own projectile count, spread, speed, pierce and explosion radius; the firing code reads the profile instead of repeating fan counts.
- Direct and splash hits use the same damage resolver and respect target resistance. Player hull damage uses that resolver's resistance stage for equipped armor.
- Player shots now leave short trails; missiles have a longer colored trail. Hit flash, impact explosion, floating damage values, critical callout and restrained screen shake give each hit readable feedback.
- Existing profile count: eight aircraft, ten weapon types, five drone equipment items, several enemy/elite variants and eight full boss classes. Run level-ups now pause combat for one of three randomized modules; damage, fire rate, multishot, critical chance, thrusters, hull, repair, Rift charge and shield modules all reset with the run. Campaign map, mission nodes and persistent boss technology remain future work.

## MVP readiness gap

| MVP target | Current state | Readiness |
| --- | --- | --- |
| One chapter with six missions | Story screen and endless stages exist, but there is no chapter/mission catalog or node selection. | Missing |
| Two mini-bosses and two main bosses | Three mini-boss archetypes and eight full boss classes already run. | Content present; framework still needs rework. |
| Three aircraft and six weapons | Eight aircraft and ten weapon profiles exist. | Content target exceeded. |
| Five drones | Five drone equipment items/roles exist; epic/legendary rarity currently creates two copies of the same drone. | Content present; two independent drone slots are missing. |
| Twenty in-run buffs | XP offers three choices from nine run-only upgrade families; capped stacks and health-aware choices are supported. | Partial; add more effects and balance values through play sessions. |
| Eight evolutions | No weapon evolution registry or discovery Codex exists. | Missing |
| Eight enemy types and five formations | Multiple enemy variants exist, but role and formation choices are still encoded in spawn code. | Partial content; data-driven role/formation system missing. |
| One secret mission | No secret mission/objective chain is registered. | Missing |
