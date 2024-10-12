import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'bullet.dart';
import 'joystick_player.dart';

class MyGame extends FlameGame with DragCallbacks, TapCallbacks {
  static const String description = '''
    In this example we showcase how to use the joystick by creating simple
    `CircleComponent`s that serve as the joystick's knob and background.
    Steer the player by using the joystick. We also show how to shoot bullets
    and how to find the angle of the bullet path relative to the ship's angle
  ''';

  late final JoystickPlayer player;
  late final JoystickComponent joystick;
  final TextPaint shipAngleTextPaint = TextPaint();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final knobPaint = BasicPalette.green.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.green.withAlpha(100).paint();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 15, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );

    player = JoystickPlayer(joystick);

    add(player);
    add(joystick);
  }

  @override
  void update(double dt) {
    print("current player angle: ${player.angle}");
    print("number of children in the component tree: ${children.length}");
    super.update(dt);
  }

  @override
  void onTapUp(TapUpEvent event) {
    var velocity = Vector2(0, -1);
    velocity.rotate(player.angle);
    add(Bullet(player.position, velocity, size));
    super.onTapUp(event);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    shipAngleTextPaint.render(
      canvas,
      '${player.angle.toStringAsFixed(5)} radians',
      Vector2(20, size.y - 24),
    );
  }
}
