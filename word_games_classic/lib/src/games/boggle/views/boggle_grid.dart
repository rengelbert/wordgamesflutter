import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/extensions.dart';

import '../controller/boggle_controller.dart';
import 'boggle_tile.dart';

class BoggleGrid extends StatelessWidget {
  const BoggleGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BoggleController>();
    return GestureDetector(
      onPanStart: (DragStartDetails d) =>
          controller.onTouchStart(d.localPosition.toVector2()),
      onPanUpdate: (DragUpdateDetails d) =>
          controller.onTouchMove(d.localPosition.toVector2()),
      onPanEnd: (DragEndDetails d) => controller.onTouchEnd(),
      child: Stack(children: _getTiles(controller)),
    );
  }

  List<Widget> _getTiles(BoggleController controller) {
    return controller.allTiles
        .map(
          (tileData) => Positioned(
            left: tileData.position.x,
            top: tileData.position.y,
            child: BoggleTile(
              tileSize: controller.tileSize,
              tileData: tileData,
            ),
          ),
        )
        .toList();
  }
}
