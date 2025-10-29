import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/shuffle_controller.dart';
import '../../../config/app_theme.dart';

class FlameShuffleTile extends PositionComponent with TapCallbacks {
  final double tileSize;
  late final TextComponent label;
  late ShuffleController controller;

  String value;
  TileType tileType = TileType.normal;
  late TextStyle baseStyle;

  FlameShuffleTile({
    required this.value,
    this.tileSize = 100,
  }) : super(size: Vector2(tileSize, tileSize)) {
    controller = Get.find<ShuffleController>();
    baseStyle = TextStyle(
      fontSize: tileSize * 0.6,
      fontFamily: 'SimplyRounded',
      fontWeight: FontWeight.w500,
      color: AppTheme.tileLabelColor,
    );

    final textPaint = TextPaint(
      style: baseStyle,
    );

    label = TextComponent(
      text: value,
      position: Vector2.all(tileSize * 0.5),
      textRenderer: textPaint,
      anchor: Anchor.center,
    );
    add(label);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (tileType != TileType.correct) {
      controller.selectTile(this);
    }
  }

  void updateTileType(TileType tt) {
    tileType = tt;
    label.textRenderer = TextPaint(
      style: baseStyle.copyWith(color: tileType.labelColor),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCircle(
                center: Offset(tileSize * 0.5, tileSize * 0.5),
                radius: tileSize * 0.5),
            Radius.circular(tileSize * 0.2)),
        PaletteEntry(tileType.bgColor).paint());
  }
}
