import 'package:flutter/material.dart';

import '../data/boggle_tile_data.dart';

class BoggleTile extends StatelessWidget {
  final BoggleTileData tileData;
  final double tileSize;
  const BoggleTile({
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
        color: tileData.bgColor,
        borderRadius: BorderRadius.circular(tileSize * 0.2),
      ),
      child: Center(
        child: Text(
          tileData.value,
          style: TextStyle(
            color: tileData.labelColor,
            fontSize: tileSize * 0.6,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
