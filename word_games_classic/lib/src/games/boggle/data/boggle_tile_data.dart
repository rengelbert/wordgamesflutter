import 'package:flutter/material.dart';

import '../../../utils/vector2.dart';

const normalBgColor = Colors.black;
const normalLabelColor = Colors.white;
const selectedBgColor = Colors.white;
const selectedLabelColor = Colors.black;
const newWordBgColor = Colors.green;
const wrongWordBgColor = Colors.red;
const repeatedWordBgColor = Colors.amber;

class BoggleTileData {
  Vector2 position = Vector2.all(0);

  Color bgColor = normalBgColor;
  Color labelColor = normalLabelColor;

  final int column;
  final int row;
  bool selected = false;
  String value = "W";

  BoggleTileData({
    this.column = 0,
    this.row = 0,
  });
}
