import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapCallbacks {
  static const description = 'An example which shows how '
      'ParticleSystemComponent can be added in runtime '
      'following a tap event, creating multiple particles';

  @override
  Future<void> onLoad() async {}

  @override
  void onTapUp(TapUpEvent event) {
    add(ParticleSystemComponent(
      particle: ParticleGenerator.createParticleEngine(
        position: event.canvasPosition,
      ),
    ));
  }
}

/// Particle Generator for creation of explosion simulation
class ParticleGenerator {
  /// Create engine particles
  static Particle createParticleEngine({required Vector2 position}) {
    return Particle.generate(
      count: 30, // Increased from 3 to 30 for more particles
      lifespan: 3,
      generator: (i) => AcceleratedParticle(
        acceleration: randomVector()..scale(100),
        speed: randomVector()..scale(200), // Added initial speed
        position: position
            .clone(), // Use clone() to avoid modifying the original position
        child: CircleParticle(
          paint: Paint()..color = Colors.red,
          radius: 2,
        ),
      ),
    );
  }

  static Vector2 randomVector() {
    return (Vector2.random() - Vector2(0.5, 0.5)) * 2;
  }
}
