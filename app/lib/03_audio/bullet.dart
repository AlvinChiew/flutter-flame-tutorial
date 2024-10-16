import 'package:flame/components.dart';
// import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

// import 'package:flame_noise/flame_noise.dart';
import 'package:flame_audio/flame_audio.dart';

import 'utils.dart';

/// Simple simulation of a bullet
///
/// It is a PositionComponent so we get the 'angle' and 'position' elements
/// out of the box.
class Bullet extends PositionComponent with HasGameRef {
  // color of the bullet
  static final _paint = Paint()..color = Colors.white;
  // the bullet speed in pixels/second
  final double _speed = 150;
  // velocity vector for the bullet.
  late Vector2 _velocity;

  //
  // default constructor with default values
  Bullet(Vector2 position, Vector2 velocity)
      : _velocity = velocity,
        super(
          position: position,
          size: Vector2.all(4), // 4x4 bullet
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // _velocity is a unit vector so we need to make it account for the actual
    // speed.
    _velocity = (_velocity)..scaleTo(_speed);
    // sounds used for the shot
    FlameAudio.play('missile_shot.wav');
    // layered sounds for missile transition/flyby
    FlameAudio.play('missile_flyby.wav');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // draw the bullet
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void update(double dt) {
    position.add(_velocity * dt);
    // play a sound of explosion when the bullet goes out of bounds
    if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
      removeFromParent();
      FlameAudio.play('missile_hit.wav');
      // render the camera shake effect for a short duration
      // gameRef.camera.shake(duration: 0.25, intensity: 5);
      //   gameRef.camera.viewfinder.add(
      //     MoveEffect.by(
      //       Vector2(5, 5),
      //       NoiseEffectController(duration: 0.6),
      //     ),
      //   );
    }
  }
}
