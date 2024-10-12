import 'dart:async';

import 'package:flame/debug.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapDetector {
  @override
  bool debugMode = true;

  final regular = TextPaint(
    style: TextStyle(
      fontSize: 48.0,
      color: BasicPalette.teal.color,
    ),
  );

  @override
  Future<void> onLoad() async {
    await addAll([
      TextComponent(
        text: 'Hello, Flame',
        position: Vector2.all(16.0),
      ),
      FpsTextComponent(
        position: Vector2(0, size.y - 50),
        textRenderer: regular,
      ),
      TimeTrackComponent(),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPaint(Paint()..color = Colors.black);
    super.render(canvas);
  }

  @override
  void onTapUp(TapUpInfo info) {
    print('<game loop> onTap location: (${info.eventPosition.global})');
  }
}
