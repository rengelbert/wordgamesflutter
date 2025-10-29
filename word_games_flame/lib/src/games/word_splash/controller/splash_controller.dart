import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/extensions.dart';
import 'package:get/get.dart';
import '../../../config/app_config.dart';
import '../data/splash_model.dart';
import '../../../service/dictionary.dart';
import '../views/word_splash_game.dart';
import '../views/word_splash_tile.dart';

class WordsSplashController extends GetxController {
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

  static const kTileHitArea = 0.65;

  WordSplashTile? _selectedTile;

  final List<WordSplashTile> allTiles = [];
  final List<WordSplashTile> _selectedTiles = [];
  WordSplashTile? selectedTile;

  late final WordSplashModel _gameData;
  late final DictionaryService _dictionary;
  late final FlameWordSplash game;

  List<WordSplashTile> get tiles => allTiles;
  String get spelling => _selectedTiles.map((t) => t.value).join();

  Future<void> initGame() async {
    _dictionary = DictionaryService();
    await _dictionary.init();
    _gameData = await WordSplashModel.data();
  }

  List<TargetWord> get targets => _gameData.targetWords;

  void newRound([int seed = 100]) {
    _gameData.newRound(5, seed);

    // generate tiles
    buildGrid();
  }

  void onNewUserWord() {
    final word = spelling.toLowerCase();

    if (_checkWord(word)) {
      if (_gameData.addNewWord(word)) {
        // new word
        if (_isTargetWord(word)) {
          // this is a target word
          final wordLeft = targets.where((t) => t.found == false).lastOrNull;
          if (wordLeft == null) {
            //we found all words, delay and start new round
            Future.delayed(const Duration(seconds: 3)).then((value) {
              game.newGame();
              update();
            });
          }
        }
      }
    } else {
      // not a word
    }
    clearSelection();
    update();
  }

  bool _checkWord(String word) => _dictionary.dictionary.isWord(word);

  bool _isTargetWord(String word) {
    final result = _gameData.isTargetWord(word);
    return result;
  }

  void buildGrid() {
    const columns = 3; //this will give us 9 possible spots for our tiles
    const rows = 3;

    //make space a fraction of total width
    var spc = AppConfig.screenWidth * 0.08;

    //make horizontal margin (left and right) 10% of screen width
    var hMargin = AppConfig.screenWidth * 0.15;

    //actual width we have for grid (total width - margins)
    var canvasWidth = AppConfig.screenWidth - (2 * hMargin);

    //total horizontal amount taken up by space between tiles
    var totalHorizontalGridSpace = (columns - 1) * spc;

    //the tile size (based on width)
    final tileSize = (canvasWidth - totalHorizontalGridSpace) / columns;

    final gridWidth = (columns) * (tileSize) + totalHorizontalGridSpace;

    //the offset position of the grid, here centered, but
    //any other offset can be stated here
    final gridPosition = Vector2(
      (AppConfig.screenWidth - gridWidth) * 0.5,
      AppConfig.screenHeight * 0.3,
    );

    rotations.shuffle();

    //generare temp tiles
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < columns; c++) {
        var tile = WordSplashTile(tileSize: tileSize);
        allTiles.add(tile);
        tile.position.x = gridPosition.x + (c * (tileSize + spc));
        tile.position.y = gridPosition.y + r * (tileSize + spc);
      }
    }

    allTiles.shuffle();

    allTiles.removeRange(_gameData.letterPool.length, allTiles.length);

    for (var i = 0; i < allTiles.length; i++) {
      final tile = allTiles[i];
      tile.label.text = tile.value = _gameData.letterPool[i].toUpperCase();
      tile.angle = rotations[i];
    }
  }

  void clearSelection() {
    for (var tileData in allTiles) {
      tileData.select(false);
    }

    _selectedTiles.clear();
    _selectedTile = null;
    update();
  }

  void selectTile(WordSplashTile tile) {
    _selectedTile = tile;
    if (!_selectedTiles.contains(_selectedTile)) {
      _selectedTile?.select(true);
      _selectedTiles.add(_selectedTile!);
    } else {
      if (_selectedTiles.length > 1) {
        //deselect tile if it's already been added to selected tiles
        var index = _selectedTiles.indexOf(tile);
        for (var i = _selectedTiles.length - 1; i >= 0; i--) {
          var tile = _selectedTiles[i];
          if (i > index) {
            tile.select(false);
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

  //started dragging
  void onTouchStart(Vector2 touch) {
    clearSelection();
    var tile = _tileClosestToPoint(touch);
    if (tile != null && isTouchingTile(tile, touch)) {
      selectTile(tile);
      update();
    }
  }

  //on dragging
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

  bool isTouchingTile(WordSplashTile tile, Vector2 point) {
    final tileSize = tile.tileSize;
    var distance =
        point.distanceTo(tile.position + Vector2.all(tileSize * 0.5));
    return distance <= tileSize * kTileHitArea;
  }

  WordSplashTile? _tileClosestToPoint(Vector2 point) {
    WordSplashTile? closest;
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
