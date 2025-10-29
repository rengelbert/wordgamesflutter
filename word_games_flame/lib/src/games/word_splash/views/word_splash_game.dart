import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';
import 'word_splash_tile.dart';

class FlameWordSplash extends FlameGame with TapCallbacks, DragCallbacks {
  late WordsSplashController controller;
  final List<WordSplashTile> tiles = <WordSplashTile>[];

  bool _touchDown = false;

  @override
  Color backgroundColor() => Colors.orange;

  @override
  Future<void> onLoad() async {
    controller = Get.find<WordsSplashController>();
    controller.game = this;
    overlays.add("GameUI");
    newGame();
  }

  void newGame() {
    Random r = Random();
    controller.newRound(r.nextInt(1000));
    buildGrid();
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  void buildGrid() {
    // remove existing tiles
    for (var c in children) {
      if (c is WordSplashTile) c.removeFromParent();
    }
    // add new ones
    for (var tile in controller.allTiles) {
      add(tile);
    }
  }

  void clearSelection() {
    for (var tile in tiles) {
      tile.select(false);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    clearSelection();
    _touchDown = true;
    controller.onTouchStart(event.canvasPosition);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _touchDown = false;
    controller.onTouchEnd();
    clearSelection();
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_touchDown == true) {
      controller.onTouchStart(event.canvasPosition);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (_touchDown == true) {
      controller.onTouchMove(event.canvasEndPosition);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _touchDown = false;
    controller.onTouchEnd();
  }
}
