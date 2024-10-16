import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import 'custom_particle.dart';

class MyGame extends FlameGame with TapCallbacks {
  static const description =
      'Ground-level explosion simulation with accurate tap positioning.';
  static const gravity = 130.0;
  static const airFriction = -10.0;

  @override
  void onTapUp(TapUpEvent event) {
    add(
      ParticleGenerator.createParticleEngine(
        position: event.canvasPosition,
      ),
    );
  }
}

class ParticleGenerator {
  static ParticleSystemComponent createParticleEngine(
      {required Vector2 position}) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 25,
        lifespan: 10,
        generator: (i) {
          final initialSpeed = randomVectorUpperQuads()..scale(300);
          final deceleration = getDeceleration(initialSpeed);

          return CustomParticle(
            child: CircleParticle(
              radius: 2,
              paint: Paint()..color = Colors.red,
            ),
            position: position,
            speed: initialSpeed,
            acceleration: deceleration,
            lifespan: 10,
            removeParticleTest: (initialPos, currentPos) =>
                removeParticleTest(position, currentPos),
          );
        },
      ),
    );
  }

  static Vector2 randomVectorUpperQuads() {
    final Random rnd = Random();
    double numX = rnd.nextDouble() / 4;
    double numY = -rnd.nextDouble() * 0.75;
    if (rnd.nextBool()) {
      numX *= -1;
    }
    return Vector2(numX, numY);
  }

  static bool removeParticleTest(
      Vector2 initialPosition, Vector2 currentPosition) {
    return currentPosition.y > initialPosition.y;
  }

  static Vector2 getDeceleration(Vector2 initialSpeed) {
    return Vector2(
        initialSpeed.x < 0 ? MyGame.airFriction : -MyGame.airFriction,
        MyGame.gravity);
  }
}
