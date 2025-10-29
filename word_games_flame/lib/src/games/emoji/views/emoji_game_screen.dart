import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/emoji_controller.dart';
import 'emoji_tile.dart';

class FlameEmoji extends FlameGame with TapCallbacks {
  late EmojiController controller;
  final List<FlameEmojiTile> tiles = <FlameEmojiTile>[];

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  Color backgroundColor() => Colors.orange;

  @override
  Future<void> onLoad() async {
    controller = Get.find<EmojiController>();
    controller.game = this;
    overlays.add("GameUI");
    newGame();
  }

  void newGame() {
    Random r = Random();
    controller.newGame(r.nextInt(1000));
  }

  void clearSelection() {
    for (var tile in tiles) {
      tile.select(false);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    clearSelection();
    controller.onTouchDown(event.canvasPosition);
  }
}
