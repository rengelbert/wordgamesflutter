import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'boggle_tile.dart';
import 'boggle_ui.dart';

import '../controller/boggle_controller.dart';

class FlameBoggle extends FlameGame with TapCallbacks, DragCallbacks {
  late BoggleController controller;
  final List<FlameBoggleTile> tiles = <FlameBoggleTile>[];

  bool _touchDown = false;

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  Color backgroundColor() => Colors.orange;

  @override
  Future<void> onLoad() async {
    print("load");
    controller = Get.find<BoggleController>();
    controller.game = this;

    add(ScoreText());
    add(SpellingText());

    newGame();
  }

  void newGame() {
    Random r = Random();
    controller.newGame(r.nextInt(1000));
    buildGrid();
  }

  void buildGrid() {
    // remove existing tiles
    for (var c in children) {
      if (c is FlameBoggleTile) c.removeFromParent();
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
