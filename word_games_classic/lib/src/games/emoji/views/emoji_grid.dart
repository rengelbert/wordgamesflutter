import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/extensions.dart';
import '../controller/emoji_controller.dart';
import 'emoji_tile.dart';

class EmojiGrid extends StatelessWidget {
  const EmojiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmojiController>();
    return GestureDetector(
      onTapDown: (TapDownDetails d) {
        controller.onTouchDown(d.localPosition.toVector2());
      },
      onLongPress: () {
        controller.onLongTouch();
      },
      child: GetBuilder<EmojiController>(
        builder: (EmojiController controller) {
          return Stack(children: _getTiles(controller));
        },
      ),
    );
  }

  List<Widget> _getTiles(EmojiController controller) {
    return controller.allTiles
        .map(
          (tileData) => Positioned(
            left: tileData.position.x,
            top: tileData.position.y,
            child: EmojiTile(
              tileSize: controller.tileSize,
              tileData: tileData,
            ),
          ),
        )
        .toList();
  }
}
