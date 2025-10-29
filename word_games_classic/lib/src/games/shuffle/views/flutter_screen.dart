import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';
import 'flutter_shuffle_tile.dart';

class FlutterShuffle extends StatelessWidget {
  const FlutterShuffle({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShuffleController>(
        builder: (ShuffleController controller) {
      return Stack(
          children: controller.tiles
              .map((tileData) => Positioned(
                    left: tileData.position.x,
                    top: tileData.position.y,
                    child: GestureDetector(
                      onTap: () => controller.selectTile(tileData),
                      child: FlutterShuffleTile(
                          tileData: tileData, tileSize: controller.tileSize),
                    ),
                  ))
              .toList());
    });
  }
}
