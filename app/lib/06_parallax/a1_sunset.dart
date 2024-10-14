import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

/// Solution to case-study #6 exercise #1
///
class MyGame extends FlameGame {
  static const String description = '''
    Shows the simplest way to use a fullscreen `ParallaxComponent`.
  ''';

  final _imageNames = [
    ParallaxImageData('bg.png'),
    ParallaxImageData('mountain-far.png'),
    ParallaxImageData('mountains.png'),
    ParallaxImageData('trees.png'),
    ParallaxImageData('foreground-trees.png'),
  ];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final parallax = await loadParallaxComponent(
      _imageNames,

      /// Moving the parallax to the right
      baseVelocity: Vector2(-20.0, 0.0),
      velocityMultiplierDelta: Vector2(1.8, 0.0),
    );
    add(parallax);
  }
}
