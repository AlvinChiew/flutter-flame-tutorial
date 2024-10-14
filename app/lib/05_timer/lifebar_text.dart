import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Image, Draggable;
import 'package:intl/intl.dart' as intl;

/// Simple TextComponent based implementation of formatted text for the
/// bouncing balls MyCollidable class
///
/// this is a simple formatting of a text with two parameters:
/// [_ordinalNumber] and [healthData] which is formatted in the update()
/// method and then rendered by the render(...) method inherited from the
/// TextComponent class.
///
class LifeBarText extends TextComponent {
  /// formatting of the text data
  /// more information here:
  /// https://api.flutter.dev/flutter/intl/NumberFormat-class.html
  ///
  ///

  final TextPaint textBallStats = TextPaint(
    style: const TextStyle(color: Colors.red, fontSize: 10),
  );
  var ordinalformatter = intl.NumberFormat("000", "en_US");
  var healthDataformatter = intl.NumberFormat("000", "en_US");

  /// text data we are formatting
  int _ordinalNumber = 0;
  int healthData = 0;

  /// Default constructor to accept the ordinal number of the ball
  LifeBarText(int ordinalNumber) {
    _ordinalNumber = ordinalNumber;
  }

  @override
  FutureOr<void>? onLoad() {
    textRenderer = textBallStats;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    /// format the text into the life-health string
    text = '#${ordinalformatter.format(_ordinalNumber)}'
        ' - ${healthDataformatter.format(healthData)}%';
    super.update(dt);
  }
}
