import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'word_target.dart';
import '../../../utils/extensions.dart';
import '../controller/controller.dart';
import 'flutter_word_splash_tile.dart';

class FlutterWordSplash extends StatelessWidget {
  const FlutterWordSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WordsSplashController>(
      builder: (WordsSplashController controller) {
        return Column(
          children: [
            Text(
              controller.spelling,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              runSpacing: 8.0,
              spacing: 8.0,
              children: controller.targets.map((t) {
                return WordTarget(word: t, tileSize: 25.0);
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (DragStartDetails d) =>
                    controller.onTouchStart(d.localPosition.toVector2()),
                onPanUpdate: (DragUpdateDetails d) =>
                    controller.onTouchMove(d.localPosition.toVector2()),
                onPanEnd: (DragEndDetails d) => controller.onTouchEnd(),
                child: Stack(
                    children: controller.tiles
                        .map(
                          (tileData) => Positioned(
                            left: tileData.position.x,
                            top: tileData.position.y,
                            child: FlutterWordSplashTile(
                                tileData: tileData,
                                tileSize: controller.tileSize),
                          ),
                        )
                        .toList()),
              ),
            )
          ],
        );
      },
    );
  }
}
