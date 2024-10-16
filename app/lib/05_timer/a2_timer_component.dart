import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

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
  late TimerComponent countdown;
  //
  // Interval timer
  late TimerComponent interval;

  //
  // elapsed number of ticks for the interval timer
  int elapsedTicks = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    //
    // countdown timer initialization
    countdown = createCountdownTimer();
    //
    // interval timer initialization
    interval = TimerComponent(
      period: 0.1,
      onTick: () => elapsedTicks += 1,
      repeat: true,
    );
    // start the interval timer
    add(interval);
  }

  @override
  //
  //
  // start the countdown timer
  void onTapDown(TapDownInfo info) {
    countdown = createCountdownTimer();
    add(countdown);
  }

  // @override
  // void update(double dt) {
  //   super.update(dt);
  //   //
  //   // update the timers
  // }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    print("<children> ${children.length}");
    //
    // render the current countdown interval setting
    textConfig.render(
      canvas,
      'Countdown: ${countdown.timer.current.toStringAsPrecision(3)}',
      Vector2(30, 100),
    );
    //
    // render the cumulative number of seconds elapsed
    // for the interval timer
    textConfig.render(
        canvas, 'Elapsed # ticks: $elapsedTicks', Vector2(30, 130));
  }

  //
  //
  // Create an instance of the timer component for countdown
  createCountdownTimer() {
    late TimerComponent countdown;
    //
    // counter timer initialization
    countdown = TimerComponent(
      period: 5,
      removeOnFinish: true,
      onTick: () {
        print("countdown timer <tick>");
        if (countdown.timer.finished) {
          print("countdown timer is DONE!");
        }
      },
      autoStart: true,
    );

    return countdown;
  }
}
