import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mini__game2/controller/game/game_object_factory.dart';
import 'package:mini__game2/controller/game/game_objects.dart';
import 'package:mini__game2/main.dart';
import 'package:mini__game2/model/ship_model.dart';
import 'package:spritewidget/spritewidget.dart';

class Ship extends GameObject {
  Ship(GameObjectFactory f) : super(f) {
    // Load ship based on equipped ship selection
    final shipConfig = ShipConfig
        .ships[gameState.equippedShip.clamp(0, ShipConfig.ships.length - 1)];
    final usesStandaloneArt = switch (shipConfig.model) {
      ShipModel.superFighter ||
      ShipModel.riftDancer ||
      ShipModel.bastion =>
        true,
      _ => false,
    };

    if (usesStandaloneArt) {
      _sprite = Sprite.fromImage(imageMap[shipConfig.customAsset!]!);
      _sprite.scale = 0.05;
      _sprite.rotation = 0.0;
    } else if (shipConfig.customAsset != null) {
      // Custom fighters are normalized to the original 188px sprite canvas.
      final spriteName = shipConfig.customAsset!.split('/').last;
      _sprite = Sprite(texture: shipSpriteSheet[spriteName]!);
      // The original atlas ship points right; the new fighter art points up.
      _sprite.rotation = 0.0;
      _sprite.scale = 0.3;
    } else {
      // Load default from sprite sheet
      _sprite = Sprite(texture: f.sheet["ship.png"]!);
      _sprite.rotation = -90.0;
      _sprite.scale = 0.3;
    }
    _baseRotation = _sprite.rotation;

    _engineTrail = _ShipEngineTrail();
    addChild(_engineTrail);

    // A short additive plume makes the ship read clearly against the starfield.
    _engineGlow = Sprite(texture: f.sheet["fire_particle.png"]!);
    _engineGlow
      ..position = const Offset(0.0, 34.0)
      ..scale = 0.24
      ..colorOverlay = const Color(0xFF50DFFF)
      ..blendMode = ui.BlendMode.plus;
    addChild(_engineGlow);
    addChild(_sprite);

    if (usesStandaloneArt) {
      for (final wingX in const [-31.0, 31.0]) {
        final wingGlow = Sprite(texture: f.sheet["fire_particle.png"]!)
          ..position = Offset(wingX, 20.0)
          ..scale = 0.16
          ..colorOverlay = shipConfig.model == ShipModel.bastion
              ? const Color(0xFFFFB44A)
              : const Color(0xFF55E8FF)
          ..blendMode = ui.BlendMode.plus;
        addChild(wingGlow);
        final pulse = MotionTween<double>(
          setter: (value) => wingGlow.scale = value,
          start: 0.13,
          end: 0.2,
          duration: 0.42,
        );
        wingGlow.motions
            .run(MotionRepeatForever(motion: MotionSequence(motions: [pulse])));
      }
    }

    _spriteShield = Sprite(texture: f.sheet["shield.png"]!);
    _spriteShield.scale = 0.35;
    _spriteShield.blendMode = ui.BlendMode.plus;
    addChild(_spriteShield);

    radius = 20.0 * shipConfig.sizeMultiplier;
    canBeDamaged = false;
    canDamageShip = false;

    // Apply ship multipliers
    _fireRateMultiplier = shipConfig.fireRateMultiplier;

    // Set start position
    position = const Offset(0.0, 50.0);
  }

  late Sprite _sprite;
  late Sprite _spriteShield;
  late Sprite _engineGlow;
  late _ShipEngineTrail _engineTrail;
  late double _baseRotation;
  double _fireRateMultiplier = 1.0;
  double _bank = 0.0;
  double _time = 0.0;

  double get fireRateMultiplier => _fireRateMultiplier;

  void applyThrust(Offset joystickValue, double scroll,
      {double horizontalOffset = 0.0}) {
    Offset target = Offset(
        (joystickValue.dx * 160.0 * f.playerState.movementMultiplier +
                horizontalOffset)
            .clamp(-150.0, 150.0)
            .toDouble(),
        joystickValue.dy * 220.0 - 250.0 - scroll);
    applyTarget(target);
  }

  void applyTarget(Offset target) {
    Offset oldPos = position;
    double filterFactor = 0.2;

    position = Offset(GameMath.filter(oldPos.dx, target.dx, filterFactor),
        GameMath.filter(oldPos.dy, target.dy, filterFactor));

    final horizontalSpeed = position.dx - oldPos.dx;
    final targetBank = (horizontalSpeed * 4.0).clamp(-14.0, 14.0).toDouble();
    _bank += (targetBank - _bank) * 0.24;
    _sprite.rotation = _baseRotation + _bank;
  }

  @override
  void setupActions() {
    MotionTween rotate = MotionTween<double>(
      setter: (a) => _spriteShield.rotation = a,
      start: 0.0,
      end: 360.0,
      duration: 1.0,
    );
    _spriteShield.motions.run(MotionRepeatForever(motion: rotate));
  }

  @override
  void update(double dt) {
    _time += dt;

    // The plume stretches slightly while moving and flickers softly at idle.
    final movementGlow = (_bank.abs() / 14.0) * 0.06;
    _engineTrail.bank = _bank / 14.0;
    _engineGlow.scale =
        0.22 + (0.025 * (1.0 + math.sin(_time * 18.0))) + movementGlow;
    _engineGlow.opacity = 0.72 + 0.22 * math.sin(_time * 12.0);

    // Briefly blink after taking damage so the invulnerability window is clear.
    _sprite.opacity =
        f.playerState.hpInvincibilityFrames > 0 && math.sin(_time * 42.0) > 0.0
            ? 0.38
            : 1.0;

    // Update shield
    if (f.playerState.shieldActive) {
      if (f.playerState.shieldDeactivating) {
        _spriteShield.visible = !_spriteShield.visible;
      } else {
        _spriteShield.visible = true;
      }
    } else {
      _spriteShield.visible = false;
    }
  }
}

/// Lightweight additive particles make acceleration and ship movement visible
/// without requiring a separate animation sheet for every fighter.
class _ShipEngineTrail extends Node {
  final math.Random _random = math.Random(714);
  final List<_EngineParticle> _particles = [];
  double _emissionTime = 0.0;
  double bank = 0.0;

  @override
  void update(double dt) {
    _emissionTime += dt;
    var emitted = 0;
    while (_emissionTime >= 0.035 && emitted < 4) {
      _emissionTime -= 0.035;
      _emitParticle();
      emitted++;
    }

    for (final particle in _particles) {
      particle.age += dt;
      particle.position += Offset(
        (particle.drift + bank * 18.0) * dt,
        particle.speed * dt,
      );
    }
    _particles.removeWhere((particle) => particle.age >= particle.lifetime);
  }

  void _emitParticle() {
    final hue = _random.nextBool();
    _particles.add(
      _EngineParticle(
        position: Offset((_random.nextDouble() - 0.5) * 9.0, 29.0),
        radius: 2.0 + _random.nextDouble() * 2.2,
        speed: 70.0 + _random.nextDouble() * 54.0,
        drift: (_random.nextDouble() - 0.5) * 23.0,
        lifetime: 0.26 + _random.nextDouble() * 0.16,
        color: hue ? const Color(0xFF52E5FF) : const Color(0xFF9A72FF),
      ),
    );
  }

  @override
  void paint(Canvas canvas) {
    for (final particle in _particles) {
      final progress =
          (particle.age / particle.lifetime).clamp(0.0, 1.0).toDouble();
      final opacity = (1.0 - progress) * 0.78;
      final radius = particle.radius * (1.0 - progress * 0.72);
      canvas.drawCircle(
        particle.position,
        radius * 2.1,
        Paint()
          ..color = particle.color.withValues(alpha: opacity * 0.56)
          ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, radius * 2.0),
      );
      canvas.drawCircle(
        particle.position,
        radius,
        Paint()..color = particle.color.withValues(alpha: opacity),
      );
    }
  }
}

class _EngineParticle {
  _EngineParticle({
    required this.position,
    required this.radius,
    required this.speed,
    required this.drift,
    required this.lifetime,
    required this.color,
  });

  Offset position;
  final double radius;
  final double speed;
  final double drift;
  final double lifetime;
  final Color color;
  double age = 0.0;
}
