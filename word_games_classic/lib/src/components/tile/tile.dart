import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/tile_controller.dart';
import 'data/tile_data.dart';
import '../../config/app_theme.dart';

class FlutterTile extends StatelessWidget {
  final TileData tileData;
  final double tileSize;

  const FlutterTile({
    super.key,
    required this.tileData,
    required this.tileSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        color: tileData.selected ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(tileSize * 0.2),
      ),
      child: Center(
        child: Text(
          tileData.value,
          style: TextStyle(
            color: tileData.selected ? Colors.black : Colors.white,
            fontSize: tileSize * 0.6,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

// no data
class FlutterTile1 extends StatelessWidget {
  const FlutterTile1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text(
          "W",
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

//with data, no tap
class FlutterTile2 extends StatelessWidget {
  final TileData tileData;
  final double tileSize;
  const FlutterTile2({
    super.key,
    required this.tileData,
    required this.tileSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        color: tileData.selected ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(tileSize * 0.2),
      ),
      child: Center(
        child: Text(
          tileData.value,
          style: TextStyle(
            color: tileData.selected ? Colors.black : Colors.white,
            fontSize: tileSize * 0.6,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

// clip rect version
class FlutterTile3 extends StatelessWidget {
  const FlutterTile3({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 100,
        height: 100,
        child: ColoredBox(
          color: Colors.black,
          child: Center(
            child: Text(
              "W",
              style: AppTheme.tileLabelStyle.copyWith(
                color: Colors.white,
                fontSize: 60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// with tap
class FlutterTile4 extends StatelessWidget {
  final TileData tileData;
  final double tileSize;
  const FlutterTile4({
    super.key,
    required this.tileData,
    required this.tileSize,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TileController>();

    return GestureDetector(
      onTap: () {
        controller.select();
      },
      child: Container(
        width: tileSize,
        height: tileSize,
        decoration: BoxDecoration(
          color: tileData.selected ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(tileSize * 0.2),
        ),
        child: Center(
          child: Text(
            tileData.value,
            style: AppTheme.baseText.copyWith(
              color: tileData.selected ? Colors.black : Colors.white,
              fontSize: tileSize * 0.6,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

// with transform
class FlutterTile5 extends StatelessWidget {
  final TileData tileData;
  final double tileSize;
  const FlutterTile5({
    super.key,
    required this.tileData,
    required this.tileSize,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TileController>();

    return GestureDetector(
      onTap: () {
        controller.select();
      },
      child: Transform.rotate(
        angle: 0.2,
        child: Container(
          width: tileSize,
          height: tileSize,
          decoration: BoxDecoration(
            color: tileData.selected ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(tileSize * 0.2),
          ),
          child: Center(
            child: Text(
              tileData.value,
              style: TextStyle(
                color: tileData.selected ? Colors.black : Colors.white,
                fontSize: tileSize * 0.6,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// with animated scale
class FlutterTile6 extends StatelessWidget {
  final TileData tileData;
  final double tileSize;
  const FlutterTile6({
    super.key,
    required this.tileData,
    required this.tileSize,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TileController>();
    return GestureDetector(
      onTap: () {
        controller.select();
      },
      child: Transform.rotate(
        angle: 0.2,
        child: AnimatedScale(
          scale: tileData.selected ? 1.5 : 1.0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: tileSize,
            height: tileSize,
            decoration: BoxDecoration(
              color: tileData.selected ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(tileSize * 0.2),
            ),
            child: Center(
              child: Text(
                tileData.value,
                style: TextStyle(
                  color: tileData.selected ? Colors.black : Colors.white,
                  fontSize: tileSize * 0.6,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// taps
class FlutterTile7 extends StatelessWidget {
  final TileData tileData;
  final double tileSize;
  const FlutterTile7({
    super.key,
    required this.tileData,
    required this.tileSize,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TileController>();

    return GestureDetector(
      onTap: () {
        controller.select();
      },
      child: Transform.rotate(
        angle: 0.2,
        child: AnimatedScale(
          scale: tileData.selected ? 1.5 : 1.0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: tileSize,
            height: tileSize,
            decoration: BoxDecoration(
              color: tileData.selected ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(tileSize * 0.2),
            ),
            child: Center(
              child: Text(
                tileData.value,
                style: TextStyle(
                  color: tileData.selected ? Colors.black : Colors.white,
                  fontSize: tileSize * 0.6,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
