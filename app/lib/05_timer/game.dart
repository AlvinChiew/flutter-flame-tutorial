import 'my_collidable.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

/// Solution to case-study #5 exercise #2
///
/// Timer based class which simulates a generation of collidable bounding balls.
///
/// With each 1 second tick we generate a new ball in a random position which
/// travels in a random direction with a random velocity.
class MyGame extends FlameGame with HasCollisionDetection {
  static const String description = '''
    This example shows how to use the `Timer`.\n\n
    Timer based class, which simulates a generation of collidable bouncing balls.
    With each 1 second tick, we generate a new ball in a random position which
    travels in a rnadom direction with a random velocity.
    We also generate a boucning sound and add a a text above each ball to 
    show how much life is left for the ball.
  ''';

  @override
  bool debugMode = false;

  /// Number of sumulated balls as well as the number of ticks for our timer
  static const int numSimulationObjects = 10;

  /// a set of observed collisions
  ///
  /// We use this set to check if a given collision between two objects was
  /// already observed and create a single bounce sound for such a collision.
  Set<String> observedCollisions = <String>{};

  final TextPaint textConfig = TextPaint(
    style: const TextStyle(color: Colors.white, fontSize: 20),
  );
  //
  // Interval timer
  late TimerComponent interval;

  //
  // elapsed number of ticks for the interval timer
  int elapsedTicks = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    ///
    /// interval timer initialization

    interval = TimerComponent(
      period: 1.00,
      removeOnFinish: true,
      autoStart: true,
      onTick: () {
        /// generate a new ball in a random position with a random
        /// speed and random direction
        ///
        ///

        /// set margins to be 50 in each direction
        Vector2 rndPosition =
            Utils.generateRandomPosition(size, Vector2.all(50));

        /// generate random direction vector
        Vector2 rndVelocity = Utils.generateRandomDirection();

        /// set the min max range for speed to be 100 - 500
        double rndSpeed = Utils.generateRandomSpeed(100, 300);

        /// generate the ball in the random position with random velocity
        MyCollidable ball =
            MyCollidable(rndPosition, rndVelocity, rndSpeed, elapsedTicks);

        /// add the ball to the children of the game
        add(ball);

        /// track ticks
        elapsedTicks++;

        /// test the end condition
        if (elapsedTicks > numSimulationObjects) {
          interval.timer.stop();
          remove(interval);
        }
      },
      repeat: true,
    );

    add(interval);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //
    // render the cululative number of seconds elapsed
    // for the interval timer
    textConfig.render(
        canvas, 'Elapsed # ticks: $elapsedTicks', Vector2(10, 30));
    textConfig.render(
        canvas, 'Number of objects alive: ${children.length}', Vector2(10, 60));
    // textConfig.render(canvas, children.join('|'), Vector2(10, 90));
    // print(children.join('|'));
  }
}
