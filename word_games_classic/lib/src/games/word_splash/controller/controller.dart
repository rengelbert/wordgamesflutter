import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../../config/app_config.dart';
import '../../../utils/vector2.dart';
import '../data/splash_model.dart';
import '../data/splash_tile_data.dart';
import '../../../service/dictionary.dart';

class WordsSplashController extends GetxController {
  static const kRows = 3;
  static const kColumns = 3;
  static const kTileHitArea = 0.5;

  static List<double> rotations = [
    -pi / 10.0,
    pi / 10.0,
    -pi / 12.0,
    pi / 12.0,
    -pi / 15.0,
    pi / 15.0,
    -pi / 20.0,
    pi / 20.0,
    0,
  ];

  final List<WordSplashTileData> _tiles = [];
  final List<WordSplashTileData> _selectedTiles = [];

  double tileSize = 100.0;

  WordSplashTileData? _selectedTile;

  late final WordSplashModel _gameData;
  late final DictionaryService _dictionary;

  List<WordSplashTileData> get tiles => _tiles;
  String get spelling => _selectedTiles.map((t) => t.value).join();

  Future<void> initGame() async {
    _dictionary = DictionaryService();
    await _dictionary.init();
    _gameData = await WordSplashModel.data();
  }

  List<TargetWord> get targets => _gameData.targetWords;

  void newRound([int seed = 100]) {
    _gameData.newRound(5, seed);

    rotations.shuffle();
    buildGrid();
  }

  void onNewUserWord() {
    final word = spelling.toLowerCase();

    if (_dictionary.dictionary.isWord(word)) {
      if (_gameData.addNewWord(word)) {
        if (_gameData.isTargetWord(word)) {
          //word is a target word
          final wordLeft = targets.where((t) => t.found == false).lastOrNull;
          if (wordLeft == null) {
            //we found all words, delay and start new round
            Future.delayed(const Duration(seconds: 3)).then((value) {
              newRound(1001);
              update();
            });
          }
        }
      }
    } else {
      // this is not a word!
    }
    clearSelection();
    update();
  }

  void buildGrid() {
    //make space a fraction of total width
    var spc = AppConfig.screenWidth * 0.08;

    //make horizontal margin (left and right) 10% of screen width
    var hMargin = AppConfig.screenWidth * 0.1;

    //actual width we have for grid (total width - margins)
    var canvasWidth = AppConfig.screenWidth - (2 * hMargin);

    //total horizontal amount taken up by space between tiles
    var totalHorizontalGridSpace = (kColumns - 1) * spc;

    //total vertical amount taken up by space between tiles
    //var totalVerticalGridSpace = (rows - 1) * spc;

    //the tile size (based on width)
    tileSize = (canvasWidth - totalHorizontalGridSpace) / kColumns;

    // total width and height of the grid
    // final gridHeight =
    //     (rows * tileSize) + totalVerticalGridSpace;
    final gridWidth = (kColumns) * (tileSize) + totalHorizontalGridSpace;

    //the offset position of the grid, here centered, but
    //any other offset can be stated here
    final position = Vector2(
      (AppConfig.screenWidth - gridWidth) * 0.5,
      100,
    );

    _tiles.clear();
    //generare temp tiles
    for (var r = 0; r < kRows; r++) {
      for (var c = 0; c < kColumns; c++) {
        var tile = WordSplashTileData();
        tile.position.x = position.x + (c * (tileSize + spc));
        tile.position.y = position.y + r * (tileSize + spc);
        _tiles.add(tile);
      }
    }
    _tiles.shuffle();
    //now, with the grid shuffled, assign character from pool
    //remove all extra tiles
    _tiles.removeRange(_gameData.letterPool.length, _tiles.length);
    for (var i = _tiles.length - 1; i >= 0; i--) {
      _tiles[i].value = _gameData.letterPool[i].toUpperCase();
      _tiles[i].rotation = rotations[i];
    }
  }

  void clearSelection() {
    for (var tileData in _tiles) {
      tileData.selected = false;
    }

    _selectedTiles.clear();
    _selectedTile = null;
    update();
  }

  void selectTile(WordSplashTileData tile) {
    _selectedTile = tile;
    if (!_selectedTiles.contains(_selectedTile)) {
      _selectedTile!.selected = true;
      _selectedTiles.add(_selectedTile!);
    } else {
      if (_selectedTiles.length > 1) {
        //deselect tile if it's already been added to selected tiles
        var index = _selectedTiles.indexOf(tile);
        for (var i = _selectedTiles.length - 1; i >= 0; i--) {
          var tile = _selectedTiles[i];
          if (i > index) {
            tile.selected = false;
            _selectedTiles.removeAt(i);
          }
        }
        if (_selectedTiles.isNotEmpty) {
          _selectedTile = _selectedTiles[_selectedTiles.length - 1];
        }
      }
    }

    update();
  }

  void onTouchStart(Vector2 touch) {
    clearSelection();
    var tile = _tileClosestToPoint(touch);
    if (tile != null && isTouchingTile(tile, touch)) {
      selectTile(tile);
      update();
    }
  }

  void onTouchMove(Vector2 touch) {
    var nextTile = _tileClosestToPoint(touch);
    if (nextTile != null &&
        nextTile != _selectedTile &&
        isTouchingTile(nextTile, touch)) {
      selectTile(nextTile);
      update();
    }
  }

  void onTouchEnd() {
    if (_selectedTile == null) {
      clearSelection();
      return;
    }
    if (_selectedTiles.length > 2) {
      onNewUserWord();
    }

    update();
  }

  bool isTouchingTile(WordSplashTileData tile, Vector2 point) {
    var distance =
        point.distanceTo(tile.position + Vector2.all(tileSize * 0.5));
    return distance <= tileSize * kTileHitArea;
  }

  WordSplashTileData? _tileClosestToPoint(Vector2 point) {
    WordSplashTileData? closest;
    double minDistance = tileSize;
    for (var tile in _tiles) {
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
