import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart' hide Draggable;

class MyGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  @override
  bool debugMode = false;
  int thresholdOutOfBounds = 20;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(ScreenHitbox());
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(MyCollidable(event.canvasPosition));
  }
}

class MyCollidable extends CircleComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final _collisionColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  Color _currentColor = Colors.cyan;
  bool _isWallHit = false;
  bool _isCollision = false;
  final double _speed = 200;

  int xDirection = 1;
  int yDirection = 1;

  Map<String, MyCollidable> collisions = <String, MyCollidable>{};

  MyCollidable(Vector2 position)
      : super(
          position: position,
          radius: 20,
          anchor: Anchor.center,
        ) {
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    List keys = [];
    for (var other in collisions.entries) {
      MyCollidable otherObject = other.value;
      if (position.distanceTo(otherObject.position) > size.x) {
        keys.add(other.key);
      }
    }

    collisions.removeWhere((key, value) => keys.contains(key));

    position.x += xDirection * _speed * dt;
    position.y += yDirection * _speed * dt;

    final rect = toRect();
    final gameSize = gameRef.size;

    if ((rect.left <= 0 && xDirection == -1) ||
        (rect.right >= gameSize.x && xDirection == 1)) {
      xDirection *= -1;
    }

    if ((rect.top <= 0 && yDirection == -1) ||
        (rect.bottom >= gameSize.y && yDirection == 1)) {
      yDirection *= -1;
    }

    _currentColor = _isCollision ? _collisionColor : _defaultColor;
    if (_isCollision && !_isWallHit) {
      _isCollision = false;
    }
    if (_isWallHit) {
      _isWallHit = false;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    paint.color = _currentColor;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is MyCollidable) {
      if (!collisions.containsKey(other.hashCode.toString())) {
        collisions[other.hashCode.toString()] = other;
        xDirection *= -1;
        yDirection *= -1;
      }
      _isCollision = true;
    }
  }
}
