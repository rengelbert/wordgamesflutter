import 'package:flutter/material.dart';

import '../data/tile_data.dart';

class EmojiTile extends StatelessWidget {
  final EmojiTileData tileData;
  final double tileSize;
  const EmojiTile({
    super.key,
    required this.tileData,
    required this.tileSize,
  });

  String _getTextValue() {
    if (tileData.input.isEmpty && tileData.emoji.isEmpty) {
      return tileData.value.toUpperCase();
    }
    if (tileData.input.isNotEmpty) return tileData.input.toUpperCase();
    return tileData.emoji;
  }

  Color _getTileBgColor() {
    if (tileData.incorrect) {
      return Colors.red;
    }
    if (tileData.selected) {
      return Colors.blueAccent;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        color: _getTileBgColor(),
        borderRadius: BorderRadius.circular(tileSize * 0.2),
      ),
      child: Center(
        child: Text(
          _getTextValue(),
          style: TextStyle(
            color: Colors.white,
            fontSize: tileSize * 0.6,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
