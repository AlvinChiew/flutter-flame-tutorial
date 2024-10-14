import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

/// Solution to Case-Study #6 Exercise #2
///
/// Shows how to create a parallax with different velocity deltas on
/// each layer.
class MyGame extends FlameGame {
  static const String description = '''
    Shows how to create a parallax with different velocity deltas on each layer.
  ''';

  /// Mapping of images and velocity deltas
  final _layersMeta = {
    'bg.png': 1.0,
    'mountain-far.png': 1.5,
    'mountains.png': 2.3,
    'trees.png': 5.0,
    'foreground-trees.png': 24.0,
  };

  @override
  Future<void> onLoad() async {
    /// for each map entry for the layers, load the layer with the
    /// corresponding image (the key) and the velocity multiplier (value)
    final layers = _layersMeta.entries.map(
      (e) => loadParallaxLayer(
        ParallaxImageData(e.key),
        velocityMultiplier: Vector2(e.value, 1.0),
      ),
    );

    /// load the collection of layers into the parallax
    final parallax = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(20, 0),
      ),
    );
    add(parallax);
  }
}
