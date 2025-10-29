import 'package:flame/components.dart';

import '../../../config/app_theme.dart';

class TileData {
  Vector2 position = Vector2.all(0);

  final int column;
  final int row;
  int index = 0;
  bool selected = false;
  String value = "W";
  TileType tileType = TileType.normal;

  TileData({
    this.column = 0,
    this.row = 0,
  });
}
