import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../../config/app_config.dart';
import '../../../service/dictionary.dart';
import '../../../utils/vector2.dart';
import '../data/boggle_model.dart';
import '../data/boggle_tile_data.dart';

class BoggleController extends GetxController {
  final BoggleData _gameModel = BoggleData();
  late final DictionaryService _dictionary;

  final List<BoggleTileData> allTiles = [];
  BoggleTileData? _selectedTile;
  final List<BoggleTileData> _selectedTiles = [];

  static const kTileHitArea = 0.6;

  String get spelling => _selectedTiles.map((t) => t.value).join();
  String get score => _gameModel.score.toString();

  double tileSize = 0;

  bool _checkWord(String word) =>
      _dictionary.dictionary.isWord(word.toLowerCase());
  bool _active = true;

  Future<void> initGame() async {
    _dictionary = DictionaryService();
    await _dictionary.init();
  }

  void newGame([int seed = 100]) {
    _selectedTiles.clear();
    _selectedTile = null;
    _gameModel.newGame();
    _buildGrid(4, 3);
  }

  void _buildGrid(int rows, int columns) {
    final letterPool = _dictionary.dictionary.randomChars(rows * columns);

    //make space a fraction of total width
    var spc = AppConfig.screenWidth * 0.015;

    //make horizontal margin (left and right) 10% of screen width
    var hMargin = AppConfig.screenWidth * 0.1;

    //actual width we have for grid (total width - margins)
    var canvasWidth = AppConfig.screenWidth - (2 * hMargin);

    //total horizontal amount taken up by space between tiles
    var totalHorizontalGridSpace = (columns - 1) * spc;

    //total vertical amount taken up by space between tiles
    var totalVerticalGridSpace = (rows - 1) * spc;

    //the tile size (based on width)
    tileSize = (canvasWidth - totalHorizontalGridSpace) / columns;

    // total width and height of the grid
    final gridHeight = (rows * tileSize) + totalVerticalGridSpace;
    final gridWidth = (columns) * (tileSize) + totalHorizontalGridSpace;

    //the offset position of the grid, here centered, but
    //any other offset can be stated here
    final gridPosition = Vector2(
      (AppConfig.screenWidth - gridWidth) * 0.5,
      (AppConfig.screenHeight - gridHeight) * 0.5,
    );

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < columns; c++) {
        var tile = BoggleTileData(row: r, column: c)
          ..value = letterPool.removeAt(0).toUpperCase();
        tile.position.x = gridPosition.x + (c * (tileSize + spc));
        tile.position.y = gridPosition.y + r * (tileSize + spc);
        allTiles.add(tile);
      }
    }
  }

  void selectTile(BoggleTileData tile) {
    bool canSelect = false;
    if (_selectedTile == null) {
      //this is our first tile selected
      canSelect = true;
    } else {
      //check to see the next selection is legal
      if (tile.row == _selectedTile!.row &&
          (tile.column == _selectedTile!.column - 1 ||
              tile.column == _selectedTile!.column + 1)) {
        canSelect = true;
      } else if (tile.column == _selectedTile?.column &&
          (tile.row == _selectedTile!.row - 1 ||
              tile.row == _selectedTile!.row + 1)) {
        canSelect = true;
      } else if ((tile.column - _selectedTile!.column).abs() == 1 &&
          (tile.row - _selectedTile!.row).abs() == 1) {
        canSelect = true;
      }
    }

    if (canSelect) {
      _selectedTile = tile;
      if (!_selectedTiles.contains(_selectedTile)) {
        _selectedTile!.selected = true;
        _selectedTile!.bgColor = selectedBgColor;
        _selectedTile!.labelColor = selectedLabelColor;
        _selectedTiles.add(_selectedTile!);
        update();
      } else {
        if (_selectedTiles.length > 1) {
          //deselect tile if it's already been added to selected tiles
          var index = _selectedTiles.indexOf(tile);
          for (var i = _selectedTiles.length - 1; i >= 0; i--) {
            var tile = _selectedTiles[i];
            if (i > index) {
              tile.selected = false;
              tile.bgColor = normalBgColor;
              tile.labelColor = normalLabelColor;
              _selectedTiles.removeAt(i);
            }
          }
          _selectedTile = _selectedTiles[_selectedTiles.length - 1];
          update();
        }
      }
    }
  }

  void onTouchStart(Vector2 touch) {
    if (_active == false) return;
    var tile = _tileClosestToPoint(touch);

    if (tile != null && isTouchingTile(tile, touch)) {
      selectTile(tile);
      update();
    }
  }

  //on dragging
  void onTouchMove(Vector2 touch) {
    if (_active == false) return;
    var nextTile = _tileClosestToPoint(touch);

    if (nextTile != null &&
        nextTile != _selectedTile &&
        isTouchingTile(nextTile, touch)) {
      selectTile(nextTile);
      update();
    }
  }

  void onTouchEnd() {
    if (_active == false) return;
    if (_selectedTile == null) {
      return;
    }
    if (_selectedTiles.length > 2) {
      _submitWord();
    }
  }

  void _submitWord() {
    final word = spelling;
    Color bgColor = normalBgColor;

    if (_checkWord(word)) {
      if (_gameModel.isNewWord(word)) {
        // show tiles for new word
        bgColor = newWordBgColor;
      } else {
        // show tiles as repeated word
        bgColor = repeatedWordBgColor;
      }
    } else {
      // show tiles for error
      bgColor = wrongWordBgColor;
    }

    // change tile bg color
    _active = false;

    for (var tileData in _selectedTiles) {
      tileData.bgColor = bgColor;
      tileData.labelColor = normalLabelColor;
    }
    update();

    Future.delayed(const Duration(milliseconds: 800)).then((value) {
      _active = true;
      for (var tileData in _selectedTiles) {
        tileData.selected = false;
        tileData.bgColor = normalBgColor;
        tileData.labelColor = normalLabelColor;
      }
      _selectedTiles.clear();
      _selectedTile = null;
      update();
    });
  }

  bool isTouchingTile(BoggleTileData tile, Vector2 point) {
    var distance =
        point.distanceTo(tile.position + Vector2.all(tileSize * 0.5));
    return distance <= tileSize * kTileHitArea;
  }

  BoggleTileData? _tileClosestToPoint(Vector2 point) {
    BoggleTileData? closest;
    double minDistance = tileSize;
    for (var tile in allTiles) {
      var distance =
          point.distanceTo(tile.position + Vector2.all(tileSize * 0.5));
      if (distance < minDistance) {
        minDistance = distance;
        closest = tile;
      }
    }
    return closest;
  }
}
