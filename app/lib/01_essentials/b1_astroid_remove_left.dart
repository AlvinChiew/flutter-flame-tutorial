import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

/// Polygon-based asteroid shape example
class Asteroid extends PositionComponent with HasGameRef<MyGame> {
  /// Vertices for the asteroid
  final vertices = [
    Vector2(0.2, 0.8), // v1
    Vector2(-0.6, 0.6), // v2
    Vector2(-0.8, 0.2), // v3
    Vector2(-0.6, -0.4), // v4
    Vector2(-0.4, -0.8), // v5
    Vector2(0.0, -1.0), // v6
    Vector2(0.4, -0.6), // v7
    Vector2(0.8, -0.8), // v8
    Vector2(1.0, 0.0), // v9
    Vector2(0.4, 0.2), // v10
    Vector2(0.7, 0.6), // v11
  ];

  var velocity = Vector2(0, 25);
  var rotationSpeed = 0.3;
  var paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  @override
  void update(double dt) {
    super.update(dt);

    // Update the position and rotation
    position += velocity * dt;
    var angleDelta = dt * rotationSpeed;
    angle = (angle - angleDelta) % (2 * pi);

    // Remove asteroid if out of bounds
    if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
      gameRef.remove(this);
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Scale the vertices to fit the asteroid's size
    final scaledVertices =
        vertices.map((v) => v.clone()..multiply(size)).toList();

    // Add the PolygonComponent as a child
    add(PolygonComponent(
      scaledVertices,
      position: Vector2
          .zero(), // Set relative position to zero (centered within Asteroid)
      paint: paint,
    ));

    anchor = Anchor.center; // Center the asteroid relative to its position
  }
}

//
// The game class
class MyGame extends FlameGame with DoubleTapDetector, TapDetector {
  // controls if the engine is paused or not
  bool running = true;

  @override
  bool debugMode = true;

  final TextPaint textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 14.0,
      fontFamily: 'Awesome Font',
    ),
  );

  @override
  void onTapUp(TapUpInfo info) {
    // location of user's tap
    final touchPoint = info.eventPosition.global;
    print("<user tap> touchpoint: $touchPoint");

    // Check if tap is handled by any existing asteroid
    final handled = children.any((component) {
      if (component is Asteroid && component.containsPoint(touchPoint)) {
        component.velocity.negate();
        return true;
      }
      return false;
    });

    // Add a new asteroid if the tap is not handled
    if (!handled) {
      add(Asteroid()
        ..position = touchPoint
        ..size = Vector2(100, 100) // Set the size of the asteroid
        ..velocity = Vector2(0, 1).normalized() * 25
        ..paint = (BasicPalette.red.paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1));
    }
  }

  @override
  void onDoubleTap() {
    if (running) {
      pauseEngine();
    } else {
      resumeEngine();
    }

    running = !running;
  }

  @override
  void render(Canvas canvas) {
    textPaint.render(
        canvas, "objects active: ${children.length}", Vector2(10, 20));
    super.render(canvas);
  }
}
