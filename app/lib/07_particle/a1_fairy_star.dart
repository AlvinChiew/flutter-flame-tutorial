import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with PanDetector {
  static const description = 'An example which shows how '
      'ParticleSystemComponent can be added in runtime '
      'following an event, in this example, the mouse '
      'dragging';

  @override
  Future<void> onLoad() async {
    // You can add any initialization code here if needed
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    add(
      ParticleSystemComponent(
        particle: ParticleGenerator.createParticle(
          position: info.eventPosition.global,
        ),
      ),
    );
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // print(children.length);
  // }
}

/// Particle Generator class for accelerated particles with a random
/// downward speed vector
class ParticleGenerator {
  static final Random _random = Random();

  /// Create a single particle
  static Particle createParticle({required Vector2 position}) {
    return AcceleratedParticle(
      lifespan: 0.5,
      position: position,
      speed: Vector2(
        _random.nextDouble() * 200 - 100,
        _random.nextDouble() * 100 + 50,
      ),
      child: CircleParticle(
        radius: 2.0,
        paint: Paint()
          ..color = Color.lerp(
            Colors.yellow,
            Colors.red,
            _random.nextDouble(),
          )!,
      ),
    );
  }
}
