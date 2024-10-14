import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/timer.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapDetector {
  static const String description = '''
    This example shows how to use the `Timer`.\n\n
    Tap down to start the countdown timer, it will then count to 5 and then stop
    until you tap the canvas again and it restarts.
  ''';

  final TextPaint textConfig = TextPaint(
    style: const TextStyle(color: Colors.white, fontSize: 20),
  );
  //
  // Countdown timer
  late Timer countdown;
  //
  // Interval timer
  late Timer interval;

  //
  // elapsed number of ticks for the interval timer
  int elapsedTicks = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //
    // counter timer initialization
    countdown = Timer(
      5,
      onTick: () {
        print("countdown timer <tick>");
        if (countdown.finished) {
          print("countdown timer is DONE!");
        }
      },
      autoStart: false,
    );
    //
    // interval timer initialization

    interval = Timer(
      0.01,
      onTick: () => elapsedTicks += 1,
      repeat: true,
    );
    // start the interval timer
    //interval.start();
  }

  @override
  //
  //
  // start the countdown timer
  void onTapDown(TapDownInfo info) {
    countdown.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    //
    // update the timers
    countdown.update(dt);
    interval.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //
    // render the currrent coundown interval setting
    textConfig.render(
      canvas,
      'Countdown: ${countdown.current.toStringAsPrecision(3)}',
      Vector2(30, 100),
    );
    //
    // render the cululative number of seconds elapsed
    // for the interval timer
    textConfig.render(
        canvas, 'Elapsed # ticks: $elapsedTicks', Vector2(30, 130));
  }
}
