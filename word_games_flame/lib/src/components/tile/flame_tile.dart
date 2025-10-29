import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import 'data/tile_data.dart';
import '../../config/app_theme.dart';

class FlameTile3 extends PositionComponent
    with TapCallbacks, HasGameRef<TestGame> {
  final TileData data;
  final double tileSize;
  late final TextComponent label;

  late TextPaint textPaint;
  late TextPaint selectedTextPaint;

  FlameTile3({required this.data, this.tileSize = 100})
      : super(size: Vector2.all(tileSize)) {
    final style = TextStyle(
      fontSize: tileSize * 0.6,
      fontFamily: 'SimplyRounded',
      fontWeight: FontWeight.w500,
      color: AppTheme.tileLabelColor,
    );

    textPaint = TextPaint(
      style: style,
    );

    selectedTextPaint = TextPaint(
      style: style.copyWith(color: AppTheme.tileLabelSelectedColor),
    );

    label = TextComponent(
      text: data.value,
      position: Vector2.all(tileSize * 0.5),
      textRenderer: textPaint,
    )..anchor = Anchor.center;
    add(label);

    angle = 0.2;
    anchor = Anchor.center;
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.selectTile(data);
    label.textRenderer = data.selected ? selectedTextPaint : textPaint;

    final effect = ScaleEffect.to(
      Vector2.all(data.selected ? 1.5 : 1.0),
      EffectController(duration: 0.15),
    );
    add(effect);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCircle(
                center: Offset(tileSize * 0.5, tileSize * 0.5),
                radius: tileSize * 0.5),
            Radius.circular(tileSize * 0.2)),
        PaletteEntry(data.selected
                ? AppTheme.tileBgSelectedColor
                : AppTheme.tileBgColor)
            .paint());
  }
}

// simple tile
class FlameTile2 extends PositionComponent {
  final TileData data;
  final double tileSize;
  late final TextComponent label;

  late TextPaint textPaint;

  FlameTile2({required this.data, this.tileSize = 100})
      : super(size: Vector2.all(tileSize * 0.8)) {
    final style = TextStyle(
      fontSize: tileSize * 0.6,
      fontFamily: 'SimplyRounded',
      fontWeight: FontWeight.w500,
      color: AppTheme.tileLabelColor,
    );

    textPaint = TextPaint(
      style: style,
    );

    label = TextComponent(
      text: data.value,
      position: Vector2.all(tileSize * 0.5),
      textRenderer: textPaint,
    )..anchor = Anchor.center;
    add(label);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCircle(
                center: Offset(tileSize * 0.5, tileSize * 0.5),
                radius: tileSize * 0.5),
            Radius.circular(tileSize * 0.2)),
        PaletteEntry(AppTheme.tileBgColor).paint());
  }
}

//

class FlameTile extends PositionComponent {
  final TileData data;
  final double tileSize;
  late final TextComponent label;

  bool selected = false;
  bool _visible = true;
  int row = 0;
  int column = 0;
  int index = 0;
  late TextPaint textPaint;
  late TextPaint selectedTextPaint;

  FlameTile({required this.data, this.tileSize = 100})
      : super(size: Vector2.all(tileSize * 0.8)) {
    final style = TextStyle(
      fontSize: tileSize * 0.6,
      fontFamily: 'SimplyRounded',
      fontWeight: FontWeight.w500,
      color: AppTheme.tileLabelColor,
    );

    textPaint = TextPaint(
      style: style,
    );

    selectedTextPaint = TextPaint(
      style: style.copyWith(color: AppTheme.tileLabelSelectedColor),
    );

    label = TextComponent(
      text: data.value,
      position: Vector2.all(tileSize * 0.5),
      textRenderer: textPaint,
    )..anchor = Anchor.center;
    add(label);
  }

  void showLetter(String char) {
    label.text = char;
  }

  void select([bool value = true]) {
    if (selected == value) return;
    selected = value;
    label.textRenderer = value ? selectedTextPaint : textPaint;
  }

  bool isVisible() => _visible;

  void hide() {
    _visible = false;
    label.text = "";
  }

  void show() {
    _visible = true;
    label.text = data.value;
  }

  @override
  void render(Canvas canvas) {
    if (!_visible) return;
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

class BaseFlameTile extends PositionComponent {
  late final TextComponent label;

  late TextPaint textPaint;

  BaseFlameTile() {
    final style = TextStyle(
      fontSize: 60,
      fontFamily: 'SimplyRounded',
      fontWeight: FontWeight.w500,
      color: AppTheme.tileLabelColor,
    );

    textPaint = TextPaint(
      style: style,
    );

    label = TextComponent(
      text: "W",
      textRenderer: textPaint,
    )..anchor = Anchor.center;
    add(label);
    anchor = Anchor.center;
  }

  @override
  void update(double delta) {}

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCircle(center: Offset.zero, radius: 50),
            Radius.circular(20)),
        PaletteEntry(Colors.black).paint());
  }
}
