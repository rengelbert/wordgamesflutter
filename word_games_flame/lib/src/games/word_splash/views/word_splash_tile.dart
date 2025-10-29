import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';

class WordSplashTile extends PositionComponent {
  bool selected = false;
  String value = "W";

  final double tileSize;
  late final TextComponent label;

  late TextPaint textPaint;
  late TextPaint selectedTextPaint;

  WordSplashTile({
    this.value = "W",
    this.tileSize = 100,
  }) : super(size: Vector2(tileSize, tileSize)) {
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
      text: value,
      position: Vector2.all(tileSize * 0.5),
      textRenderer: textPaint,
      anchor: Anchor.center,
    );

    add(label);
  }

  void select(bool value) {
    selected = value;
    label.textRenderer = selected ? selectedTextPaint : textPaint;
  }

  @override
  void render(Canvas canvas) {
    if (label.text == "") return;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCircle(
                center: Offset(tileSize * 0.5, tileSize * 0.5),
                radius: tileSize * 0.5),
            Radius.circular(tileSize * 0.2)),
        PaletteEntry(
                selected ? AppTheme.tileBgSelectedColor : AppTheme.tileBgColor)
            .paint());
  }
}
