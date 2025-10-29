import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../data/splash_tile_data.dart';

class FlutterWordSplashTile extends StatelessWidget {
  final WordSplashTileData tileData;
  final double tileSize;
  const FlutterWordSplashTile({
    super.key,
    required this.tileData,
    required this.tileSize,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: tileData.rotation,
      child: Container(
        width: tileSize,
        height: tileSize,
        decoration: BoxDecoration(
          color: tileData.selected
              ? AppTheme.tileBgSelectedColor
              : AppTheme.tileBgColor,
          borderRadius: BorderRadius.circular(tileSize * 0.2),
        ),
        child: Center(
          child: Text(
            tileData.value,
            style: AppTheme.tileLabelStyle.copyWith(
              color: tileData.selected
                  ? AppTheme.tileLabelSelectedColor
                  : AppTheme.tileLabelColor,
              fontSize: tileSize * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
