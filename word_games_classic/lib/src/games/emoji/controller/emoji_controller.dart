import 'package:dart_core/emoji_data.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../config/app_config.dart';
import '../../../service/dictionary.dart';
import '../../../utils/vector2.dart';
import '../data/emoji_game_data.dart';
import '../data/tile_data.dart';

class EmojiController extends GetxController {
  static const alpha = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];
  late EmojiGameData _gameModel;
  late final DictionaryService _dictionary;
  late final EmojiWordData _emojiWordData;

  EmojiTileData? _selectedTile;

  static const kTileHitArea = 0.6;

  List<EmojiTileData> get allTiles => _gameModel.allTiles;

  double tileSize = 0;
  bool _active = true;

  bool get hasUndo => _gameModel.changeHistory.isNotEmpty;

  Future<void> initGame() async {
    _dictionary = DictionaryService();
    await _dictionary.initWithFile('assets/data/dictionary.txt');
    final gameWordsData = await rootBundle.loadString('assets/data/10k.txt');
    final gameWords = <String>[];
    gameWords.addAll(gameWordsData.split('\n'));
    _emojiWordData = EmojiWordData(gameWords);

    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  void newGame({int seed = 100, bool refresh = false}) {
    if (refresh == false && _emojiWordData.letterPool.isNotEmpty) return;

    _selectedTile = null;
    _gameModel = EmojiGameData();
    _emojiWordData.generatePuzzle(5, 0.6, 0.7, 5, 6);
    _gameModel.newGame(_emojiWordData);

    _buildGrid(_emojiWordData.puzzleWords.length, _emojiWordData.longestWord);

    update();
  }

  void updateTiles() {
    final over = _gameModel.isGameOver(_dictionary.dictionary);

    if (over) {
      _active = false;
      Future.delayed(const Duration(milliseconds: 2000)).then((value) {
        _active = true;
        _selectedTile?.selected = false;
        _selectedTile = null;
        newGame(refresh: true);
        update();
      });
    }
    _clearSelection();
    update();
  }

  void undoChange() {
    _gameModel.undoChange();
    update();
  }

  void _buildGrid(int rows, int columns) {
    //make space a fraction of total width
    var h_spc = AppConfig.screenWidth * 0.01;
    var v_spc = AppConfig.screenHeight * 0.035;

    //make horizontal margin (left and right) 10% of screen width
    var hMargin = AppConfig.screenWidth * 0.1;

    //actual width we have for grid (total width - margins)
    var canvasWidth = AppConfig.screenWidth - (2 * hMargin);

    //total horizontal amount taken up by space between tiles
    var totalHorizontalGridSpace = (columns - 1) * h_spc;

    //total vertical amount taken up by space between tiles
    var totalVerticalGridSpace = (rows - 1) * v_spc;

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

    var r = 0;

    for (var tiles in _gameModel.wordToTilesMap.values) {
      for (var i = 0; i < tiles.length; i++) {
        var tile = tiles[i];
        tile.position.x = gridPosition.x + (i * (tileSize + h_spc));
        tile.position.y = gridPosition.y + r * (tileSize + v_spc);
      }
      r += 1;
    }
  }

  void _clearSelection() {
    for (var tile in _gameModel.allTiles) {
      tile.selected = false;
    }
  }

  void onTouchDown(Vector2 touch) {
    var tile = _tileClosestToPoint(touch);
    if (tile != null && isTouchingTile(tile, touch)) {
      if (_selectedTile != null) {
        _selectedTile!.selected = false;
      }
      if (tile.emoji.isEmpty) return;
      if (tile.input.isNotEmpty) return;
      _selectedTile = tile;
      _selectedTile!.selected = true;
      SystemChannels.textInput.invokeMethod("TextInput.show");
      update();
    }
  }

  void onLongTouch() {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
    _selectedTile?.selected = false;
    _selectedTile = null;
  }

  bool isTouchingTile(EmojiTileData tile, Vector2 point) {
    var distance =
        point.distanceTo(tile.position + Vector2.all(tileSize * 0.5));
    return distance <= tileSize * kTileHitArea;
  }

  EmojiTileData? _tileClosestToPoint(Vector2 point) {
    EmojiTileData? closest;
    double minDistance = tileSize;
    for (var tile in _gameModel.allTiles) {
      var distance =
          point.distanceTo(tile.position + Vector2.all(tileSize * 0.5));
      if (distance < minDistance) {
        minDistance = distance;
        closest = tile;
      }
    }
    return closest;
  }

  bool _onKey(KeyEvent event) {
    if (_selectedTile == null) {
      return false;
    }
    final key = event.logicalKey.keyLabel;
    if (event is KeyDownEvent) {
      if (alpha.contains(key.toLowerCase())) {
        _selectedTile!.input = key.toUpperCase();
        _gameModel.addChange(_selectedTile!);
        for (var tile in _gameModel.allTiles) {
          if (tile != _selectedTile! &&
              tile.emoji.isNotEmpty &&
              tile.emoji == _selectedTile!.emoji) {
            tile.input = key.toUpperCase();
          }
        }
        _selectedTile?.selected = false;
        _selectedTile = null;
        updateTiles();

        SystemChannels.textInput.invokeMethod("TextInput.hide");
      }
    }
    return false;
  }
}
