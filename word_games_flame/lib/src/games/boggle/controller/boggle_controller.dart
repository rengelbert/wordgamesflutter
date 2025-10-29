import 'package:flame/extensions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../views/boggle_game.dart';
import '../../../config/app_config.dart';
import '../../../service/dictionary.dart';
import '../data/boggle_model.dart';
import '../views/boggle_tile.dart';

class BoggleController extends GetxController {
  final BoggleData _gameModel = BoggleData();
  final List<FlameBoggleTile> allTiles = [];
  final List<FlameBoggleTile> _selectedTiles = [];

  late final DictionaryService _dictionary;
  late FlameBoggle game;

  FlameBoggleTile? _selectedTile;

  static const kTileHitArea = 0.6;

  String get spelling => _selectedTiles.map((t) => t.value).join();
  String get score => _gameModel.score.toString();

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
    final tileSize = (canvasWidth - totalHorizontalGridSpace) / columns;

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
        var tile = FlameBoggleTile(
            value: letterPool.removeLast().toUpperCase(),
            row: r,
            column: c,
            tileSize: tileSize);
        tile.position.x = gridPosition.x + (c * (tileSize + spc));
        tile.position.y = gridPosition.y + r * (tileSize + spc);
        allTiles.add(tile);
      }
    }
  }

  void selectTile(FlameBoggleTile tile) {
    bool canSelect = false;
    if (_selectedTile == null) {
      //this is our firest tile selected
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
        _selectedTile!.select(true);
        _selectedTile!.bgColor = selectedBgColor;
        _selectedTile!.labelColor = selectedLabelColor;
        _selectedTiles.add(_selectedTile!);
      } else {
        if (_selectedTiles.length > 1) {
          //deselect tile if it's already been added to selected tiles
          var index = _selectedTiles.indexOf(tile);
          for (var i = _selectedTiles.length - 1; i >= 0; i--) {
            var tile = _selectedTiles[i];
            if (i > index) {
              tile.select(false);
              tile.bgColor = normalBgColor;
              _selectedTiles.removeAt(i);
            }
          }
          _selectedTile = _selectedTiles[_selectedTiles.length - 1];
        }
      }
    }
  }

  void onTouchStart(Vector2 touch) {
    if (_active == false) return;
    var tile = _tileClosestToPoint(touch);

    if (tile != null && isTouchingTile(tile, touch)) {
      selectTile(tile);
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
    }

    Future.delayed(const Duration(milliseconds: 800)).then((value) {
      _active = true;
      for (var tileData in _selectedTiles) {
        tileData.select(false);
        tileData.bgColor = normalBgColor;
      }
      _selectedTiles.clear();
      _selectedTile = null;
    });
  }

  bool isTouchingTile(FlameBoggleTile tile, Vector2 point) {
    var tileSize = tile.tileSize;
    var distance =
        point.distanceTo(tile.position + Vector2.all(tile.tileSize * 0.5));
    return distance <= tileSize * kTileHitArea;
  }

  FlameBoggleTile? _tileClosestToPoint(Vector2 point) {
    FlameBoggleTile? closest;
    double minDistance = allTiles[0].tileSize;
    for (var tile in allTiles) {
      var distance =
          point.distanceTo(tile.position + Vector2.all(tile.tileSize * 0.5));
      if (distance < minDistance) {
        minDistance = distance;
        closest = tile;
      }
    }

    return closest;
  }
}
