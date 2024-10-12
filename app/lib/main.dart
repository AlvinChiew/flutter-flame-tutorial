import 'package:app/00_basics_and_debug/00_debug_example.dart';
import 'package:app/00_basics_and_debug/00_text_example.dart';
import 'package:app/00_basics_and_debug/01_basics.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();

  runApp(GameWidget(game: MyGame()));
}
