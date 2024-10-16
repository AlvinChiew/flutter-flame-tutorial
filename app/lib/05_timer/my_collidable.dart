import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide Image, Draggable;

import 'game.dart';
import 'life_bar_text.dart';

class MyCollidable extends CircleComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final _collisionColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  Color _currentColor = Colors.cyan;
  bool _isWallHit = false;
  bool _isCollision = false;
  late double _speed;
  late LifeBarText _healthText;

  int xDirection = 1;
  int yDirection = 1;

  int _objectLifeValue = 100;

  Map<String, MyCollidable> collisions = <String, MyCollidable>{};

  MyCollidable(
      Vector2 position, Vector2 velocity, double speed, int ordinalNumber)
      : super(position: position, radius: 20, anchor: Anchor.center) {
    xDirection = velocity.x.toInt();
    yDirection = velocity.y.toInt();
    _speed = speed;
    _healthText = LifeBarText(ordinalNumber)
      ..position = Vector2(0, -size.y / 2);
  }

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache.load('ball_bounce_off_ball.ogg');
    await FlameAudio.audioCache.load('ball_bounce_off_wall.ogg');
    add(_healthText);
    add(CircleHitbox());
    return super.onLoad();
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
      _isWallHit = true;
      FlameAudio.play('ball_bounce_off_wall.ogg');
    }

    if ((rect.top <= 0 && yDirection == -1) ||
        (rect.bottom >= gameSize.y && yDirection == 1)) {
      yDirection *= -1;
      _isWallHit = true;
      FlameAudio.play('ball_bounce_off_wall.ogg');
    }

    _currentColor = _isCollision ? _collisionColor : _defaultColor;
    if (_isCollision) {
      _objectLifeValue -= 10;
      _isCollision = false;
    }
    if (_isWallHit) {
      _objectLifeValue -= 10;
      _isWallHit = false;
    }

    _healthText.healthData = _objectLifeValue;

    if (_objectLifeValue <= 0) {
      removeFromParent();
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

        String collisionKey = hashCode > other.hashCode
            ? '${other.hashCode}$hashCode'
            : '$hashCode${other.hashCode}';

        if (gameRef.observedCollisions.contains(collisionKey)) {
          gameRef.observedCollisions.remove(collisionKey);
        } else {
          gameRef.observedCollisions.add(collisionKey);
          FlameAudio.play('ball_bounce_off_ball.ogg');
        }

        _isCollision = true;
      }
    }
  }
}
