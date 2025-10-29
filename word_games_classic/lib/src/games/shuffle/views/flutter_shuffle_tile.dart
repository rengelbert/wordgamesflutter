import 'package:flutter/material.dart';

import '../data/tile_data.dart';

class FlutterShuffleTile extends StatelessWidget {
  final ShuffleTileData tileData;
  final double tileSize;
  const FlutterShuffleTile({
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
        color: tileData.tileType.bgColor,
        borderRadius: BorderRadius.circular(tileSize * 0.2),
      ),
      child: Center(
        child: Text(
          tileData.value,
          style: TextStyle(
            color: tileData.tileType.labelColor,
            fontSize: tileSize * 0.6,
          ),
        ),
      ),
    );
  }
}
