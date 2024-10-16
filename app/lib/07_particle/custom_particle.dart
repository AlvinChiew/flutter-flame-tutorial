import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/particles.dart';

typedef RemoveParticleTest = bool Function(
    Vector2 initialPosition, Vector2 currentPosition);

class CustomParticle extends Particle {
  final Vector2 initialPosition;
  final RemoveParticleTest removeParticleTest;
  final Particle child;
  bool _isRemoved = false;
  Vector2 _position;
  Vector2 _speed;
  final Vector2 _acceleration;
  double _progress = 0;

  @override
  final double lifespan;

  CustomParticle({
    required this.child,
    required Vector2 position,
    required this.removeParticleTest,
    Vector2? speed,
    Vector2? acceleration,
    this.lifespan = 1,
  })  : initialPosition = position.clone(),
        _position = position.clone(),
        _speed = speed ?? Vector2.zero(),
        _acceleration = acceleration ?? Vector2.zero();

  @override
  void update(double dt) {
    if (!_isRemoved) {
      _progress += dt / lifespan;
      _speed += _acceleration * dt;
      _position += _speed * dt;
      child.update(dt);
      _isRemoved =
          removeParticleTest(initialPosition, _position) || _progress >= 1;
    }
  }

  @override
  void render(Canvas canvas) {
    if (!_isRemoved) {
      canvas.save();
      canvas.translate(_position.x, _position.y);
      child.render(canvas);
      canvas.restore();
    }
  }

  @override
  bool get shouldRemove => _isRemoved;
}
