import 'package:app/debug_example.dart';
import 'package:app/game.dart';
import 'package:app/text_example.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();

  runApp(GameWidget(game: MyGame()));
}
