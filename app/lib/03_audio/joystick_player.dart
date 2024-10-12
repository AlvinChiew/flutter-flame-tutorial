import 'package:flame/components.dart';

import 'Utils.dart';

/// This is what the Joystick controls
///
/// We usi the [HasGameRef] mixin to get access to the game data
class JoystickPlayer extends SpriteComponent with HasGameRef {
  /// Pixels/s
  double maxSpeed = 300.0;

  final JoystickComponent joystick;

  JoystickPlayer(this.joystick)
      : super(
          size: Vector2.all(50.0),
        ) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //
    // ship png comes from Kenny
    sprite = await gameRef.loadSprite('asteroids_ship.png');
    position = gameRef.size / 2;
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = (joystick.delta.screenAngle());

      /// If the space-ship is out of bounds then 'wrap' it around
      /// the screen edge
      if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
        position = Utils.wrapPosition(gameRef.size, position);
      }
    }
  }
}
