import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/tile/controller/tile_controller.dart';
import 'components/tile/tile.dart';

class Stage extends StatelessWidget {
  Stage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: FlutterTile1(),
      ),
    );
  }
}

class Stage1 extends StatelessWidget {
  const Stage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: GetBuilder<TileController>(
        builder: (TileController controller) {
          return const Center(
            child: FlutterTile1(),
          );
        },
      ),
    );
  }
}
