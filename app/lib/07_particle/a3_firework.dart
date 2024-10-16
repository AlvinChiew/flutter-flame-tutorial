import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapCallbacks {
  static const description = 'An example which shows how '
      'ParticleSystemComponent can be added in runtime '
      'following a tap event, creating a firework effect';

  @override
  Future<void> onLoad() async {}

  @override
  void onTapUp(TapUpEvent event) {
    add(
      ParticleGenerator.createParticleEngine(
        position: event.canvasPosition,
      ),
    );
  }
}

/// Particle Generator Function for accelerated particles with a random
/// direction vector
class ParticleGenerator {
  static final paints = [
    Colors.amber,
    Colors.amberAccent,
    Colors.red,
    Colors.redAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.blue,
  ].map((color) => Paint()..color = color).toList();

  static final Random rnd = Random();

  static ParticleSystemComponent createParticleEngine(
      {required Vector2 position}) {
    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 50, // Increased for a more vibrant effect
        lifespan: 2,
        generator: (i) {
          final initialSpeed = randomVector()..scale(200);
          final deceleration = initialSpeed * -0.1; // Reduced deceleration
          final gravity = Vector2(0, 40);

          return AcceleratedParticle(
            speed: initialSpeed,
            acceleration: deceleration + gravity,
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final paint = getRandomListElement(paints);
                paint.color = paint.color.withOpacity(1 - particle.progress);

                canvas.drawCircle(
                  Offset.zero,
                  rnd.nextDouble() * particle.progress > 0.6
                      ? rnd.nextDouble() * (50 * particle.progress)
                      : 2 + (3 * particle.progress),
                  paint,
                );
              },
            ),
          );
        },
      ),
    );
  }

  static Vector2 randomVector() {
    return (Vector2.random() - Vector2(0.5, 0.5)) * 2;
  }

  static T getRandomListElement<T>(List<T> list) {
    return list[rnd.nextInt(list.length)];
  }
}
