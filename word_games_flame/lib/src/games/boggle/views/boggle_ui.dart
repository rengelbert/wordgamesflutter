import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_config.dart';
import '../controller/boggle_controller.dart';

class ScoreText extends TextBoxComponent {
  late BoggleController controller;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    controller = Get.find<BoggleController>();

    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 20,
        fontFamily: 'SimplyRounded',
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );

    textRenderer = textPaint;
    position = Vector2(20, 20);
  }

  @override
  void render(Canvas canvas) {
    text = controller.score;
    super.render(canvas);
  }
}

class SpellingText extends TextBoxComponent {
  late BoggleController controller;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    controller = Get.find<BoggleController>();

    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 20,
        fontFamily: 'SimplyRounded',
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );

    anchor = Anchor.topRight;
    align = Anchor.centerRight;
    textRenderer = textPaint;
    position = Vector2(AppConfig.screenWidth - 20, 20);
  }

  @override
  void render(Canvas canvas) {
    text = controller.spelling;
    super.render(canvas);
  }
}
