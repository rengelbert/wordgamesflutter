import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:word_games_classic/src/games/emoji/model/emoji_tile_data.dart';

import '../../../config/app_theme.dart';

const normalBgColor = Colors.black;
const wrongWordBgColor = Colors.red;
const selectedBgColor = Colors.blueAccent;

class FlameEmojiTile extends PositionComponent {
  // data
  final EmojiTileData tileData;

  final double tileSize;

  late final TextComponent label;

  late TextPaint textPaint;
  late TextPaint selectedTextPaint;

  FlameEmojiTile({required this.tileData, this.tileSize = 100})
      : super(size: Vector2(tileSize, tileSize)) {
    final baseStyle = TextStyle(
      fontSize: tileSize * 0.6,
      fontFamily: 'SimplyRounded',
      fontWeight: FontWeight.w500,
      color: AppTheme.tileLabelColor,
    );

    textPaint = TextPaint(
      style: baseStyle,
    );

    selectedTextPaint = TextPaint(
      style: baseStyle.copyWith(color: AppTheme.tileLabelSelectedColor),
    );

    label = TextComponent(
      text: _getTextValue(),
      position: Vector2.all(tileSize * 0.5),
      textRenderer: textPaint,
      anchor: Anchor.center,
    );

    add(label);
  }

  String _getTextValue() {
    if (tileData.input.isEmpty && tileData.emoji.isEmpty) {
      return tileData.value.toUpperCase();
    }
    if (tileData.input.isNotEmpty) return tileData.input.toUpperCase();
    return tileData.emoji;
  }

  void updateValue(String value) {
    tileData.input = value;
    label.text = _getTextValue();
  }

  void select(bool value) {
    tileData.selected = value;
    label.textRenderer = tileData.selected ? selectedTextPaint : textPaint;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCircle(
                center: Offset(tileSize * 0.5, tileSize * 0.5),
                radius: tileSize * 0.5),
            Radius.circular(tileSize * 0.2)),
        PaletteEntry(tileData.incorrect
                ? wrongWordBgColor
                : tileData.selected
                    ? selectedBgColor
                    : normalBgColor)
            .paint());
  }
}
